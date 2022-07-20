;*********************************************************************
;*								*
;*	------------------------				*
;*		STARFOX2 					*
;*	------------------------				*
;*								*
;*	File 		: oamdata.asm				*
;* 	Description	: oamdata extra				*
;*	Date		: 1994.8.16				*
;*	Author		: H.Yajima				*
;*								*
;*********************************************************************
;
;
;
;
;
;---------------------------------------------------------------------
	INCPUB	oamdata
;---------------------------------------------------------------------
;
;
;***********************************************************************
;	COMPRESS NEWS !!!
;***********************************************************************
;;
;; << bs_message_  >>  NO object data HA MUDA ga OOI !!!
;;
;;======================================================================


;***********************************************************************
;;        ----------------------------
;;	oamdata macros
;;        ----------------------------
;***********************************************************************
;;MSseq_liststart	macro
;;MSseq_list		macro	[name,seqaddr,oamaddr]
;;Msprdata		macro	[h,v,fp,pno,ano,char]
;;Mmesobj		macro	[x,y,fp,pno,ano,char]
;---------------------------------------------------------------------
MSseq_liststart macro
seqlist = 0
	endm

;---------------------------------------------------------------------
MSseq_list	macro	[name,seqaddr]
	dw	{seqaddr}&WM
{name}	equ	seqlist
seqlist = seqlist+1
	endm

;---------------------------------------------------------------------
Mmesobj	macro	[x,y,fp,pno,ano,char]
	db	{x},{y}
	db	{char}+40h
	db	oamdata_pri{pno}+oamdata_attr{ano}+oamdata_{fp}flip
	endm

;---------------------------------------------------------------------


;***********************************************************************
;;        ----------------------------
;;	sprite animation table
;;        ----------------------------
;***********************************************************************

New_oamlist
	MSseq_liststart
;-- face ---------
	MSseq_list	ys_foxSTpose,seq_foxst
	MSseq_list	ys_foxOKpose,seq_foxok
	MSseq_list	ys_falcoSTpose,seq_falcost
	MSseq_list	ys_falcoOKpose,seq_falcook
	MSseq_list	ys_peppySTpose,seq_peppyst
	MSseq_list	ys_peppyOKpose,seq_peppyok
	MSseq_list	ys_slippySTpose,seq_slippyst
	MSseq_list	ys_slippyOKpose,seq_slippyok
	MSseq_list	ys_catSTpose,seq_catst
	MSseq_list	ys_catOKpose,seq_catok
	MSseq_list	ys_girlSTpose,seq_girlst
	MSseq_list	ys_girlOKpose,seq_girlok

;-- plane ---------

	MSseq_list	ys_foxplane,seq_foxplane
	MSseq_list	ys_falcoplane,seq_falcoplane
	MSseq_list	ys_peppyplane,seq_peppyplane
	MSseq_list	ys_slippyplane,seq_slippyplane
	MSseq_list	ys_catplane,seq_catplane
	MSseq_list	ys_girlplane,seq_girlplane

;-- fire ----------
	MSseq_list	ys_planefire,seq_planefire

;-- open/close ----
	MSseq_list	ys_planeopen,seq_planeopen
	MSseq_list	ys_planeclose,seq_planeclose
	MSseq_list	ys_faceopen,seq_faceopen
	MSseq_list	ys_faceclose,seq_faceclose
	MSseq_list	ys_faceclosenext,seq_faceclosenext

;-- big number ----
	MSseq_list	ys_big0,seq_bignum_0
	MSseq_list	ys_big1,seq_bignum_1
	MSseq_list	ys_big2,seq_bignum_2
	MSseq_list	ys_big3,seq_bignum_3
	MSseq_list	ys_big4,seq_bignum_4
	MSseq_list	ys_big5,seq_bignum_5
	MSseq_list	ys_big6,seq_bignum_6
	MSseq_list	ys_big7,seq_bignum_7
	MSseq_list	ys_big8,seq_bignum_8
	MSseq_list	ys_big9,seq_bignum_9
	MSseq_list	ys_target,seq_bigtarget

;-- stage ready start -----
	MSseq_list	ys_ready0,seq_ready0
	MSseq_list	ys_ready1,seq_ready1
	MSseq_list	ys_ready2,seq_ready2
	MSseq_list	ys_ready3,seq_ready3
	MSseq_list	ys_ready4,seq_ready4


;-- game pausemap player animation ------

	MSseq_list	ys_pausemapplayer,seq_pausemapplayer

;-- title objanimation ------------------

	MSseq_list	ys_titleface,seq_titleface
	MSseq_list	ys_titleplanet,seq_titleplanet
	MSseq_list	ys_titlestart,seq_titlestart
	MSseq_list	ys_titlenintendo,seq_titlenintendo

;-- player select -----------------------

	MSseq_list	ys_keyconfig,seq_keyconfig

;-- enemy gone --------------------------

	MSseq_list	ys_enemygone,seq_enemygone


;-- bestscore/nameset --------------------

	MSseq_list	ys_bs_cursoropen,seq_cursor_open
	MSseq_list	ys_bs_cursor,seq_bs_cursor
	MSseq_list	ys_bs_fire,seq_fire
	MSseq_list	ys_bs_fireOK,seq_fireOK


	MSseq_list	ys_bs_scorebar,seq_e1_1_2
	MSseq_list	ys_bs_namecursor,seq_e1_1_1

	MSseq_list	ys_bs_message1,seq_bs_message1
	MSseq_list	ys_bs_message_lookscore,seq_bs_message_lookscore
	MSseq_list	ys_bs_message_erasescore,seq_bs_message_erasescore
	MSseq_list	ys_bs_message_erasescoreOK,seq_bs_message_erasescoreOK
	MSseq_list	ys_bs_message_erasescoreEXEC,seq_bs_message_erasescoreEXEC
	MSseq_list	ys_bs_message_datanothing,seq_bs_message_datanothing
	MSseq_list	ys_bs_message_erasecursor,seq_bs_message_erasecursor

	MSseq_list	ys_bs_faceopen,seq_bs_faceopen
	MSseq_list	ys_bs_facemouth,seq_bs_facemouth
	MSseq_list	ys_bs_faceclose,seq_bs_faceclose
	MSseq_list	ys_bs_fingerselect,seq_fingerselect
	MSseq_list	ys_bs_fingerOK,seq_fingerOK

	MSseq_list	ys_bs_coindisp,seq_coindisp

;-----------------------------------------




;***********************************************************************
;;        ----------------------------
;;	oam blockdata table
;;        ----------------------------
;***********************************************************************

oam_testtable
	Mindexliststart
	Mindexlist	oam_nothing	; "sprite clear"

	Mindexlist	obj_ready_r	; (stage) "ready"
	Mindexlist	obj_ready_e
	Mindexlist	obj_ready_a
	Mindexlist	obj_ready_d
	Mindexlist	obj_ready_y

	Mindexlist	obj_d2_0_0	; "fox face"
	Mindexlist	obj_d2_0_1
	Mindexlist	obj_d2_0_2
	Mindexlist	obj_d2_0_4
	Mindexlist	obj_d2_0_5

	Mindexlist	obj_d2_1_0	; "falco face"
	Mindexlist	obj_d2_1_1
	Mindexlist	obj_d2_1_2
	Mindexlist	obj_d2_1_3
	Mindexlist	obj_d2_1_4

	Mindexlist	obj_d2_2_0	; "peppy face"
	Mindexlist	obj_d2_2_1
	Mindexlist	obj_d2_2_2
	Mindexlist	obj_d2_2_3
	Mindexlist	obj_d2_2_4

	Mindexlist	obj_d2_3_0	; "slippy face"
	Mindexlist	obj_d2_3_1
	Mindexlist	obj_d2_3_2
	Mindexlist	obj_d2_3_3
	Mindexlist	obj_d2_3_4

	Mindexlist	obj_d2_4_0	; "cat face"
	Mindexlist	obj_d2_4_1
	Mindexlist	obj_d2_4_2
	Mindexlist	obj_d2_4_3
	Mindexlist	obj_d2_4_4

	Mindexlist	obj_d2_5_0	; "girl face"
	Mindexlist	obj_d2_5_1
	Mindexlist	obj_d2_5_2
	Mindexlist	obj_d2_5_3
	Mindexlist	obj_d2_5_4
	Mindexlist	obj_d2_5_5

	Mindexlist	obj_d4_1_0	; "plane sprite"
	Mindexlist	obj_d4_1_2
	Mindexlist	obj_d4_1_4

	Mindexlist	obj_d4_1_8	; "plane fire sprite"
	Mindexlist	obj_d4_1_9
	Mindexlist	obj_d4_1_10

	Mindexlist	obj_d4_0_0	; "face shutter"
	Mindexlist	obj_d4_0_1
	Mindexlist	obj_d4_0_2
	Mindexlist	obj_d4_0_3
	Mindexlist	obj_d4_0_4

	Mindexlist	obj_e4_1_4	; "plane shutter"
	Mindexlist	obj_e4_1_5
	Mindexlist	obj_e4_1_6
	Mindexlist	obj_e4_1_7
	Mindexlist	obj_e4_1_8
	Mindexlist	obj_e4_1_9

	Mindexlist	obj_w0_1_0	; "big number 0-9"
	Mindexlist	obj_w0_1_1
	Mindexlist	obj_w0_1_2
	Mindexlist	obj_w0_1_3
	Mindexlist	obj_w0_1_4
	Mindexlist	obj_w0_1_5
	Mindexlist	obj_w0_1_6
	Mindexlist	obj_w0_1_7
	Mindexlist	obj_w0_1_8
	Mindexlist	obj_w0_1_9

	Mindexlist	obj_target	; "target object"

	Mindexlist	obj_w0_2_0	; "pausemap plaeyer anime"
	Mindexlist	obj_w0_2_1
	Mindexlist	obj_w0_2_2
	Mindexlist	obj_w0_2_3
	Mindexlist	obj_w0_2_4
	Mindexlist	obj_w0_2_5
	Mindexlist	obj_w0_2_6
	Mindexlist	obj_w0_2_7
	Mindexlist	obj_w0_2_8
	Mindexlist	obj_w0_2_9
	Mindexlist	obj_w0_2_10
	Mindexlist	obj_w0_2_11

	Mindexlist	obj_keyconfig
	Mindexlist	obj_typeA
	Mindexlist	obj_typeB
	Mindexlist	obj_typeC
	Mindexlist	obj_typeD

	Mindexlist	obj_titleface1
	Mindexlist	obj_titleplanet
	Mindexlist	obj_titlestart
	Mindexlist	obj_titlenintendo

	Mindexlist	obj_enemygone

	Mindexlist	obj_bs_cursor
	Mindexlist	obj_bs_erasecursor

	Mindexlist	obj_e1_1_0
	Mindexlist	obj_e1_1_1
	Mindexlist	obj_e1_1_2
	Mindexlist	obj_e1_1_3
	Mindexlist	obj_e1_1_4
	Mindexlist	obj_e1_1_5
	Mindexlist	obj_e1_1_6
	Mindexlist	obj_e1_1_7
	Mindexlist	obj_e1_1_8
	Mindexlist	obj_e1_1_9
	Mindexlist	obj_e1_1_10
	Mindexlist	obj_e1_1_11
	Mindexlist	obj_e1_1_12
	Mindexlist	obj_e1_1_13
	Mindexlist	obj_e1_1_14
	Mindexlist	obj_e1_1_15
	Mindexlist	obj_e1_1_16
	Mindexlist	obj_e1_1_17
	Mindexlist	obj_e1_1_18
	Mindexlist	obj_e1_1_19
	Mindexlist	obj_e1_1_20
	Mindexlist	obj_e1_1_21
	Mindexlist	obj_e1_1_22

	Mindexlist	obj_e1_1_63

	Mindexlist	obj_bs_message1
	Mindexlist	obj_bs_message2
	Mindexlist	obj_bs_message3
	Mindexlist	obj_bs_message4
	Mindexlist	obj_bs_message5
	Mindexlist	obj_bs_message6

	Mindexlist	obj_scoreface_0
	Mindexlist	obj_scoreface_1
	Mindexlist	obj_scoreface_2
	Mindexlist	obj_scoreface_3
	Mindexlist	obj_scoreface_4
	Mindexlist	obj_scoreface_5
	Mindexlist	obj_scoreface_6

	Mindexlist	obj_finger_1
	Mindexlist	obj_finger_2
	Mindexlist	obj_finger_3
	Mindexlist	obj_finger_ok

	Mindexlist	obj_coin_1
	Mindexlist	obj_coin_2
	Mindexlist	obj_coin_3
	Mindexlist	obj_coin_4


	Mindexlistend_print


;**************************************************************************
;	------------------------------
;	 bestscore coin obj animation 
;	------------------------------
;**************************************************************************


;----------------------------------------------
seq_coindisp
	db	8,idx_obj_coin_1
	db	8,idx_obj_coin_2
	db	8,idx_obj_coin_3
	db	8,idx_obj_coin_4
	MSseq_end

;----------------------------------------------
obj_coinclear_message
	MSoam_small	5
	db	 8+4-1,0,09bh,30h
	db	16+4-1,0,09ch,30h
	db	24+4-1,0,09dh,30h
	db	32+4-1,0,09eh,30h
	db	40+4-1,0,09fh,30h

;----------------------------------------------
obj_cointotal_message
	MSoam_small	3
	db	 8+4,0,0d0h,30h
	db	16+4,0,0d1h,30h
	db	24+4,0,0d2h,30h

;----------------------------------------------
obj_coin_1	MSoam_small 4
	db	-8,-8,0d3h,30h
	db	 0,-8,0d4h,30h
	db	-8,0,0d5h,30h
	db	 0,0,0d6h,30h

;----------------------------------------------
obj_coin_2	MSoam_small 4
	db	-8,-8,0d7h,30h
	db	 0,-8,0d8h,30h
	db	-8,0,0d9h,30h
	db	 0,0,0dah,30h

;----------------------------------------------
obj_coin_3	MSoam_small 4
	db	-8,-8,0cbh,30h
	db	 0,-8,0cbh,30h+40h
	db	-8,0,0dbh,30h
	db	 0,0,0dbh,30h+40h

;----------------------------------------------
obj_coin_4	MSoam_small 4
	db	-8,-8,0d8h,30h+40h
	db	 0,-8,0d7h,30h+40h
	db	-8,0,0dah,30h+40h
	db	 0,0,0d9h,30h+40h

;----------------------------------------------
;;
;;
;;
;;
;;
;**************************************************************************
;	score finger data
;**************************************************************************

seq_fingerselect
	db	0ah,idx_obj_finger_1
	db	08h,idx_obj_finger_2
	db	08h,idx_obj_finger_3
	db	08h,idx_obj_finger_2
	MSseq_end

seq_fingerok
	db	3,idx_obj_finger_ok
	MSseq_end

obj_finger_1
	MSoam_small	6
	db	008h,000h,012h,032h
	db	000h,000h,011h,032h
	db	0f8h,000h,010h,032h
	db	008h,0f8h,002h,032h
	db	000h,0f8h,001h,032h
	db	0f8h,0f8h,000h,032h

obj_finger_2
	MSoam_small	4
	db	000h,000h,014h,032h
	db	0f8h,000h,013h,032h
	db	000h,0f8h,004h,032h
	db	0f8h,0f8h,003h,032h

obj_finger_3
	MSoam_small	4
	db	000h,000h,016h,032h
	db	0f8h,000h,015h,032h
	db	000h,0f8h,006h,032h
	db	0f8h,0f8h,005h,032h

obj_finger_ok
	MSoam_small	5
	db	0f8h,0f0h,009h,032h
	db	000h,000h,018h,032h
	db	0f8h,000h,017h,032h
	db	000h,0f8h,008h,032h
	db	0f8h,0f8h,007h,032h

;**************************************************************************
;	score face data
;**************************************************************************

;-----------------------------------------------
seq_bs_faceopen
	db	1,idx_obj_scoreface_0
	db	1,idx_obj_scoreface_1
	db	1,idx_obj_scoreface_2
	db	1,idx_obj_scoreface_3
	db	1,idx_obj_scoreface_4
.loop	db	8,idx_obj_scoreface_5
	MSseq_jmp	.loop



seq_bs_facemouth
	db	8,idx_obj_scoreface_5
	db	8,idx_obj_scoreface_6
	db	8,idx_obj_scoreface_5
	db	8,idx_obj_scoreface_6
	db     16,idx_obj_scoreface_5
	db	8,idx_obj_scoreface_6
	db	8,idx_obj_scoreface_5
	db	8,idx_obj_scoreface_6
.loop	db	8,idx_obj_scoreface_5
	MSseq_jmp	.loop

;-----------------------------------------------
seq_bs_faceclose
	db	1,idx_obj_scoreface_4
	db	1,idx_obj_scoreface_3
	db	1,idx_obj_scoreface_2
	db	1,idx_obj_scoreface_1
	db	1,idx_obj_scoreface_0
	db	50,idx_oam_nothing
;-----------------------------------------------




obj_scoreface_0
	MSoam_big	2
	db	000h,0f8h,022h,030h
	db	0f0h,0f8h,022h,030h

obj_scoreface_1
	MSoam_small	8
	db	000h,000h,021h,0f0h
	db	008h,000h,020h,0f0h
	db	000h,0f8h,021h,070h
	db	008h,0f8h,020h,070h
	db	0f8h,000h,021h,0b0h
	db	0f0h,000h,020h,0b0h
	db	0f8h,0f8h,021h,030h
	db	0f0h,0f8h,020h,030h

obj_scoreface_2
	MSoam_big	4
	db	000h,0fch,020h,0f0h
	db	0f0h,0fch,020h,0b0h
	db	000h,0f4h,020h,070h
	db	0f0h,0f4h,020h,030h

obj_scoreface_3
	MSoam_big	4
	db	0f0h,000h,020h,0b0h
	db	000h,000h,020h,0f0h
	db	000h,0f0h,020h,070h
	db	0f0h,0f0h,020h,030h

obj_scoreface_4
	MSoam_big	6
	db	000h,008h,020h,0f0h
	db	000h,0f8h,030h,070h
	db	000h,0e8h,020h,070h
	db	0f0h,008h,020h,0b0h
	db	0f0h,0f8h,030h,030h
	db	0f0h,0e8h,020h,030h

obj_scoreface_5
	MSoam_big	6
	db	000h,008h,0e6h,030h
	db	0f0h,008h,0e4h,030h
	db	000h,0f8h,0e2h,030h
	db	0f0h,0f8h,0e0h,030h
	db	000h,0e8h,0ceh,030h
	db	0f0h,0e8h,0cch,030h

obj_scoreface_6
	MSoam_big	6
	db	000h,008h,0eeh,030h
	db	0f0h,008h,0ech,030h
	db	000h,0f8h,0eah,030h
	db	0f0h,0f8h,0e8h,030h
	db	000h,0e8h,0ceh,030h
	db	0f0h,0e8h,0cch,030h


;**************************************************************************
;	Object Draw Message
;**************************************************************************
;;
;; 1 .... name input
;; 2 .... look score
;; 3 .... erase score
;; 4 .... erase OK ?
;; 5 .... erase RUN !!
;; 6 .... data nothing !!

seq_bs_message1
	db	20h,idx_obj_bs_message1
	db	20h,idx_oam_nothing
	MSseq_end

obj_bs_message1
	MSoam_small	12
	Msprdata	8*0,0,n,3,1,060h
	Msprdata	8*1,0,n,3,1,061h
	Msprdata	8*2,0,n,3,1,062h
	Msprdata	8*3,0,n,3,1,063h
	Msprdata	8*4,0,n,3,1,064h
	Msprdata	8*5,0,n,3,1,065h
	Msprdata	8*6,0,n,3,1,066h
	Msprdata	8*7,0,n,3,1,067h
	Msprdata	8*8,0,n,3,1,068h
	Msprdata	8*9,0,n,3,1,069h
	Msprdata	8*10,0,n,3,1,06ah
	Msprdata	8*11,0,n,3,1,06bh


seq_bs_message_lookscore
	db	20h,idx_obj_bs_message2
.loop
	db	20h,idx_obj_bs_message2
	db	20h,idx_oam_nothing
	MSseq_jmp	.loop

obj_bs_message2
	MSoam_small	16
	Msprdata	8*0,0,n,3,1,070h
	Msprdata	8*1,0,n,3,1,071h
	Msprdata	8*2,0,n,3,1,072h
	Msprdata	8*3,0,n,3,1,073h
	Msprdata	8*4,0,n,3,1,074h
	Msprdata	8*5,0,n,3,1,075h
	Msprdata	8*6,0,n,3,1,076h
	Msprdata	8*7,0,n,3,1,077h
	Msprdata	8*8,0,n,3,1,078h
	Msprdata	8*9,0,n,3,1,079h
	Msprdata	8*10,0,n,3,1,07ah
	Msprdata	8*11,0,n,3,1,07bh
	Msprdata	8*12,0,n,3,1,07ch
	Msprdata	8*13,0,n,3,1,07dh
	Msprdata	8*14,0,n,3,1,07eh
	Msprdata	8*15,0,n,3,1,07fh



seq_bs_message_erasescore
	db	20h,idx_obj_bs_message3
.loop
	db	20h,idx_obj_bs_message3
	MSseq_jmp	.loop

obj_bs_message3
	MSoam_small	16
	Msprdata	8*0,0,n,3,1,080h
	Msprdata	8*1,0,n,3,1,081h
	Msprdata	8*2,0,n,3,1,082h
	Msprdata	8*3,0,n,3,1,083h
	Msprdata	8*4,0,n,3,1,084h
	Msprdata	8*5,0,n,3,1,085h
	Msprdata	8*6,0,n,3,1,086h
	Msprdata	8*7,0,n,3,1,087h
	Msprdata	8*8,0,n,3,1,088h
	Msprdata	8*9,0,n,3,1,089h
	Msprdata	8*10,0,n,3,1,08ah
	Msprdata	8*11,0,n,3,1,08bh
	Msprdata	8*12,0,n,3,1,08ch
	Msprdata	8*13,0,n,3,1,08dh
	Msprdata	8*14,0,n,3,1,08eh
	Msprdata	8*15,0,n,3,1,08fh



seq_bs_message_erasescoreOK
	db	20h,idx_obj_bs_message4
.loop
	db	20h,idx_obj_bs_message4
	MSseq_jmp	.loop

obj_bs_message4
	MSoam_small	16
	Msprdata	8*0,0,n,3,1,090h
	Msprdata	8*1,0,n,3,1,091h
	Msprdata	8*2,0,n,3,1,092h
	Msprdata	8*3,0,n,3,1,093h
	Msprdata	8*4,0,n,3,1,094h
	Msprdata	8*5,0,n,3,1,095h
	Msprdata	8*6,0,n,3,1,096h
	Msprdata	8*7,0,n,3,1,097h
	Msprdata	8*8,0,n,3,1,098h
	Msprdata	8*9,0,n,3,1,099h
	Msprdata	8*10,0,n,3,1,08ah
	Msprdata	8*11,0,n,3,1,08bh
	Msprdata	8*12,0,n,3,1,08ch
	Msprdata	8*13,0,n,3,1,08dh
	Msprdata	8*14,0,n,3,1,08eh
	Msprdata	8*15,0,n,3,1,08fh



seq_bs_message_erasescoreEXEC
	db	20h,idx_obj_bs_message5
.loop
	db	20h,idx_obj_bs_message5
	MSseq_jmp	.loop

obj_bs_message5
	MSoam_small	16
	Msprdata	8*0,0,n,3,1,0a0h
	Msprdata	8*1,0,n,3,1,0a1h
	Msprdata	8*2,0,n,3,1,0a2h
	Msprdata	8*3,0,n,3,1,0a3h
	Msprdata	8*4,0,n,3,1,0a4h
	Msprdata	8*5,0,n,3,1,0a5h
	Msprdata	8*6,0,n,3,1,0a6h
	Msprdata	8*7,0,n,3,1,0a7h
	Msprdata	8*8,0,n,3,1,0a8h
	Msprdata	8*9,0,n,3,1,0a9h
	Msprdata	8*10,0,n,3,1,0aah
	Msprdata	8*11,0,n,3,1,0abh
	Msprdata	8*12,0,n,3,1,0ach
	Msprdata	8*13,0,n,3,1,0adh
	Msprdata	8*14,0,n,3,1,0aeh
	Msprdata	8*15,0,n,3,1,0afh

seq_bs_message_datanothing
	db	20h,idx_obj_bs_message6
	db	20h,idx_obj_bs_message6
	MSseq_end

obj_bs_message6
	MSoam_small	16
	Msprdata	8*0,0,n,3,1,0b0h
	Msprdata	8*1,0,n,3,1,0b1h
	Msprdata	8*2,0,n,3,1,0b2h
	Msprdata	8*3,0,n,3,1,0b3h
	Msprdata	8*4,0,n,3,1,0b4h
	Msprdata	8*5,0,n,3,1,0b5h
	Msprdata	8*6,0,n,3,1,0b6h
	Msprdata	8*7,0,n,3,1,0b7h
	Msprdata	8*8,0,n,3,1,0b8h
	Msprdata	8*9,0,n,3,1,0b9h
	Msprdata	8*10,0,n,3,1,0bah
	Msprdata	8*11,0,n,3,1,0bbh
	Msprdata	8*12,0,n,3,1,0bch
	Msprdata	8*13,0,n,3,1,0bdh
	Msprdata	8*14,0,n,3,1,0beh
	Msprdata	8*15,0,n,3,1,0bfh



;--------------------------------------------------
seq_bs_message_erasecursor
	db	16,idx_oam_nothing
.loop
	db	20h,idx_obj_bs_erasecursor
	MSseq_jmp	.loop

;--------------------------------------------------
obj_bs_erasecursor
	MSoam_small	1
	Msprdata	8*0,0,n,3,1,042h


;**************************************************************************
;		SEQ data
;**************************************************************************

;--------------------------------------------------
seq_fireOK
	db	001h,idx_obj_e1_1_6 
	db	001h,idx_obj_e1_1_7 
	db	001h,idx_obj_e1_1_8 
	db	001h,idx_obj_e1_1_9 
	db	001h,idx_obj_e1_1_10 
	db	001h,idx_obj_e1_1_11 
	db	004h,idx_obj_e1_1_12 
	db	004h,idx_obj_e1_1_13 
	db	004h,idx_obj_e1_1_14 
	db	004h,idx_obj_e1_1_15 
	db	004h,idx_obj_e1_1_16 
	db	004h,idx_obj_e1_1_17 
	db	002h,idx_obj_e1_1_18 
	db	002h,idx_obj_e1_1_19 
	db	002h,idx_obj_e1_1_20 
	MSseq_flagset	
	db	10,idx_oam_nothing


;--------------------------------------------------

seq_fire
	db	001h,idx_obj_e1_1_6 
	db	001h,idx_obj_e1_1_7 
	db	001h,idx_obj_e1_1_8 
	db	001h,idx_obj_e1_1_9 
	db	001h,idx_obj_e1_1_10 
	db	001h,idx_obj_e1_1_11 
	db	004h,idx_obj_e1_1_12 
	db	004h,idx_obj_e1_1_13 
	db	004h,idx_obj_e1_1_14 
	db	004h,idx_obj_e1_1_15 
	db	004h,idx_obj_e1_1_16 
	db	004h,idx_obj_e1_1_17 
	db	002h,idx_obj_e1_1_18 
	db	002h,idx_obj_e1_1_19 
	db	002h,idx_obj_e1_1_20 

;--------------------------------------------------
seq_cursor_open
	db	002h,idx_obj_e1_1_0 
	db	002h,idx_obj_e1_1_1 
	db	002h,idx_obj_e1_1_2 
	db	002h,idx_obj_e1_1_3 
	db	002h,idx_obj_e1_1_4 
	MSseq_flagset	
	db	0010h,idx_obj_e1_1_4 
	MSseq_end

seq_e1_1_1	;(1)
	db	2,idx_obj_e1_1_21 
	db	2,idx_obj_e1_1_63 
	MSseq_end

seq_e1_1_2	;(1)
	db	4,idx_obj_e1_1_22 
	db	4,idx_obj_e1_1_63
	MSseq_end


;**************************************************************************
;		OBJ data
;**************************************************************************

obj_e1_1_63	db	0

obj_e1_1_0
	MSoam_small	4
	db	010h,010h,054h,0f4h
	db	0e8h,010h,054h,0b4h
	db	010h,0e8h,054h,074h
	db	0e8h,0e8h,054h,034h

obj_e1_1_1
	MSoam_small	4
	db	00ch,00ch,054h,0f4h
	db	0ech,00ch,054h,0b4h
	db	00ch,0ech,054h,074h
	db	0ech,0ech,054h,034h

obj_e1_1_2
	MSoam_small	4
	db	008h,008h,054h,0f4h
	db	0f0h,008h,054h,0b4h
	db	008h,0f0h,054h,074h
	db	0f0h,0f0h,054h,034h

obj_e1_1_3
	MSoam_small	4
	db	004h,004h,054h,0f4h
	db	0f4h,004h,054h,0b4h
	db	004h,0f4h,054h,074h
	db	0f4h,0f4h,054h,034h

obj_e1_1_4
	MSoam_small	4
	db	000h,000h,054h,0f4h
	db	0f8h,000h,054h,0b4h
	db	000h,0f8h,054h,074h
	db	0f8h,0f8h,054h,034h

obj_e1_1_5
	MSoam_small	4
	db	000h,0f8h,053h,074h
	db	000h,000h,053h,0f4h
	db	0f8h,000h,053h,0b4h
	db	0f8h,0f8h,053h,034h

obj_e1_1_6
	MSoam_small	16
	db	028h,028h,00dh,072h
	db	020h,020h,00dh,072h
	db	020h,030h,01fh,072h
	db	028h,030h,01eh,072h
	db	018h,028h,01dh,072h
	db	020h,028h,01ch,072h
	db	010h,020h,01bh,072h
	db	018h,020h,01ah,072h
	db	0d0h,028h,00dh,032h
	db	0d8h,020h,00dh,032h
	db	0d8h,030h,01fh,032h
	db	0d0h,030h,01eh,032h
	db	0e0h,028h,01dh,032h
	db	0d8h,028h,01ch,032h
	db	0e8h,020h,01bh,032h
	db	0e0h,020h,01ah,032h

obj_e1_1_7
	MSoam_small	24
	db	028h,028h,00dh,072h
	db	020h,020h,00dh,072h
	db	018h,018h,00dh,072h
	db	020h,030h,01fh,072h
	db	028h,030h,01eh,072h
	db	018h,028h,01dh,072h
	db	020h,028h,01ch,072h
	db	010h,020h,01bh,072h
	db	018h,020h,01ah,072h
	db	010h,018h,00fh,072h
	db	008h,010h,00eh,072h
	db	010h,010h,00dh,072h
	db	0d0h,028h,00dh,032h
	db	0d8h,020h,00dh,032h
	db	0e0h,018h,00dh,032h
	db	0d8h,030h,01fh,032h
	db	0d0h,030h,01eh,032h
	db	0e0h,028h,01dh,032h
	db	0d8h,028h,01ch,032h
	db	0e8h,020h,01bh,032h
	db	0e0h,020h,01ah,032h
	db	0e8h,018h,00fh,032h
	db	0f0h,010h,00eh,032h
	db	0e8h,010h,00dh,032h

obj_e1_1_8
	MSoam_small	30
	db	028h,028h,00dh,072h
	db	020h,020h,00dh,072h
	db	018h,018h,00dh,072h
	db	020h,030h,01fh,072h
	db	028h,030h,01eh,072h
	db	018h,028h,01dh,072h
	db	020h,028h,01ch,072h
	db	010h,020h,01bh,072h
	db	018h,020h,01ah,072h
	db	010h,018h,00fh,072h
	db	008h,010h,00eh,072h
	db	010h,010h,00dh,072h
	db	000h,008h,00ch,072h
	db	008h,008h,00bh,072h
	db	000h,000h,00ah,072h
	db	0d0h,028h,00dh,032h
	db	0d8h,020h,00dh,032h
	db	0e0h,018h,00dh,032h
	db	0d8h,030h,01fh,032h
	db	0d0h,030h,01eh,032h
	db	0e0h,028h,01dh,032h
	db	0d8h,028h,01ch,032h
	db	0e8h,020h,01bh,032h
	db	0e0h,020h,01ah,032h
	db	0e8h,018h,00fh,032h
	db	0f0h,010h,00eh,032h
	db	0e8h,010h,00dh,032h
	db	0f8h,008h,00ch,032h
	db	0f0h,008h,00bh,032h
	db	0f8h,000h,00ah,032h

obj_e1_1_9
	MSoam_small	18
	db	018h,018h,00dh,072h
	db	010h,020h,01bh,072h
	db	018h,020h,01ah,072h
	db	010h,018h,00fh,072h
	db	008h,010h,00eh,072h
	db	010h,010h,00dh,072h
	db	000h,008h,00ch,072h
	db	008h,008h,00bh,072h
	db	000h,000h,00ah,072h
	db	0e0h,018h,00dh,032h
	db	0e8h,020h,01bh,032h
	db	0e0h,020h,01ah,032h
	db	0e8h,018h,00fh,032h
	db	0f0h,010h,00eh,032h
	db	0e8h,010h,00dh,032h
	db	0f8h,008h,00ch,032h
	db	0f0h,008h,00bh,032h
	db	0f8h,000h,00ah,032h

obj_e1_1_10
	MSoam_small	12
	db	010h,018h,00fh,072h
	db	008h,010h,00eh,072h
	db	010h,010h,00dh,072h
	db	000h,008h,00ch,072h
	db	008h,008h,00bh,072h
	db	000h,000h,00ah,072h
	db	0e8h,018h,00fh,032h
	db	0f0h,010h,00eh,032h
	db	0e8h,010h,00dh,032h
	db	0f8h,008h,00ch,032h
	db	0f0h,008h,00bh,032h
	db	0f8h,000h,00ah,032h

obj_e1_1_11
	MSoam_small	4
	db	000h,008h,00ch,072h
	db	000h,000h,00ah,072h
	db	0f8h,008h,00ch,032h
	db	0f8h,000h,00ah,032h

obj_e1_1_12
	MSoam_big	4
	db	0f0h,000h,024h,0b2h
	db	000h,000h,024h,0f2h
	db	000h,0f0h,024h,072h
	db	0f0h,0f0h,024h,032h

obj_e1_1_13
	MSoam_big	4
	db	0f0h,000h,026h,0b2h
	db	000h,000h,026h,0f2h
	db	000h,0f0h,026h,072h
	db	0f0h,0f0h,026h,032h

obj_e1_1_14
	MSoam_big	4
	db	000h,000h,048h,072h
	db	000h,0f0h,028h,072h
	db	0f0h,000h,048h,032h
	db	0f0h,0f0h,028h,032h

obj_e1_1_15
	MSoam_big	4
	db	000h,000h,04ah,072h
	db	000h,0f0h,02ah,072h
	db	0f0h,000h,04ah,032h
	db	0f0h,0f0h,02ah,032h

obj_e1_1_16
	MSoam_big	4
	db	000h,000h,04ch,072h
	db	000h,0f0h,02ch,072h
	db	0f0h,000h,04ch,032h
	db	0f0h,0f0h,02ch,032h

obj_e1_1_17
	MSoam_big	4
	db	000h,000h,04eh,072h
	db	000h,0f0h,02eh,072h
	db	0f0h,000h,04eh,032h
	db	0f0h,0f0h,02eh,032h

obj_e1_1_18
	MSoam_small	4
	db	000h,0f8h,050h,030h
	db	000h,000h,050h,030h
	db	0f8h,000h,050h,030h
	db	0f8h,0f8h,050h,030h

obj_e1_1_19
	MSoam_small	4
	db	000h,0f8h,051h,070h
	db	000h,000h,051h,0f0h
	db	0f8h,000h,051h,0b0h
	db	0f8h,0f8h,051h,030h

obj_e1_1_20
	MSoam_small	4
	db	000h,0f8h,052h,070h
	db	000h,000h,052h,0f0h
	db	0f8h,000h,052h,0b0h
	db	0f8h,0f8h,052h,030h

obj_e1_1_21
	MSoam_small	2
	db	0f8h,000h,019h,0b8h
	db	0f8h,0f8h,019h,038h

obj_e1_1_22
	MSoam_big	14
	db	060h,0f8h,045h,078h
	db	050h,0f8h,046h,038h
	db	040h,0f8h,046h,038h
	db	090h,0f8h,045h,038h
	db	0a0h,0f8h,046h,038h
	db	0b0h,0f8h,046h,038h
	db	030h,0f8h,046h,038h
	db	020h,0f8h,046h,038h
	db	010h,0f8h,046h,038h
	db	000h,0f8h,046h,038h
	db	0f0h,0f8h,046h,038h
	db	0e0h,0f8h,046h,038h
	db	0d0h,0f8h,046h,038h
	db	0c0h,0f8h,046h,038h

;**************************************************************************
;	title message OBJ
;**************************************************************************

seq_bs_cursor

.loop
	db	8,idx_obj_bs_cursor
	db	8,idx_oam_nothing
	MSseq_jmp	.loop

;--------------------------------------------------------------------------

obj_bs_cursor
	MSoam_small	4
	Msprdata	-8,-8,n,3,2,053h
	Msprdata	0,-8,h,3,2,053h
	Msprdata	-8,0,v,3,2,053h
	Msprdata	0,0,hv,3,2,053h



;**************************************************************************
;	sprite nothing data
;**************************************************************************


oam_nothing	db	0


;**************************************************************************
;	enemy_gone
;**************************************************************************

seq_enemygone
	db	1,idx_obj_enemygone
	MSseq_end

obj_enemygone
	MSoam_small	32
	db	0b0h,000h,060h,0b2h
	db	0b0h,0f8h,060h,032h
	db	0b8h,0f8h,0bah,032h
	db	0b8h,000h,058h,0b2h
	db	0c0h,000h,060h,0b2h
	db	0c0h,0f8h,060h,032h
	db	0c8h,000h,058h,0b2h
	db	0c8h,0f8h,0bbh,032h
	db	0d0h,000h,061h,032h
	db	0d0h,0f8h,0bdh,032h
	db	0e0h,000h,055h,0b2h
	db	0e0h,0f8h,055h,032h
	db	0e8h,000h,055h,0b2h
	db	0e8h,0f8h,058h,032h
	db	0f0h,000h,061h,032h
	db	0f0h,0f8h,051h,032h
	db	000h,000h,055h,0b2h
	db	000h,0f8h,055h,032h
	db	008h,000h,04fh,032h
	db	008h,0f8h,060h,032h
	db	018h,0f8h,0abh,032h
	db	018h,000h,0ach,032h
	db	020h,000h,062h,032h
	db	020h,0f8h,052h,032h
	db	028h,000h,058h,0b2h
	db	028h,0f8h,0bah,032h
	db	030h,000h,063h,032h
	db	030h,0f8h,053h,032h
	db	038h,000h,060h,0b2h
	db	038h,0f8h,060h,032h
	db	048h,0f8h,061h,0b2h
	db	048h,000h,0adh,032h


;**************************************************************************
;	config key program
;**************************************************************************

obj_typeA
	MSoam_big	3
	db	008h,0f8h,02ch,030h
	db	0f8h,0f8h,02ah,038h
	db	0e8h,0f8h,028h,038h

obj_typeB
	MSoam_big	3
	db	008h,0f8h,02eh,030h
	db	0f8h,0f8h,02ah,038h
	db	0e8h,0f8h,028h,038h

obj_typeC
	MSoam_big	3
	db	008h,0f8h,04ch,034h
	db	0f8h,0f8h,02ah,038h
	db	0e8h,0f8h,028h,038h

obj_typeD
	MSoam_big	3
	db	008h,0f8h,04eh,032h
	db	0f8h,0f8h,02ah,038h
	db	0e8h,0f8h,028h,038h


seq_keyconfig
	MSseq_attrW	0
	db	1,idx_obj_keyconfig
	MSseq_end

obj_keyconfig
	MSoam_big	16
	db	010h,010h,00dh,0f0h
	db	000h,010h,00eh,0b0h
	db	0f0h,010h,00eh,0b0h
	db	0e0h,010h,00dh,0b0h
	db	010h,0e0h,00dh,070h
	db	010h,000h,026h,030h
	db	000h,000h,024h,030h
	db	0f0h,000h,022h,030h
	db	0e0h,000h,020h,030h
	db	010h,0f0h,036h,030h
	db	000h,0f0h,034h,030h
	db	0f0h,0f0h,032h,030h
	db	0e0h,0f0h,030h,030h
	db	000h,0e0h,00eh,030h
	db	0f0h,0e0h,00eh,030h
	db	0e0h,0e0h,00dh,030h

;**************************************************************************
;	title message OBJ
;**************************************************************************

;--------------------------------------------------------------------------
seq_titlestart
	db	6,idx_obj_titlestart
	db	6,idx_oam_nothing
	MSseq_end


;--------------------------------------------------------------------------
obj_titlestart
	MSoam_small	10
	db	0d8h,0f8h,0a0h+40h,032h
	db	0e0h,0f8h,0a1h+40h,032h
	db	0e8h,0f8h,0a2h+40h,032h
	db	0f0h,0f8h,0a3h+40h,032h
	db	0f8h,0f8h,0a4h+40h,032h
	db	000h,0f8h,0a5h+40h,032h
	db	008h,0f8h,0a6h+40h,032h
	db	010h,0f8h,0a7h+40h,032h
	db	018h,0f8h,0a8h+40h,032h
	db	020h,0f8h,0a9h+40h,032h

;--------------------------------------------------------------------------
;
;
;
;
;
;
;**************************************************************************
;	title message OBJ
;**************************************************************************

seq_titlenintendo
	db	12,idx_obj_titlenintendo
	MSseq_repeat
	
;--------------------------------------------------------------------------

obj_titlenintendo
	MSoam_small	10
	db	0d8h,0f8h,0b0h+40h,032h
	db	0e0h,0f8h,0b1h+40h,032h
	db	0e8h,0f8h,0b2h+40h,032h
	db	0f0h,0f8h,0b3h+40h,032h
	db	0f8h,0f8h,0b4h+40h,032h
	db	000h,0f8h,0b5h+40h,032h
	db	008h,0f8h,0b6h+40h,032h
	db	010h,0f8h,0b7h+40h,032h
	db	018h,0f8h,0b8h+40h,032h
	db	020h,0f8h,0b9h+40h,032h




;**************************************************************************
;	title planet OBJ
;**************************************************************************

seq_titleplanet
	db	12,idx_obj_titleplanet
	MSseq_repeat
	
;--------------------------------------------------------------------------

obj_titleplanet

	MSoam_big	19
	db	018h,010h,02eh+40h,020h
	db	018h,000h,02eh+40h,020h
	db	018h,0f0h,02eh+40h,020h
	db	008h,000h,02eh+40h,020h
	db	008h,010h,02eh+40h,020h
	db	0f8h,010h,02eh+40h,020h
	db	0e8h,010h,06eh+40h,020h
	db	0d8h,010h,04eh+40h,020h
	db	0f8h,000h,0aeh+40h,020h
	db	0e8h,000h,0ach+40h,020h
	db	0d8h,000h,0aah+40h,020h
	db	008h,0f0h,08eh+40h,020h
	db	0f8h,0f0h,08ch+40h,020h
	db	0e8h,0f0h,08ah+40h,020h
	db	0d8h,0f0h,088h+40h,020h
	db	018h,0e0h,086h+40h,020h
	db	008h,0e0h,084h+40h,020h
	db	0f8h,0e0h,082h+40h,020h
	db	0e8h,0e0h,080h+40h,020h

;**************************************************************************
;	title face OBJ
;**************************************************************************

seq_titleface
	db	4,idx_obj_titleface1
	MSseq_end

;--------------------------------------------------------------------------

obj_titleface1
	MSoam_big	29
	db	000h,020h,00eh+40h,02eh
	db	028h,010h,06ch+40h,02eh
	db	018h,010h,06ah+40h,02eh
	db	008h,010h,068h+40h,02eh
	db	0f8h,010h,066h+40h,02eh
	db	0e8h,010h,064h+40h,02eh
	db	0d8h,010h,062h+40h,02eh
	db	0c8h,010h,060h+40h,02eh
	db	028h,000h,04ch+40h,02eh
	db	018h,000h,04ah+40h,02eh
	db	008h,000h,048h+40h,02eh
	db	0f8h,000h,046h+40h,02eh
	db	0e8h,000h,044h+40h,02eh
	db	0d8h,000h,042h+40h,02eh
	db	0c8h,000h,040h+40h,02eh
	db	028h,0f0h,02ch+40h,02eh
	db	018h,0f0h,02ah+40h,02eh
	db	008h,0f0h,028h+40h,02eh
	db	0f8h,0f0h,026h+40h,02eh
	db	0e8h,0f0h,024h+40h,02eh
	db	0d8h,0f0h,022h+40h,02eh
	db	0c8h,0f0h,020h+40h,02eh
	db	028h,0e0h,00ch+40h,02eh
	db	018h,0e0h,00ah+40h,02eh
	db	008h,0e0h,008h+40h,02eh
	db	0f8h,0e0h,006h+40h,02eh
	db	0e8h,0e0h,004h+40h,02eh
	db	0d8h,0e0h,002h+40h,02eh
	db	0c8h,0e0h,000h+40h,02eh

;**************************************************************************
;	stage (READY/START)
;**************************************************************************
ready_speed	equ	8
ready_time	equ	3
ready_wait	equ	10
start_time	equ	3
start_wait	equ	7
;--------------------------------------------------------------------------
seq_ready0	
	db	ready_time*1+1+ready_wait,idx_obj_ready_a
	MSseq_kill
;----------------------------------------------
seq_ready1	
	db	1,idx_obj_ready_e
	MSseq_setVX	-ready_speed
	db	ready_time,idx_obj_ready_e
	MSseq_setVX	0
	db	ready_wait,idx_obj_ready_e
	MSseq_kill

;----------------------------------------------

seq_ready2	db	1,idx_obj_ready_r
	MSseq_setVX	-ready_speed*2
	db	ready_time,idx_obj_ready_r
	MSseq_setVX	0
	db	ready_wait,idx_obj_ready_r
	MSseq_kill

;----------------------------------------------
seq_ready3	db	1,idx_obj_ready_d
	MSseq_setVX	ready_speed
	db	ready_time,idx_obj_ready_d
	MSseq_setVX	0
	db	ready_wait,idx_obj_ready_d
	MSseq_kill

;----------------------------------------------
seq_ready4	db	1,idx_obj_ready_y
	MSseq_setVX	ready_speed*2
	db	ready_time,idx_obj_ready_y
	MSseq_setVX	0
	db	ready_wait,idx_obj_ready_y
	MSseq_kill

;----------------------------------------------------------------------

obj_ready_r	MSoam_small	4
	Mmesobj	-8,-8,n,3,2,70h
	Mmesobj	00,-8,n,3,2,71h
	Mmesobj	-8,00,n,3,3,72h
	Mmesobj	00,00,n,3,3,73h

obj_ready_e	MSoam_small	4
	Mmesobj	-8,-8,n,3,2,70h
	Mmesobj	00,-8,n,3,2,74h
	Mmesobj	-8,00,v,3,3,70h
	Mmesobj	00,00,v,3,3,74h

obj_ready_a	MSoam_small	4
	Mmesobj	-8,-8,n,3,2,75h
	Mmesobj	00,-8,h,3,2,75h
	Mmesobj	-8,00,n,3,3,72h
	Mmesobj	00,00,h,3,3,72h

obj_ready_d	MSoam_small	4
	Mmesobj	-8,-8,n,3,2,76h
	Mmesobj	00,-8,n,3,2,77h
	Mmesobj	-8,00,v,3,3,76h
	Mmesobj	00,00,v,3,3,77h

obj_ready_y	MSoam_small	4
	Mmesobj	-8,-8,n,3,2,78h
	Mmesobj	00,-8,h,3,2,78h
	Mmesobj	-8,00,n,3,3,79h
	Mmesobj	00,00,h,3,3,79h


;**************************************************************************
;	bignumber SEQ
;**************************************************************************

seq_bignum_0	db	10h,idx_obj_w0_1_0
	MSseq_end
seq_bignum_1	db	10h,idx_obj_w0_1_1
	MSseq_end
seq_bignum_2	db	10h,idx_obj_w0_1_2
	MSseq_end
seq_bignum_3	db	10h,idx_obj_w0_1_3
	MSseq_end
seq_bignum_4	db	10h,idx_obj_w0_1_4
	MSseq_end
seq_bignum_5	db	10h,idx_obj_w0_1_5
	MSseq_end
seq_bignum_6	db	10h,idx_obj_w0_1_6
	MSseq_end
seq_bignum_7	db	10h,idx_obj_w0_1_7
	MSseq_end
seq_bignum_8	db	10h,idx_obj_w0_1_8
	MSseq_end
seq_bignum_9	db	10h,idx_obj_w0_1_9
	MSseq_end
seq_bigtarget
	db	10h,idx_obj_target
	MSseq_end

;**************************************************************************
;		OBJ data
;**************************************************************************
dbx2	macro
	db	\1,\2,\3+40h,\4
	endm
;--------------------------------------------------------------------------

seq_pausemapplayer
	db	6,idx_obj_w0_2_0
	db	6,idx_obj_w0_2_1
	db	6,idx_obj_w0_2_2
	db	6,idx_obj_w0_2_3
	db	6,idx_obj_w0_2_4
	db	6,idx_obj_w0_2_5
	db	6,idx_obj_w0_2_6
	db	6,idx_obj_w0_2_7
	db	6,idx_obj_w0_2_8
	db	6,idx_obj_w0_2_9
	db	6,idx_obj_w0_2_10
	db	6,idx_obj_w0_2_11

;--------------------------------------------------------------------------

obj_w0_2_0
	MSoam_big	4
	dbx2	0f3h,0fdh,0ach,032h
	dbx2	0fdh,0fdh,0ach,072h
	dbx2	0fdh,0f3h,0ach,0f2h
	dbx2	0f3h,0f3h,0ach,0b2h

obj_w0_2_1
	MSoam_big	4
	dbx2	0f4h,0fch,0ach,032h
	dbx2	0fch,0fch,0ach,072h
	dbx2	0fch,0f4h,0ach,0f2h
	dbx2	0f4h,0f4h,0ach,0b2h

obj_w0_2_2
	MSoam_big	4
	dbx2	0f5h,0fbh,0ach,032h
	dbx2	0fbh,0fbh,0ach,072h
	dbx2	0fbh,0f5h,0ach,0f2h
	dbx2	0f5h,0f5h,0ach,0b2h

obj_w0_2_3
	MSoam_big	4
	dbx2	0f6h,0fah,0ach,032h
	dbx2	0fah,0fah,0ach,072h
	dbx2	0fah,0f6h,0ach,0f2h
	dbx2	0f6h,0f6h,0ach,0b2h

obj_w0_2_4
	MSoam_big	4
	dbx2	0f7h,0f9h,0ach,032h
	dbx2	0f9h,0f9h,0ach,072h
	dbx2	0f9h,0f7h,0ach,0f2h
	dbx2	0f7h,0f7h,0ach,0b2h

obj_w0_2_5
	MSoam_small	4
	dbx2	0f8h,000h,0bch,032h
	dbx2	000h,000h,0bch,072h
	dbx2	000h,0f8h,0bch,0f2h
	dbx2	0f8h,0f8h,0bch,0b2h

obj_w0_2_6
	MSoam_small	4
	dbx2	0f9h,0ffh,0bch,032h
	dbx2	0ffh,0ffh,0bch,072h
	dbx2	0ffh,0f9h,0bch,0f2h
	dbx2	0f9h,0f9h,0bch,0b2h

obj_w0_2_7
	MSoam_small	4
	dbx2	0fah,0feh,0bch,032h
	dbx2	0feh,0feh,0bch,072h
	dbx2	0feh,0fah,0bch,0f2h
	dbx2	0fah,0fah,0bch,0b2h

obj_w0_2_8
	MSoam_small	4
	dbx2	000h,0f8h,0abh,072h
	dbx2	000h,000h,0abh,0f2h
	dbx2	0f8h,000h,0abh,0b2h
	dbx2	0f8h,0f8h,0abh,032h

obj_w0_2_9
	MSoam_small	4
	dbx2	0ffh,0f9h,0abh,072h
	dbx2	0ffh,0ffh,0abh,0f2h
	dbx2	0f9h,0ffh,0abh,0b2h
	dbx2	0f9h,0f9h,0abh,032h

obj_w0_2_10
	MSoam_small	4
	dbx2	0feh,0fah,0abh,072h
	dbx2	0feh,0feh,0abh,0f2h
	dbx2	0fah,0feh,0abh,0b2h
	dbx2	0fah,0fah,0abh,032h

obj_w0_2_11
	MSoam_small	1
	dbx2	0fch,0fch,09ch,032h




;**************************************************************************
;		OBJ data
;**************************************************************************


obj_target
	MSoam_small	12
	dbx2	-18h,-8h,11h,30h	; t
	dbx2	-18h,00h,21h,30h
	dbx2	-10h,-8h,12h,30h	; a
	dbx2	-10h,00h,22h,30h
	dbx2	-08h,-8h,6bh,30h	; r
	dbx2	-08h,00h,6ch,30h
	dbx2	000h,-8h,13h,30h	; g
	dbx2	000h,00h,23h,30h
	dbx2	008h,-8h,20h,30h	; e
	dbx2	008h,00h,20h,30h+80h
	dbx2	010h,-8h,11h,30h	; t
	dbx2	010h,00h,21h,30h


obj_w0_1_0
	MSoam_big	6
	dbx2	000h,008h,0a0h,0f0h
	dbx2	0f0h,008h,0a0h,0b0h
	dbx2	000h,0e8h,0a0h,070h
	dbx2	000h,0f8h,0a2h,070h
	dbx2	0f0h,0f8h,0a2h,030h
	dbx2	0f0h,0e8h,0a0h,030h

obj_w0_1_1
	MSoam_big	3
	dbx2	0f8h,0f8h,0a2h,070h
	dbx2	0f8h,008h,0a6h,030h
	dbx2	0f8h,0e8h,0a4h,030h

obj_w0_1_2
	MSoam_big	6
	dbx2	000h,008h,0a8h,070h
	dbx2	0f0h,008h,0a0h,0b0h
	dbx2	000h,0f8h,0a0h,0f0h
	dbx2	0f0h,0f8h,0a0h,030h
	dbx2	000h,0e8h,0a0h,070h
	dbx2	0f0h,0e8h,0a8h,030h

obj_w0_1_3
	MSoam_big	6
	dbx2	0f0h,008h,0a8h,030h
	dbx2	000h,008h,0a0h,0f0h
	dbx2	0f0h,0f8h,0aah,030h
	dbx2	000h,0f8h,0ach,030h
	dbx2	0f0h,0e8h,0a8h,030h
	dbx2	000h,0e8h,0a0h,070h

obj_w0_1_4
	MSoam_big	5
	dbx2	000h,008h,0a6h,030h
	dbx2	0f0h,0f8h,0a0h,0b0h
	dbx2	000h,0f8h,0aeh,030h
	dbx2	0f0h,0e8h,0a6h,0f0h
	dbx2	000h,0e8h,0a6h,0b0h

obj_w0_1_5
	MSoam_big	6
	dbx2	000h,0e8h,0a8h,070h
	dbx2	0f0h,0e8h,0a0h,030h
	dbx2	000h,0f8h,0a0h,070h
	dbx2	0f0h,0f8h,0a0h,0b0h
	dbx2	000h,008h,0a0h,0f0h
	dbx2	0f0h,008h,0a8h,0b0h

obj_w0_1_6
	MSoam_big	6
	dbx2	000h,0e8h,0a8h,070h
	dbx2	0f0h,0e8h,0a0h,030h
	dbx2	000h,0f8h,0a0h,070h
	dbx2	0f0h,0f8h,0aeh,070h
	dbx2	000h,008h,0a0h,0f0h
	dbx2	0f0h,008h,0a0h,0b0h

obj_w0_1_7
	MSoam_big	4
	dbx2	000h,0f8h,0a2h,070h
	dbx2	000h,008h,0a6h,030h
	dbx2	000h,0e8h,0a0h,070h
	dbx2	0f0h,0e8h,0a8h,030h

obj_w0_1_8
	MSoam_big	6
	dbx2	000h,0e8h,0a0h,070h
	dbx2	0f0h,0e8h,0a0h,030h
	dbx2	000h,0f8h,0ach,030h
	dbx2	0f0h,0f8h,0ach,070h
	dbx2	000h,008h,0a0h,0f0h
	dbx2	0f0h,008h,0a0h,0b0h

obj_w0_1_9
	MSoam_big	6
	dbx2	0f0h,008h,0a8h,030h
	dbx2	000h,008h,0a0h,0f0h
	dbx2	0f0h,0f8h,0a0h,0b0h
	dbx2	000h,0f8h,0aeh,0b0h
	dbx2	0f0h,0e8h,0a0h,030h
	dbx2	000h,0e8h,0a0h,070h


;**************************************************************************
;	SEQ open/close shutter
;**************************************************************************

seq_faceclose
	db	003h,idx_obj_d4_0_0 
	db	003h,idx_obj_d4_0_1 
	db	003h,idx_obj_d4_0_2 
	db	003h,idx_obj_d4_0_3 
	db	003h,idx_obj_d4_0_4 
	MSseq_kill

seq_faceclosenext
	db	003h,idx_obj_d4_0_0 
	db	003h,idx_obj_d4_0_1 
	db	003h,idx_obj_d4_0_2 
	db	003h,idx_obj_d4_0_3 
	db	003h,idx_obj_d4_0_4 
.loop	db	003h,idx_oam_nothing
	MSseq_jmp	.loop

seq_faceopen
	db	003h,idx_obj_d4_0_4 
	db	003h,idx_obj_d4_0_3 
	db	003h,idx_obj_d4_0_2 
	db	003h,idx_obj_d4_0_1 
.loop	MSseq_attr	10h
	db	1,idx_obj_d4_0_0 
	MSseq_jmp	.loop



	ifeq	1

seq_planeclose
	db	003h,idx_obj_d4_0_5 
	db	003h,idx_obj_d4_0_6 
	db	003h,idx_obj_d4_0_7 
	db	003h,idx_obj_d4_0_8 
	MSseq_kill
seq_planeopen
	db	003h,idx_oam_nothing
	db	003h,idx_obj_d4_0_8 
	db	003h,idx_obj_d4_0_7 
	db	003h,idx_obj_d4_0_6 
	db	010h,idx_obj_d4_0_5 
	MSseq_end

	endc

seq_planeclose
	db	002h,idx_obj_e4_1_4 
	db	002h,idx_obj_e4_1_5 
	db	002h,idx_obj_e4_1_6 
	db	002h,idx_obj_e4_1_7 
	db	002h,idx_obj_e4_1_8
	db	002h,idx_obj_e4_1_9 
	MSseq_kill

seq_planeopen
	db	003h,idx_oam_nothing
	db	001h,idx_obj_e4_1_9 
	db	002h,idx_obj_e4_1_8 
	db	002h,idx_obj_e4_1_7 
	db	002h,idx_obj_e4_1_6 
	db	002h,idx_obj_e4_1_5 
	db	010h,idx_obj_e4_1_4 
	MSseq_end


;**************************************************************************
;	OBJ open/close shutter
;**************************************************************************







obj_e4_1_4
	MSoam_big	18
	db	020h,0fch,003h,074h
	db	010h,0fch,004h,034h
	db	000h,0fch,004h,034h
	db	0f0h,0fch,004h,034h
	db	0e0h,0fch,004h,034h
	db	0d0h,0fch,003h,034h
	db	0d0h,004h,000h,0b4h
	db	0e0h,004h,001h,0f4h
	db	0f0h,004h,001h,0f4h
	db	000h,004h,001h,0f4h
	db	010h,004h,001h,0f4h
	db	020h,004h,000h,0f4h
	db	020h,0ech,000h,074h
	db	010h,0ech,001h,034h
	db	000h,0ech,001h,034h
	db	0f0h,0ech,001h,034h
	db	0e0h,0ech,001h,034h
	db	0d0h,0ech,000h,034h

obj_e4_1_5
	MSoam_big	12
	db	020h,000h,000h,0f4h
	db	010h,000h,001h,0b4h
	db	000h,000h,001h,0b4h
	db	0f0h,000h,001h,0b4h
	db	0e0h,000h,001h,0b4h
	db	0d0h,000h,000h,0b4h
	db	0d0h,0f0h,000h,034h
	db	0e0h,0f0h,001h,074h
	db	0f0h,0f0h,001h,074h
	db	000h,0f0h,001h,074h
	db	010h,0f0h,001h,074h
	db	020h,0f0h,000h,074h

obj_e4_1_6
	MSoam_big	12
	db	0d0h,0fch,000h,0b4h
	db	0e0h,0fch,001h,0f4h
	db	0f0h,0fch,001h,0f4h
	db	000h,0fch,001h,0f4h
	db	010h,0fch,001h,0f4h
	db	020h,0fch,000h,0f4h
	db	0d0h,0f4h,000h,034h
	db	0e0h,0f4h,001h,074h
	db	0f0h,0f4h,001h,074h
	db	000h,0f4h,001h,074h
	db	010h,0f4h,001h,074h
	db	020h,0f4h,000h,074h

obj_e4_1_7
	MSoam_big	12
	db	0d0h,0f9h,000h,0b4h
	db	0e0h,0f9h,001h,0f4h
	db	0f0h,0f9h,001h,0f4h
	db	000h,0f9h,001h,0f4h
	db	010h,0f9h,001h,0f4h
	db	020h,0f9h,000h,0f4h
	db	0d0h,0f7h,000h,034h
	db	0e0h,0f7h,001h,074h
	db	0f0h,0f7h,001h,074h
	db	000h,0f7h,001h,074h
	db	010h,0f7h,001h,074h
	db	020h,0f7h,000h,074h

obj_e4_1_8
	MSoam_big	6
	db	0d0h,0f8h,008h,034h
	db	0e0h,0f8h,009h,074h
	db	0f0h,0f8h,009h,074h
	db	000h,0f8h,009h,074h
	db	010h,0f8h,009h,074h
	db	020h,0f8h,008h,074h

obj_e4_1_9
	MSoam_big	6
	db	020h,0f8h,006h,034h
	db	010h,0f8h,006h,034h
	db	000h,0f8h,006h,034h
	db	0d0h,0f8h,006h,034h
	db	0e0h,0f8h,006h,034h
	db	0f0h,0f8h,006h,034h















obj_d4_0_0
	MSoam_big	16
	db	010h,010h,000h,0f4h
	db	000h,010h,001h,0b4h
	db	0f0h,010h,001h,0b4h
	db	0e0h,010h,000h,0b4h
	db	010h,000h,003h,074h
	db	010h,0f0h,003h,074h
	db	010h,0e0h,000h,074h
	db	000h,0f0h,004h,034h
	db	000h,000h,004h,034h
	db	0f0h,000h,004h,034h
	db	0f0h,0f0h,004h,034h
	db	0e0h,000h,003h,034h
	db	0e0h,0f0h,003h,034h
	db	000h,0e0h,001h,034h
	db	0f0h,0e0h,001h,034h
	db	0e0h,0e0h,000h,034h

obj_d4_0_1
	MSoam_big	12
	db	0e0h,008h,000h,0b4h
	db	0f0h,008h,001h,0f4h
	db	000h,008h,001h,0f4h
	db	010h,008h,000h,0f4h
	db	0e0h,0f8h,003h,034h
	db	0e0h,0e8h,000h,034h
	db	0f0h,0f8h,004h,074h
	db	000h,0f8h,004h,074h
	db	010h,0f8h,003h,074h
	db	0f0h,0e8h,001h,074h
	db	000h,0e8h,001h,074h
	db	010h,0e8h,000h,074h

obj_d4_0_2
	MSoam_big	8
	db	010h,000h,000h,0f4h
	db	000h,000h,001h,0b4h
	db	0f0h,000h,001h,0b4h
	db	0e0h,000h,000h,0b4h
	db	010h,0f0h,000h,074h
	db	000h,0f0h,001h,034h
	db	0f0h,0f0h,001h,034h
	db	0e0h,0f0h,000h,034h

obj_d4_0_3
	MSoam_big	8
	db	010h,0f9h,000h,0f4h
	db	000h,0f9h,001h,0b4h
	db	0f0h,0f9h,001h,0b4h
	db	0e0h,0f9h,000h,0b4h
	db	010h,0f7h,000h,074h
	db	000h,0f7h,001h,034h
	db	0f0h,0f7h,001h,034h
	db	0e0h,0f7h,000h,034h

obj_d4_0_4
	MSoam_big	4
	db	010h,0f8h,006h,034h
	db	000h,0f8h,006h,034h
	db	0f0h,0f8h,006h,034h
	db	0e0h,0f8h,006h,034h




;********************************************************************
;	clear time sprite
;********************************************************************

obj_cleartime
	MSoam_small	18
	Msprdata	00h,00h,n,3,2,13h+40h	; clear
	Msprdata	00h,08h,v,3,2,13h+40h
	Msprdata	08h,00h,n,3,2,14h+40h
	Msprdata	08h,08h,n,3,2,24h+40h
	Msprdata	10h,00h,n,3,2,20h+40h
	Msprdata	10h,08h,v,3,2,20h+40h
	Msprdata	18h,00h,n,3,2,12h+40h
	Msprdata	18h,08h,n,3,2,22h+40h
	Msprdata	20h,00h,n,3,2,6bh+40h
	Msprdata	20h,08h,n,3,2,6ch+40h

	Msprdata	30h,00h,n,3,2,11h+40h	; time
	Msprdata	30h,08h,n,3,2,21h+40h
	Msprdata	38h,00h,v,3,2,21h+40h
	Msprdata	38h,08h,n,3,2,21h+40h
	Msprdata	40h,00h,n,3,2,7bh+40h
	Msprdata	40h,08h,v,3,2,18h+40h
	Msprdata	48h,00h,n,3,2,20h+40h
	Msprdata	48h,08h,v,3,2,20h+40h


obj_totaltime
	MSoam_small	9

	Msprdata	00h,00h,n,3,1,8ch+40h	; total
	Msprdata	08h,00h,n,3,1,30h+40h
	Msprdata	10h,00h,n,3,1,8ch+40h
	Msprdata	18h,00h,n,3,1,8dh+40h
	Msprdata	20h,00h,n,3,1,8eh+40h

	Msprdata	30h,00h,n,3,1,8ch+40h	; time
	Msprdata	38h,00h,n,3,1,8fh+40h
	Msprdata	40h,00h,n,3,1,9ch+40h
	Msprdata	48h,00h,n,3,1,9dh+40h




;********************************************************************
;
;	number data	((( 8x16 dot game-sprite numer )))
;
;********************************************************************

ndata_0	messet  15h,nomal,attr0
	messet  15h,vflip,attr0
ndata_1	messet  16h,nomal,attr0
	messet  21h,nomal,attr0
ndata_2	messet  10h,hflip,attr0
	messet  27h,nomal,attr0
ndata_3	messet  17h,nomal,attr0
	messet  17h,vflip,attr0
ndata_4	messet  18h,nomal,attr0
	messet  28h,nomal,attr0
ndata_5	messet  27h,vflip,attr0
	messet  26h,nomal,attr0
ndata_6	messet  7ch,nomal,attr0
	messet  12h,vflip,attr0
ndata_7	messet  24h,hvflip,attr0
	messet  14h,hvflip,attr0
ndata_8	messet  19h,nomal,attr0
	messet  19h,vflip,attr0
ndata_9	messet  15h,hflip,attr0
	messet  7ch,hvflip,attr0


xdata_0	messet  15h,nomal,attr1
	messet  15h,vflip,attr1
xdata_1	messet  16h,nomal,attr1
	messet  21h,nomal,attr1
xdata_2	messet  10h,hflip,attr1
	messet  27h,nomal,attr1
xdata_3	messet  17h,nomal,attr1
	messet  17h,vflip,attr1
xdata_4	messet  18h,nomal,attr1
	messet  28h,nomal,attr1
xdata_5	messet  27h,vflip,attr1
	messet  26h,nomal,attr1
xdata_6	messet  7ch,nomal,attr1
	messet  12h,vflip,attr1
xdata_7	messet  24h,hvflip,attr1
	messet  14h,hvflip,attr1
xdata_8	messet  19h,nomal,attr1
	messet  19h,vflip,attr1
xdata_9	messet  15h,hflip,attr1
	messet  7ch,hvflip,attr1


;=====================================================================
;=====================================================================
; END END END END END END END END END END END END END END END END END
;=====================================================================
;=====================================================================

