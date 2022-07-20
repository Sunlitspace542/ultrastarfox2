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


paths	=	*&$ff0000

kpaths
	incfile	ASM\kpathdat.asm
bpaths
	incfile	bpathdat.asm
tpaths
	incfile	ASM\tpathdat.asm
ppaths
	incfile	ASM\ppathdat.asm
gpaths
	incfile	ASM\gpathdat.asm


;--- Close the information file if need be ---

	IFNE	pathinfo

	FCLOSE	!

	include	ASM\pathinfo.asm

	ENDC
