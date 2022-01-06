;                            ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
;ษอออออออออออออออออออออออออออต  StarFox II ฦออออออออออออออออออออออออออออออป
;บ                           ภฤฤฤฤฤฤฤฤฤฤฤฤฤู                              บ
;บ  Copyright Argonaut Software Limited, 1993.                            บ
;บ  All Rights Reserved.                                                  บ
;วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
;บ  Filename:     PATHS2.ASM                                              บ
;วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
;บ  Description:  Simple alien path following code part 2                 บ
;วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
;บ  Date:         30/8/94.                                                บ
;วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
;บ  Author:       Dylan Cuthbert                                          บ
;วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
;บ  Modification list:                                                    บ
;บ                                                                        บ
;ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ


paths	=	*&$ff0000

kpaths
	incfile	kpathdat.asm
bpaths
	incfile	bpathdat.asm
tpaths
	incfile	tpathdat.asm
ppaths
	incfile	ppathdat.asm
gpaths
	incfile	gpathdat.asm


;--- Close the information file if need be ---

	IFNE	pathinfo

	FCLOSE	!

	include	pathinfo.asm

	ENDC
