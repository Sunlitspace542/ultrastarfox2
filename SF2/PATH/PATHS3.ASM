;
; PATHS3.ASM
; Extra path bank for expansion.
;

	incpub	paths

pathbank3	equ	((*>>16)/2+$40)

paths	=	*&$ff0000

	incfile	PATH\path3dat.asm
