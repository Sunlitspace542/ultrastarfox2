;*********************************************************************
;*								*
;*	------------------------				*
;*		STARFOX2 					*
;*	------------------------				*
;*								*
;*	File 		: chartdat.asm				*
;*	Description	; ROM object animation chart		*
;*	Date		: 1994.10.14				*
;*	Author		: H.Yajima				*
;*								*
;*********************************************************************
;
;
;
;
;
;---------------------------------------------------------------------
	INCPUB	chartdat
;---------------------------------------------------------------------
;
;
;
;
;
;*********************************************************************
;
; map animation program end
;
;*********************************************************************
MAend	macro
	db	81h
	endm

;---------------------------------------------------------------------




;*********************************************************************
;	map animation obj macros
;*********************************************************************

;---------------------------------------------------------------------
mapanime_liststart	macro
mapanime_number = 0
	endm

;---------------------------------------------------------------------
mapanime_list	macro	[addr]
	dw	{addr}-ROMobjchart
cd_{addr}	equ	mapanime_number
mapanime_number = mapanime_number+1
	endm

;---------------------------------------------------------------------
mapanime_listend	macro
	printf	"list %xmapanime_number   "
	endm
;---------------------------------------------------------------------

mapobj_oamdata	macro	[h,v,fp,pno,ano,char]
	db	{h},{v}
	db	{char}&0ffh
	db	oamdata_pri{pno}+oamdata_attr{ano}+oamdata_{fp}flip+{char}/256
	endm

;---------------------------------------------------------------------
ROMobjchart
	
;----------------------------------------------------------
	incfile	d3_3.asm	; openning animation

;----------------------------------------------------------

;
;
;
;
;
;
;
;=====================================================================
;=====================================================================
; END END END END END END END END END END END END END END END END END
;=====================================================================
;=====================================================================
