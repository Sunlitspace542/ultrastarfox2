;                            ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
;ษอออออออออออออออออออออออออออต  StarFox II ฦออออออออออออออออออออออออออออออป
;บ                           ภฤฤฤฤฤฤฤฤฤฤฤฤฤู                              บ
;บ  Copyright Argonaut Software Limited, 1993.                            บ
;บ  All Rights Reserved.                                                  บ
;วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
;บ  Filename:     PATHS.ASM                                               บ
;วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
;บ  Description:  Simple alien path following code.                       บ
;วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
;บ  Date:         18/9/92.                                                บ
;วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
;บ  Author:       Dylan Cuthbert                                          บ
;วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
;บ  Modification list:                                                    บ
;บ                                                                        บ
;ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ


pathinfo	=	0	; output path information?

	include		pathmacs.inc

;-----
; we must include the pathkern externals here to allow symbol checking

	INC_X_	pathkern	; equate externs as '_x_<name>' with value 0
	
;-----

pathbank	equ	((*>>16)/2+$40)

paths	=	*&$ff8000

	incfile	pathdata.asm

dpaths
	incfile	dpathdat.asm

;	printf	numpaths," paths in ",*-paths," bytes.%n"

;--- NOTE: this file is continued in paths2.asm

