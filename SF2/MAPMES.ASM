;*********************************************************************
;*								*
;*	------------------------				*
;*		STARFOX2 					*
;*	------------------------				*
;*								*
;*	File 		: mapmessage.asm			*
;* 	Description	: missionmap_message			*
;*	Date		: 1994.8.1				*
;*	Author		: H.Yajima				*
;*								*
;*********************************************************************
;
;
;
;-------------------------------------------------------------------
	INCPUB	mapmes
;-------------------------------------------------------------------

data_mm	macro
	db	mm_stage\1step0
	db	mm_stage\1step1
	db	mm_stage\1step2
	db	mm_stage\1step3
	db	mm_stage\1step4
	db	mm_stage\1step5
	db	mm_stage\1step6
	db	mm_stage\1step7
	db	mm_stage\1step8
	db	mm_stage\1step9
	db	mm_stage\1stepA
	db	mm_stage\1stepB
	db	mm_stage\1stepC
	db	mm_stage\1stepD
	db	mm_stage\1stepE
	db	mm_stage\1stepF
	endm

;-------------------------------------------------------------------


;===================== STAGE(1) ====================================
mm_stage1step0 = 13
mm_stage1step1 = 13
mm_stage1step2 = 13
mm_stage1step3 = 13
mm_stage1step4 = 13
mm_stage1step5 = 13
mm_stage1step6 = 13
mm_stage1step7 = 13
mm_stage1step8 = 13
mm_stage1step9 = 13
mm_stage1stepA = 13
mm_stage1stepB = 13
mm_stage1stepC = 13
mm_stage1stepD = 13
mm_stage1stepE = 13
mm_stage1stepF = 13
;===================== STAGE(2) ====================================
mm_stage2step0 = 13
mm_stage2step1 = 13
mm_stage2step2 = 13
mm_stage2step3 = 13
mm_stage2step4 = 13
mm_stage2step5 = 13
mm_stage2step6 = 13
mm_stage2step7 = 13
mm_stage2step8 = 13
mm_stage2step9 = 13
mm_stage2stepA = 13
mm_stage2stepB = 13
mm_stage2stepC = 13
mm_stage2stepD = 13
mm_stage2stepE = 13
mm_stage2stepF = 13
;===================== STAGE(3) ====================================
mm_stage3step0 = 13
mm_stage3step1 = 13
mm_stage3step2 = 13
mm_stage3step3 = 13
mm_stage3step4 = 13
mm_stage3step5 = 13
mm_stage3step6 = 13
mm_stage3step7 = 13
mm_stage3step8 = 13
mm_stage3step9 = 13
mm_stage3stepA = 13
mm_stage3stepB = 13
mm_stage3stepC = 13
mm_stage3stepD = 13
mm_stage3stepE = 13
mm_stage3stepF = 13
;===================== STAGE(4) ====================================
mm_stage4step0 = 13
mm_stage4step1 = 13
mm_stage4step2 = 13
mm_stage4step3 = 13
mm_stage4step4 = 13
mm_stage4step5 = 13
mm_stage4step6 = 13
mm_stage4step7 = 13
mm_stage4step8 = 13
mm_stage4step9 = 13
mm_stage4stepA = 13
mm_stage4stepB = 13
mm_stage4stepC = 13
mm_stage4stepD = 13
mm_stage4stepE = 13
mm_stage4stepF = 13
;===================== STAGE(5) ====================================
mm_stage5step0 = 13
mm_stage5step1 = 13
mm_stage5step2 = 13
mm_stage5step3 = 13
mm_stage5step4 = 13
mm_stage5step5 = 13
mm_stage5step6 = 13
mm_stage5step7 = 13
mm_stage5step8 = 13
mm_stage5step9 = 13
mm_stage5stepA = 13
mm_stage5stepB = 13
mm_stage5stepC = 13
mm_stage5stepD = 13
mm_stage5stepE = 13
mm_stage5stepF = 13
;===================== STAGE(6) ====================================
mm_stage6step0 = 13
mm_stage6step1 = 13
mm_stage6step2 = 13
mm_stage6step3 = 13
mm_stage6step4 = 13
mm_stage6step5 = 13
mm_stage6step6 = 13
mm_stage6step7 = 13
mm_stage6step8 = 13
mm_stage6step9 = 13
mm_stage6stepA = 13
mm_stage6stepB = 13
mm_stage6stepC = 13
mm_stage6stepD = 13
mm_stage6stepE = 13
mm_stage6stepF = 13

;====================================================================

	ifeq	1
mapmessage_table
	data_mm	1	; stage 1
	data_mm	2	; stage 2
	data_mm	3	; stage 3
	data_mm	4	; stage 4
	data_mm	5	; stage 5
	data_mm	6	; stage 6
	endc

mapmessage_table
	db	13	;(0)
	db	13	;(1)
	db	13	;(2)
	db	13	;(3)
	db	13	;(4)
	db	13	;(5)
	db	14	;(6) battle-ship
	db	13	;(7)
	db	13	;(8)
	db	13	;(9)
	





;====================================================================
;====================================================================
; END END END END END END END END END END END END END END END END  
;====================================================================
;====================================================================

