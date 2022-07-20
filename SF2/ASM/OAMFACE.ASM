facedebug	= 0
;*********************************************************************
;*								*
;*	------------------------				*
;*		STARFOX2 					*
;*	------------------------				*
;*								*
;*	File 		: oamface.asm				*
;* 	Description	: face OBJ animation data		*
;*	Date		: 1994.11.4				*
;*	Author		: H.Yajima				*
;*								*
;*********************************************************************



;*********************************************************************
;;		*************************************************
;; GIALS FACE	*************************************************
;; ANIMATION DATA	*************************************************
;;		*************************************************
;*********************************************************************

;---------------------------------------------------------------------
seq_girlok
	db	oam_okwait2,idx_obj_d2_5_0 
	MSseq_friendwait girl	
	MSseq_sound	sport3_ryoukai_gal_2
	db	004h,idx_obj_d2_5_1 
	db	004h,idx_obj_d2_5_2 
	db	004h,idx_obj_d2_5_3 
	db	004h,idx_obj_d2_5_4 
	db	060h,idx_obj_d2_5_5 
	db	020h,idx_obj_d2_5_0 
	MSseq_end

;---------------------------------------------------------------------
seq_girlst
	db	3fh,idx_obj_d2_5_0
	db	3fh,idx_obj_d2_5_0
	db	8,idx_obj_d2_5_1

	ifne	facedebug
	db	3fh,idx_obj_d2_5_0
	db	004h,idx_obj_d2_5_1 
	db	004h,idx_obj_d2_5_2 
	db	004h,idx_obj_d2_5_3 
	db	004h,idx_obj_d2_5_4 
	db	020h,idx_obj_d2_5_5 
	endc

	MSseq_end

;---------------------------------------------------------------------

;**************************************************************************
;		OBJ data
;**************************************************************************



obj_d2_5_0
	MSoam_big	17
girl_common1
	db	008h,003h,022h,034h
	db	000h,010h,00eh,074h
	db	010h,010h,00ch,074h
	db	000h,000h,00ah,074h
	db	010h,000h,008h,074h
	db	000h,0f0h,006h,074h
	db	010h,0f0h,004h,074h
	db	000h,0e0h,002h,074h
	db	010h,0e0h,000h,074h
	db	0f0h,010h,00eh,034h
	db	0e0h,010h,00ch,034h
	db	0f0h,000h,00ah,034h
	db	0e0h,000h,008h,034h
	db	0f0h,0f0h,006h,034h
	db	0e0h,0f0h,004h,034h
	db	0f0h,0e0h,002h,034h
	db	0e0h,0e0h,000h,034h

obj_d2_5_1
	MSoam_big	19
	db	0f0h,0f8h,020h,034h
	db	000h,0f8h,020h,074h
	MSoam_romjmp	girl_common1


obj_d2_5_2
	MSoam_subon	23
	db	0aah	;(subdata)
	db	000h	;(subdata)
	db	0aah	;(subdata)
	db	0aah	;(subdata)
	db	0aah	;(subdata)
	db	02ah	;(subdata)
	db	000h,0f8h,020h,074h
	db	0f0h,0f8h,020h,034h
	db	000h,0f0h,006h,074h
	db	0f0h,0f0h,006h,034h
	db	018h,018h,01ch,074h
	db	018h,010h,00ch,074h
	db	0e0h,018h,01ch,034h
	db	0e0h,010h,00ch,034h
	db	008h,003h,022h,034h
	db	010h,010h,024h,074h
	db	000h,010h,026h,074h
	db	000h,000h,028h,074h
	db	0f0h,010h,026h,034h
	db	0e0h,010h,024h,034h
	db	0f0h,000h,028h,034h
	db	010h,000h,008h,074h
	db	010h,0f0h,004h,074h
	db	000h,0e0h,002h,074h
	db	010h,0e0h,000h,074h
	db	0e0h,000h,008h,034h
	db	0e0h,0f0h,004h,034h
	db	0f0h,0e0h,002h,034h
	db	0e0h,0e0h,000h,034h





obj_d2_5_3
	MSoam_subon	29
	db	0a0h	;(subdata)
	db	000h	;(subdata)
	db	000h	;(subdata)
	db	0aah	;(subdata)
	db	0aah	;(subdata)
	db	0aah	;(subdata)
	db	0aah	;(subdata)
	db	002h	;(subdata)
	db	008h,017h,03fh,034h
	db	008h,00fh,02fh,034h
	db	000h,00fh,02ah,034h
	db	000h,00fh,02ah,034h

	MSoam_romjmp	girl_common3




obj_d2_5_4
	MSoam_subon	29
	db	0a0h	;(subdata)
	db	000h	;(subdata)
	db	000h	;(subdata)
	db	0aah	;(subdata)
	db	0aah	;(subdata)
	db	0aah	;(subdata)
	db	0aah	;(subdata)
	db	002h	;(subdata)
	db	00dh,00bh,03fh,034h
	db	00dh,003h,02fh,034h
	db	005h,003h,02ah,034h
	db	005h,013h,02ch,034h

	MSoam_romjmp	girl_common3


obj_d2_5_5
	MSoam_subon	29
	db	0a0h	;(subdata)
	db	000h	;(subdata)
	db	000h	;(subdata)
	db	0aah	;(subdata)
	db	0aah	;(subdata)
	db	0aah	;(subdata)
	db	0aah	;(subdata)
	db	002h	;(subdata)
	db	016h,00bh,03eh,034h
	db	016h,003h,02eh,034h
	db	006h,003h,02ah,034h
	db	006h,013h,02ch,034h

girl_common3
	db	000h,0f8h,034h,074h
	db	008h,0f8h,024h,074h
	db	0f8h,0f8h,034h,034h
	db	0f0h,0f8h,024h,034h
	db	018h,018h,01ch,074h
	db	018h,010h,00ch,074h
	db	0e0h,018h,01ch,034h
	db	0e0h,010h,00ch,034h
	db	008h,003h,022h,034h
	db	010h,010h,024h,074h
	db	000h,010h,026h,074h
	db	000h,000h,028h,074h
	db	0f0h,010h,026h,034h
	db	0e0h,010h,024h,034h
	db	0f0h,000h,028h,034h
	db	010h,000h,008h,074h
	db	000h,0f0h,006h,074h
	db	010h,0f0h,004h,074h
	db	000h,0e0h,002h,074h
	db	010h,0e0h,000h,074h
	db	0e0h,000h,008h,034h
	db	0f0h,0f0h,006h,034h
	db	0e0h,0f0h,004h,034h
	db	0f0h,0e0h,002h,034h
	db	0e0h,0e0h,000h,034h





	ifeq	1


obj_d2_5_0
	MSoam_big	17
girl_common1
	db	008h,003h,022h,034h
	db	000h,010h,00eh,074h
	db	010h,010h,00ch,074h
	db	000h,000h,00ah,074h
	db	010h,000h,008h,074h
	db	000h,0f0h,006h,074h
	db	010h,0f0h,004h,074h
	db	000h,0e0h,002h,074h
	db	010h,0e0h,000h,074h
	db	0f0h,010h,00eh,034h
	db	0e0h,010h,00ch,034h
	db	0f0h,000h,00ah,034h
	db	0e0h,000h,008h,034h
	db	0f0h,0f0h,006h,034h
	db	0e0h,0f0h,004h,034h
	db	0f0h,0e0h,002h,034h
	db	0e0h,0e0h,000h,034h

obj_d2_5_1
	MSoam_big	19
	db	0f0h,0f8h,020h,034h
	db	000h,0f8h,020h,074h
	MSoam_romjmp	girl_common1


obj_d2_5_2
	MSoam_subon	29
	db	0aah	;(subdata)
	db	000h	;(subdata)
	db	000h	;(subdata)
	db	0aah	;(subdata)
	db	0aah	;(subdata)
	db	0aah	;(subdata)
	db	0aah	;(subdata)
	db	002h
	db	000h,0f8h,020h,074h
	db	0f0h,0f8h,020h,034h
	db	0f0h,0f8h,020h,034h
	db	0f0h,0f8h,020h,034h

	MSoam_romjmp	girl_common3

obj_d2_5_3
	MSoam_subon	29
	db	0a0h	;(subdata)
	db	000h	;(subdata)
	db	000h	;(subdata)
	db	0aah	;(subdata)
	db	0aah	;(subdata)
	db	0aah	;(subdata)
	db	0aah	;(subdata)
	db	002h	;(subdata)
	db	008h,017h,03fh,034h
	db	008h,00fh,02fh,034h
	db	000h,00fh,02ah,034h
	db	000h,00fh,02ah,034h

	MSoam_romjmp	girl_common3

obj_d2_5_4
	MSoam_subon	29
	db	0a0h	;(subdata)
	db	000h	;(subdata)
	db	000h	;(subdata)
	db	0aah	;(subdata)
	db	0aah	;(subdata)
	db	0aah	;(subdata)
	db	0aah	;(subdata)
	db	002h	;(subdata)

	db	00dh,008h,03fh,034h
	db	00dh,000h,02fh,034h
	db	005h,000h,02ah,034h
	db	005h,010h,02ch,034h

	MSoam_romjmp	girl_common3


obj_d2_5_5
	MSoam_subon	29
	db	0a0h	;(subdata)
	db	000h	;(subdata)
	db	000h	;(subdata)
	db	0aah	;(subdata)
	db	0aah	;(subdata)
	db	0aah	;(subdata)
	db	0aah	;(subdata)
	db	002h	;(subdata)

	db	016h,008h,03eh,034h
	db	016h,000h,02eh,034h
	db	006h,000h,02ah,034h
	db	006h,010h,02ch,034h

girl_common3
	db	000h,0f8h,034h,074h
	db	008h,0f8h,024h,074h
	db	0f8h,0f8h,034h,034h
	db	0f0h,0f8h,024h,034h
	db	018h,018h,01ch,074h
	db	018h,010h,00ch,074h
	db	0e0h,018h,01ch,034h
	db	0e0h,010h,00ch,034h
	db	008h,003h,022h,034h
	db	010h,010h,024h,074h
	db	000h,010h,026h,074h
	db	000h,000h,028h,074h
	db	0f0h,010h,026h,034h
	db	0e0h,010h,024h,034h
	db	0f0h,000h,028h,034h
	db	010h,000h,008h,074h
girl_common2
	db	000h,0f0h,006h,074h
	db	010h,0f0h,004h,074h
	db	000h,0e0h,002h,074h
	db	010h,0e0h,000h,074h
	db	0e0h,000h,008h,034h
	db	0f0h,0f0h,006h,034h
	db	0e0h,0f0h,004h,034h
	db	0f0h,0e0h,002h,034h
	db	0e0h,0e0h,000h,034h



	endc

;*********************************************************************
;;		*************************************************
;; CATS FACE		*************************************************
;; ANIMATION DATA	*************************************************
;;		*************************************************
;*********************************************************************

seq_catok
	db	oam_okwait2,idx_obj_d2_4_0 
	MSseq_friendwait cat	
	MSseq_sound	sport3_ryoukai_gal_1
	db	004h,idx_obj_d2_4_2
	db	00ch,idx_obj_d2_4_3 
	db	060h,idx_obj_d2_4_4 
	db	020h,idx_obj_d2_4_0 
	MSseq_end

seq_catst
	db	3fh,idx_obj_d2_4_0
	db	8,idx_obj_d2_4_1
	ifne	facedebug
	db	010h,idx_obj_d2_4_0
	db	004h,idx_obj_d2_4_2
	db	00ch,idx_obj_d2_4_3 
	db	020h,idx_obj_d2_4_4 
	endc
	MSseq_end


;**************************************************************************
;		OBJ data
;**************************************************************************


obj_d2_4_0
	MSoam_subon	18
	db	0a0h	;(subdata)
	db	0aah	;(subdata)
	db	0aah	;(subdata)
	db	0aah	;(subdata)
	db	00ah	;(subdata)
cat_normal
	db	00eh,0fah,03fh,034h
	db	00eh,0f2h,02fh,034h
	db	0f0h,010h,00eh,034h
	db	0e0h,010h,00ch,034h
	db	0f0h,000h,00ah,034h
	db	0e0h,000h,008h,034h
	db	0f0h,0f0h,006h,034h
	db	0e0h,0f0h,004h,034h
	db	0f0h,0e0h,002h,034h
	db	0e0h,0e0h,000h,034h
	db	000h,010h,00eh,074h
	db	010h,010h,00ch,074h
	db	000h,000h,00ah,074h
	db	010h,000h,008h,074h
	db	000h,0f0h,006h,074h
	db	010h,0f0h,004h,074h
	db	000h,0e0h,002h,074h
	db	010h,0e0h,000h,074h

obj_d2_4_1
	MSoam_subon	20
	db	00ah	;(subdata)
	db	0aah	;(subdata)
	db	0aah	;(subdata)
	db	0aah	;(subdata)
	db	0aah	;(subdata)

	db	000h,0fch,020h,074h
	db	0f0h,0fch,020h,034h
	MSoam_romjmp	cat_normal


obj_d2_4_2
	MSoam_subon	21
	db	02ah	;(subdata)
	db	0a8h	;(subdata)
	db	0aah	;(subdata)
	db	0aah	;(subdata)
	db	0aah	;(subdata)
	db	002h	;(subdata)
	db	0f9h,00fh,028h,034h
	db	000h,0fch,020h,074h
	db	0f0h,0fch,020h,034h
	MSoam_romjmp	cat_normal


obj_d2_4_3
	MSoam_subon	20
	db	0a0h	;(subdata)
	db	0aah	;(subdata)
	db	0aah	;(subdata)
	db	0aah	;(subdata)
	db	0aah	;(subdata)
	db	00eh,0f9h,03fh,034h
	db	00eh,0f1h,02fh,034h
	db	0f9h,010h,02ah,034h
	db	0f9h,000h,028h,034h
	MSoam_romjmp	cat_common

obj_d2_4_4
	MSoam_subon	21
	db	000h	;(subdata)
	db	0aah	;(subdata)
	db	0aah	;(subdata)
	db	0aah	;(subdata)
	db	0aah	;(subdata)
	db	002h	;(subdata)
	db	00eh,0f9h,03fh,034h
	db	00eh,0f1h,02fh,034h
	db	00bh,018h,03eh,034h
	db	00bh,010h,02eh,034h
	db	0fbh,010h,02ch,034h

cat_common
	db	000h,010h,026h,074h
	db	000h,000h,024h,074h
	db	000h,0f0h,022h,074h
	db	0f0h,010h,026h,034h
	db	0f0h,000h,024h,034h
	db	0f0h,0f0h,022h,034h
	db	0e0h,010h,00ch,034h
	db	0e0h,000h,008h,034h
	db	0e0h,0f0h,004h,034h
	db	0f0h,0e0h,002h,034h
	db	0e0h,0e0h,000h,034h
	db	010h,010h,00ch,074h
	db	010h,000h,008h,074h
	db	010h,0f0h,004h,074h
	db	000h,0e0h,002h,074h
	db	010h,0e0h,000h,074h


;*********************************************************************
;;		*************************************************
;; SLIPPY FACE	*************************************************
;; ANIMATION DATA	*************************************************
;;		*************************************************
;*********************************************************************




;----------------------------------------------------------

seq_slippyok
	db	oam_okwait2,idx_obj_d2_3_0 
	MSseq_friendwait slippy
	MSseq_sound	sport3_ryoukai_slippy
	db	004h,idx_obj_d2_3_1 
	db	008h,idx_obj_d2_3_2 
	db	004h,idx_obj_d2_3_3 
	db	060h,idx_obj_d2_3_4 
	db	020h,idx_obj_d2_3_0 
	MSseq_end

;----------------------------------------------------------

seq_slippyst
	db	30h,idx_obj_d2_3_0
	db	20h,idx_obj_d2_3_1
	ifne	facedebug
	db	008h,idx_obj_d2_3_2 
	db	004h,idx_obj_d2_3_3 
	db	020h,idx_obj_d2_3_4 
	endc
	MSseq_end

;----------------------------------------------------------

;**************************************************************************
;		OBJ data
;**************************************************************************

obj_d2_3_0
	MSoam_big	16
	db	000h,010h,00eh,074h
	db	010h,010h,00ch,074h
	db	000h,000h,00ah,074h
	db	010h,000h,008h,074h
	db	000h,0f0h,006h,074h
	db	010h,0f0h,004h,074h
	db	000h,0e0h,002h,074h
	db	010h,0e0h,000h,074h
	db	0f0h,010h,00eh,034h
	db	0e0h,010h,00ch,034h
	db	0f0h,000h,00ah,034h
	db	0e0h,000h,008h,034h
	db	0f0h,0f0h,006h,034h
	db	0e0h,0f0h,004h,034h
	db	0f0h,0e0h,002h,034h
	db	0e0h,0e0h,000h,034h

obj_d2_3_1
	MSoam_big	16
	db	000h,010h,020h,074h
	db	0f0h,010h,020h,034h
	db	010h,010h,00ch,074h
	db	010h,000h,008h,074h
	db	010h,0f0h,004h,074h
	db	010h,0e0h,000h,074h
	db	000h,000h,00ah,074h
	db	000h,0f0h,006h,074h
	db	000h,0e0h,002h,074h
	db	0f0h,000h,00ah,034h
	db	0f0h,0f0h,006h,034h
	db	0f0h,0e0h,002h,034h
	db	0e0h,010h,00ch,034h
	db	0e0h,000h,008h,034h
	db	0e0h,0f0h,004h,034h
	db	0e0h,0e0h,000h,034h

obj_d2_3_2
	MSoam_big	16
slippy_common_2
	db	010h,010h,00ch,074h
	db	010h,000h,026h,074h
	db	010h,0f0h,022h,074h
	db	010h,0e0h,000h,074h
	db	000h,010h,02ah,074h
	db	000h,000h,028h,074h
	db	000h,0f0h,024h,074h
	db	000h,0e0h,002h,074h
	db	0f0h,010h,02ah,034h
	db	0f0h,000h,028h,034h
	db	0f0h,0f0h,024h,034h
	db	0f0h,0e0h,002h,034h
	db	0e0h,010h,00ch,034h
	db	0e0h,000h,026h,034h
	db	0e0h,0f0h,022h,034h
	db	0e0h,0e0h,000h,034h

obj_d2_3_3
	MSoam_big	18
	db	00fh,00fh,02ch,074h
	db	0e1h,00fh,02ch,034h
	MSoam_romjmp	slippy_common_2

obj_d2_3_4
	MSoam_big	20
	db	00fh,0ffh,02ch,074h
	db	0e1h,0ffh,02ch,034h
	db	00fh,00fh,02eh,074h
	db	0e1h,00fh,02eh,034h
	MSoam_romjmp	slippy_common_2


;*********************************************************************
;;		*************************************************
;; PEPPY FACE	*************************************************
;; ANIMATION DATA	*************************************************
;;		*************************************************
;*********************************************************************


seq_peppyok
	db	oam_okwait2,idx_obj_d2_2_0 
	MSseq_friendwait peppy
	MSseq_sound	sport3_ryoukai_peppy
	db	008h,idx_obj_d2_2_1 
	db	004h,idx_obj_d2_2_2 
	db	004h,idx_obj_d2_2_3 
	db	060h,idx_obj_d2_2_4 
	db	020h,idx_obj_d2_2_0 
	MSseq_end

seq_peppyst
	db	03fh,idx_obj_d2_2_0
	db	008h,idx_obj_d2_2_1
	ifne	facedebug
	db	004h,idx_obj_d2_2_2 
	db	004h,idx_obj_d2_2_3 
	db	020h,idx_obj_d2_2_4 
	endc
	MSseq_end


;*********************************************************************
; sprite data
;*********************************************************************

obj_d2_2_0
	MSoam_big	16
peppy_common_1
	db	010h,010h,00ch,074h
	db	010h,000h,008h,074h
	db	010h,0f0h,004h,074h
	db	010h,0e0h,000h,074h
	db	000h,010h,00eh,074h
	db	000h,000h,00ah,074h
	db	000h,0f0h,006h,074h
	db	000h,0e0h,002h,074h
	db	0f0h,010h,00eh,034h
	db	0e0h,010h,00ch,034h
	db	0f0h,000h,00ah,034h
	db	0e0h,000h,008h,034h
	db	0f0h,0f0h,006h,034h
	db	0e0h,0f0h,004h,034h
	db	0f0h,0e0h,002h,034h
	db	0e0h,0e0h,000h,034h

obj_d2_2_1
	MSoam_big	18
	db	000h,0f8h,020h,074h
	db	0f0h,0f8h,020h,034h
	MSoam_romjmp	peppy_common_1

obj_d2_2_2
	MSoam_big	16
peppy_common_2
	db	010h,000h,024h,074h
	db	010h,010h,00ch,074h
	db	010h,0f0h,004h,074h
	db	010h,0e0h,000h,074h
	db	000h,010h,028h,074h
	db	000h,000h,026h,074h
	db	000h,0f0h,022h,074h
	db	000h,0e0h,002h,074h
	db	0f0h,010h,028h,034h
	db	0f0h,000h,026h,034h
	db	0e0h,000h,024h,034h
	db	0f0h,0f0h,022h,034h
	db	0e0h,010h,00ch,034h
	db	0e0h,0f0h,004h,034h
	db	0f0h,0e0h,002h,034h
	db	0e0h,0e0h,000h,034h

obj_d2_2_3
	MSoam_big	17
	db	0e1h,00fh,02ch,034h
	MSoam_romjmp	peppy_common_2

obj_d2_2_4
	MSoam_big	18
	db	0e1h,00fh,02eh,034h
	db	0e1h,0ffh,02ch,034h
	MSoam_romjmp	peppy_common_2


;*********************************************************************
;;		*************************************************
;; FALCO FACE	*************************************************
;; ANIMATION DATA	*************************************************
;;		*************************************************
;*********************************************************************


;---------------------------------------------------
seq_falcook
	db	oam_okwait2,idx_obj_d2_1_0 
	MSseq_friendwait falco
	MSseq_sound	sport3_ryoukai_falco
	db	008h,idx_obj_d2_1_1 
	db	004h,idx_obj_d2_1_2 
	db	004h,idx_obj_d2_1_3 
	db	060h,idx_obj_d2_1_4 
	db	020h,idx_obj_d2_1_0 
	MSseq_end
;---------------------------------------------------
seq_falcost
	db	03fh,idx_obj_d2_1_0
	db	008h,idx_obj_d2_1_1
	ifne	facedebug
	db	004h,idx_obj_d2_1_2 
	db	004h,idx_obj_d2_1_3 
	db	020h,idx_obj_d2_1_4 
	endc
	MSseq_end
;---------------------------------------------------



;**************************************************************************
;		OBJ data
;**************************************************************************

obj_d2_1_0
	MSoam_big	16
falco_common_1
	db	010h,010h,00ch,074h
	db	010h,000h,008h,074h
	db	010h,0f0h,004h,074h
	db	010h,0e0h,000h,074h
	db	000h,010h,00eh,074h
	db	000h,000h,00ah,074h
	db	000h,0f0h,006h,074h
	db	000h,0e0h,002h,074h
	db	0f0h,010h,00eh,034h
	db	0e0h,010h,00ch,034h
	db	0f0h,000h,00ah,034h
	db	0e0h,000h,008h,034h
	db	0f0h,0f0h,006h,034h
	db	0e0h,0f0h,004h,034h
	db	0f0h,0e0h,002h,034h
	db	0e0h,0e0h,000h,034h

obj_d2_1_1
	MSoam_big	18
	db	000h,0f0h,020h,074h
	db	0f0h,0f0h,020h,034h
	MSoam_romjmp	falco_common_1

obj_d2_1_2
	MSoam_big	16
falco_common_2
	db	010h,010h,028h,074h
	db	0e0h,010h,028h,034h
	db	000h,010h,02ah,074h
	db	000h,000h,026h,074h
	db	000h,0f0h,024h,074h
	db	000h,0e0h,022h,074h
	db	0f0h,010h,02ah,034h
	db	0f0h,000h,026h,034h
	db	0f0h,0f0h,024h,034h
	db	0f0h,0e0h,022h,034h
	db	010h,000h,008h,074h
	db	010h,0f0h,004h,074h
	db	010h,0e0h,000h,074h
	db	0e0h,000h,008h,034h
	db	0e0h,0f0h,004h,034h
	db	0e0h,0e0h,000h,034h

obj_d2_1_3

	MSoam_big	17
	db	009h,00fh,02ch,034h
	MSoam_romjmp	falco_common_2

obj_d2_1_4
	MSoam_big	18
	db	00fh,00fh,02eh,034h
	db	00fh,0ffh,02ch,034h
	MSoam_romjmp	falco_common_2


;*********************************************************************
;;		*************************************************
;; FOX FACE		*************************************************
;; ANIMATION DATA	*************************************************
;;		*************************************************
;*********************************************************************

;---------------------------------------------------
seq_foxok	
	db	oam_okwait2,idx_obj_d2_0_0 
	MSseq_friendwait fox
	MSseq_sound	sport3_ryoukai_fox
	db	008h,idx_obj_d2_0_1 
	db	004h,idx_obj_d2_0_2 
	db	004h,idx_obj_d2_0_4 
	db	060h,idx_obj_d2_0_5 
	db	020h,idx_obj_d2_0_0 
	MSseq_end
;---------------------------------------------------
seq_foxst
	db	03fh,idx_obj_d2_0_0
	db	008h,idx_obj_d2_0_1
	ifne	facedebug
	db	004h,idx_obj_d2_0_2 
	db	004h,idx_obj_d2_0_4 
	db	020h,idx_obj_d2_0_5 
	endc
	MSseq_end
;---------------------------------------------------

;**************************************************************************
;		OBJ data
;**************************************************************************

obj_d2_0_0
	MSoam_big	16
	db	010h,000h,02ah,034h
	MSoam_romjmp	fox_common_1

obj_d2_0_1
	MSoam_big	18
	db	010h,000h,02ah,034h
	db	000h,0f8h,020h,074h
	db	0f0h,0f8h,020h,034h

fox_common_1
	db	010h,010h,00ch,074h
	db	010h,0f0h,004h,074h
	db	010h,0e0h,000h,074h
	db	000h,010h,00eh,074h
	db	000h,000h,00ah,074h
	db	000h,0f0h,006h,074h
	db	000h,0e0h,002h,074h
	db	0f0h,010h,00eh,034h
	db	0e0h,010h,00ch,034h
	db	0f0h,000h,00ah,034h
	db	0e0h,000h,008h,034h
	db	0f0h,0f0h,006h,034h
	db	0e0h,0f0h,004h,034h
	db	0f0h,0e0h,002h,034h
	db	0e0h,0e0h,000h,034h

obj_d2_0_2
	MSoam_big	17
	db	0e1h,00fh,02ch,034h
	db	010h,000h,02ah,034h
	MSoam_romjmp	fox_common_1


obj_d2_0_4
	MSoam_big	18
	db	0e1h,0ffh,02ch,034h
	db	0e1h,00fh,02eh,034h
	MSoam_romjmp	fox_common_2

obj_d2_0_5
	MSoam_big	19
	db	0e1h,00fh,026h,034h
	db	0e1h,0efh,02ch,034h
	db	0e1h,0ffh,02eh,034h

fox_common_2
	db	010h,000h,02ah,034h
	db	000h,0f0h,022h,074h
	db	000h,010h,028h,074h
	db	000h,000h,024h,074h
	db	0f0h,010h,028h,034h
	db	0f0h,000h,024h,034h
	db	0f0h,0f0h,022h,034h
	db	010h,010h,00ch,074h
	db	010h,0f0h,004h,074h
	db	010h,0e0h,000h,074h
	db	000h,0e0h,002h,074h
	db	0e0h,010h,00ch,034h
	db	0e0h,000h,008h,034h
	db	0e0h,0f0h,004h,034h
	db	0f0h,0e0h,002h,034h
	db	0e0h,0e0h,000h,034h



;==========================================================================
; END END END END END END END END END END END END END END END END END END  
;==========================================================================

