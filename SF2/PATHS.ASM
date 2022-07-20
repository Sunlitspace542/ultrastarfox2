;                            �������������Ŀ
;���������������������������͵  StarFox II ������������������������������ͻ
;�                           ���������������                              �
;�  Copyright Argonaut Software Limited, 1993.                            �
;�  All Rights Reserved.                                                  �
;������������������������������������������������������������������������Ķ
;�  Filename:     PATHS.ASM                                               �
;������������������������������������������������������������������������Ķ
;�  Description:  Simple alien path following code.                       �
;������������������������������������������������������������������������Ķ
;�  Date:         18/9/92.                                                �
;������������������������������������������������������������������������Ķ
;�  Author:       Dylan Cuthbert                                          �
;������������������������������������������������������������������������Ķ
;�  Modification list:                                                    �
;�                                                                        �
;������������������������������������������������������������������������ͼ


pathinfo	=	0	; output path information?

	include		INC\pathmacs.inc

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

