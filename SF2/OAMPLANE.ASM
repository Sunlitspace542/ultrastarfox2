;*********************************************************************
;*								*
;*	------------------------				*
;*		STARFOX2 					*
;*	------------------------				*
;*								*
;*	File 		: oamplane.asm				*
;* 	Description	: plane OBJ animation data		*
;*	Date		: 1994.11.4				*
;*	Author		: H.Yajima				*
;*								*
;*********************************************************************



;**************************************************************************
;
;**************************************************************************

;**************************************************************************
;	OBJ plane-meter
;**************************************************************************

oam_itemdisp
	db	0b0h,0e9h,070h,030h+80h
	db	0c0h,0e9h,072h,030h+80h
	db	0d0h,0e9h,074h,030h+80h
;---------------------------------------------------
oam_foxmeter_twin
	MSoam_big	12
	db	0cch,0f8h,056h,034h
	MSoam_romjmp	oam_foxcommon
oam_foxmeter
	MSoam_big	11
oam_foxcommon
	db	0c0h,0f8h,048h,034h
	db	0b0h,0f8h,052h,034h
	db	02eh,0f8h,06ch,034h
	db	039h,0f8h,06eh,034h
	db	017h,0f8h,06ah,034h
	db	012h,0f8h,06ah,034h
	db	0fah,0f8h,068h,074h
	db	0f2h,0f8h,068h,034h
	MSoam_romjmp	oam_itemdisp
;---------------------------------------------------
oam_peppymeter_twin
	MSoam_big	12
	db	0cch,0f8h,056h,034h
	MSoam_romjmp	oam_peppycommon
oam_peppymeter
	MSoam_big	11
oam_peppycommon
	db	0c0h,0f8h,048h,034h
	db	0b0h,0f8h,050h,034h
	db	033h,0f8h,06ch,034h
	db	039h,0f8h,06eh,034h
	db	017h,0f8h,06ah,034h
	db	00dh,0f8h,06ah,034h
	db	0fah,0f8h,068h,074h
	db	0eah,0f8h,068h,034h
	MSoam_romjmp	oam_itemdisp
;---------------------------------------------------
oam_galmeter_twin
	MSoam_big	11
	db	0cch,0f8h,056h,034h
	MSoam_romjmp	oam_galcommon
oam_galmeter
	MSoam_big	10
oam_galcommon
	db	0c0h,0f8h,048h,034h
	db	0b0h,0f8h,054h,034h
	db	039h,0f8h,06eh,034h
	db	029h,0f8h,06ch,034h
	db	017h,0f8h,06ah,034h
	db	0fah,0f8h,068h,074h
	db	0f7h,0f8h,068h,034h
	MSoam_romjmp	oam_itemdisp
;---------------------------------------------------
;;;
;;;
;;;
;;;
;;;
;;;
;;;
;;;
;**************************************************************************
;	SEQ plane
;**************************************************************************

seq_planefire
	MSseq_BGM	kbgm_hassha
	MSseq_sound	sport3_boost
.loop	db	001h,idx_obj_d4_1_8 
	db	001h,idx_obj_d4_1_9 
	db	001h,idx_obj_d4_1_10 
	db	001h,idx_obj_d4_1_9 
	MSseq_jmp	.loop

seq_foxplane	
	MSseq_attr	0
	db	10,idx_obj_d4_1_0
	MSseq_end
seq_falcoplane
	MSseq_attr	0eh
	db	10,idx_obj_d4_1_0
	MSseq_end

seq_peppyplane	
	MSseq_attr	0
	db	10,idx_obj_d4_1_4
	MSseq_end

seq_slippyplane
	MSseq_attr	0eh
	db	10,idx_obj_d4_1_4
	MSseq_end

seq_catplane	
	MSseq_attr	0
	db	10,idx_obj_d4_1_2
	MSseq_end
seq_girlplane
	MSseq_attr	0eh
	db	10,idx_obj_d4_1_2
	MSseq_end

;**************************************************************************
;	plane fire oam data
;**************************************************************************

obj_d4_1_8
	MSoam_big	24
	db	000h,000h,00ah,0cdh
	db	010h,000h,008h,0cdh
	db	020h,000h,006h,0cdh
	db	000h,010h,004h,0cdh
	db	010h,010h,002h,0cdh
	db	020h,010h,000h,0cdh
	db	0f0h,000h,00ah,08dh
	db	0e0h,000h,008h,08dh
	db	0d0h,000h,006h,08dh
	db	0f0h,010h,004h,08dh
	db	0e0h,010h,002h,08dh
	db	0d0h,010h,000h,08dh
	db	000h,0f0h,00ah,04dh
	db	010h,0f0h,008h,04dh
	db	020h,0f0h,006h,04dh
	db	0f0h,0f0h,00ah,00dh
	db	0e0h,0f0h,008h,00dh
	db	0d0h,0f0h,006h,00dh
	db	000h,0e0h,004h,04dh
	db	010h,0e0h,002h,04dh
	db	020h,0e0h,000h,04dh
	db	0f0h,0e0h,004h,00dh
	db	0e0h,0e0h,002h,00dh
	db	0d0h,0e0h,000h,00dh

obj_d4_1_9
	MSoam_big	24
	db	0fah,000h,00ah,0cdh
	db	00ah,000h,008h,0cdh
	db	01ah,000h,006h,0cdh
	db	0fah,010h,004h,0cdh
	db	00ah,010h,002h,0cdh
	db	01ah,010h,000h,0cdh
	db	0f1h,000h,00ah,08dh
	db	0e1h,000h,008h,08dh
	db	0d1h,000h,006h,08dh
	db	0f1h,010h,004h,08dh
	db	0e1h,010h,002h,08dh
	db	0d1h,010h,000h,08dh
	db	0fah,0f0h,00ah,04dh
	db	00ah,0f0h,008h,04dh
	db	01ah,0f0h,006h,04dh
	db	0f1h,0f0h,00ah,00dh
	db	0e1h,0f0h,008h,00dh
	db	0d1h,0f0h,006h,00dh
	db	0fah,0e0h,004h,04dh
	db	00ah,0e0h,002h,04dh
	db	01ah,0e0h,000h,04dh
	db	0f1h,0e0h,004h,00dh
	db	0e1h,0e0h,002h,00dh
	db	0d1h,0e0h,000h,00dh

obj_d4_1_10
	MSoam_big	24
	db	0f6h,000h,00ah,0cdh
	db	004h,000h,008h,0cdh
	db	014h,000h,006h,0cdh
	db	0f6h,010h,004h,0cdh
	db	004h,010h,002h,0cdh
	db	014h,010h,000h,0cdh
	db	0f2h,000h,00ah,08dh
	db	0e2h,000h,008h,08dh
	db	0d2h,000h,006h,08dh
	db	0f2h,010h,004h,08dh
	db	0e2h,010h,002h,08dh
	db	0d2h,010h,000h,08dh
	db	0f6h,0f0h,00ah,04dh
	db	004h,0f0h,008h,04dh
	db	014h,0f0h,006h,04dh
	db	0f2h,0f0h,00ah,00dh
	db	0e2h,0f0h,008h,00dh
	db	0d2h,0f0h,006h,00dh
	db	0f6h,0e0h,004h,04dh
	db	004h,0e0h,002h,04dh
	db	014h,0e0h,000h,04dh
	db	0f2h,0e0h,004h,00dh
	db	0e2h,0e0h,002h,00dh
	db	0d2h,0e0h,000h,00dh

;**************************************************************************
;		OBJ data
;**************************************************************************

obj_d4_1_0
	MSoam_big	9
	db	0f0h,000h,0a0h,028h
	db	020h,000h,0a6h,028h
	db	010h,000h,0a4h,028h
	db	000h,000h,0a2h,028h
	db	0e0h,0f8h,088h,028h
	db	010h,0f0h,08eh,028h
	db	000h,0f0h,08ch,028h
	db	0f0h,0f0h,08ah,028h
	db	0d0h,0f8h,086h,028h

obj_d4_1_2
	MSoam_big	10
	db	010h,0f0h,0c0h,028h
	db	020h,000h,0cah,028h
	db	010h,000h,0c8h,028h
	db	000h,000h,0c6h,028h
	db	0f0h,000h,0c4h,028h
	db	020h,0f0h,0c2h,028h
	db	000h,0f0h,0aeh,028h
	db	0f0h,0f0h,0ach,028h
	db	0e0h,0f8h,0aah,028h
	db	0d0h,0f8h,0a8h,028h

obj_d4_1_4
	MSoam_big	10
	db	0f0h,0f0h,0e0h,028h
	db	020h,000h,0eeh,028h
	db	010h,000h,0ech,028h
	db	000h,000h,0eah,028h
	db	0f0h,000h,0e8h,028h
	db	0e0h,000h,0e6h,028h
	db	010h,0f0h,0e4h,028h
	db	000h,0f0h,0e2h,028h
	db	0e0h,0f0h,0ceh,028h
	db	0d0h,0f0h,0cch,028h

;=========================================================================

