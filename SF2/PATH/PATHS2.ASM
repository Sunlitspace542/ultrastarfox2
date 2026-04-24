;                            �������������Ŀ
;���������������������������͵  StarFox II ������������������������������ͻ
;�                           ���������������                              �
;�  Copyright Argonaut Software Limited, 1993.                            �
;�  All Rights Reserved.                                                  �
;������������������������������������������������������������������������Ķ
;�  Filename:     PATHS2.ASM                                              �
;������������������������������������������������������������������������Ķ
;�  Description:  Simple alien path following code part 2                 �
;������������������������������������������������������������������������Ķ
;�  Date:         30/8/94.                                                �
;������������������������������������������������������������������������Ķ
;�  Author:       Dylan Cuthbert                                          �
;������������������������������������������������������������������������Ķ
;�  Modification list:                                                    �
;�                                                                        �
;������������������������������������������������������������������������ͼ

	incpub	paths

paths	=	*&$ff0000

kpaths
	incfile	PATH\kpathdat.asm
bpaths
	incfile PATH\bpathdat.asm
tpaths
	incfile	PATH\tpathdat.asm
ppaths
	incfile	PATH\ppathdat.asm
gpaths
	incfile	PATH\gpathdat.asm


;--- Close the information file if need be ---

	IFNE	pathinfo

	FCLOSE	!

	include	ASM\pathinfo.asm

	ENDC
