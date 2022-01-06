;-------------------------------------------------------------------;
;                                                                   ;
;                    STARFOX II - THE SEQUEL                        ;
;                                                                   ;
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -;
;                                                                   ;
; FILE:         MISMAPSUB.ASM                                       ;
; AUTHOR:       YASUHIRO KAWAGUCHI                                  ;
; DESCRIPTION:  Code for generating sprites                         ;
; DATE CREATED: 20-5-95    	                                       ;
;                                                                   ;
;-------------------------------------------------------------------;
;=====================================================================
;*								*
;*	 		MACRO Definition			*
;*								*
;=====================================================================

km_mismapchart	macro	[time,addr]
	dw	{time}
	dw	{addr}&WM
	endm
km_mismapchartend	macro
	dw	-1
	endm

km_mismapchartwolfappear	macro
	dw	-2
	dw	mmchart_wolfappear&WM
	endm

;=====================================================================
;*			Map Chart Data				*
;=====================================================================

mmchart_timechart
mmchart_easy
	km_mismapchart	0,mmchart_start
	km_mismapchart	20,mmchart_wolfteamfree
	km_mismapchart	25,mmchart_timanappear
	km_mismapchart	35,mmchart_wolfteamfree
	km_mismapchart	40,mmchart_senkantotugeki
	km_mismapchartwolfappear
	km_mismapchartend

mmchart_normal
	km_mismapchart	0,mmchart_start
	km_mismapchart	38,mmchart_missilefreeze	;38
	km_mismapchart	42,mmchart_virusbornenable	;42
	km_mismapchart	45,mmchart_missileall		;45
	km_mismapchart	50,mmchart_wolfteamfree		;65
	km_mismapchart	60,mmchart_senkantotugeki	;75
	km_mismapchart	85,mmchart_senkanhojyuu		;100
	km_mismapchart	95,mmchart_wolfteamfree		;35
	km_mismapchart	110,mmchart_timanappear		;125
	km_mismapchart	120,mmchart_senkantotugeki	;140
	km_mismapchart	130,mmchart_wolfteamfree	;110
	km_mismapchart	190,mmchart_missileall		;200
	km_mismapchartwolfappear
	km_mismapchartend
;mmchart_normal	8/18 henkou
;	km_mismapchart	0,mmchart_start
;	km_mismapchart	35,mmchart_wolfteamfree		;35
;	km_mismapchart	38,mmchart_missilefreeze	;38
;	km_mismapchart	42,mmchart_virusbornenable	;42
;	km_mismapchart	45,mmchart_missileall		;45
;	km_mismapchart	50,mmchart_wolfteamfree		;65
;	km_mismapchart	60,mmchart_senkantotugeki	;75
;	km_mismapchart	85,mmchart_senkanhojyuu	;100
;	km_mismapchart	110,mmchart_timanappear		;125
;	km_mismapchart	120,mmchart_senkantotugeki	;140
;	km_mismapchart	130,mmchart_wolfteamfree	;110
;	km_mismapchart	190,mmchart_missileall		;200
;	km_mismapchartwolfappear
;	km_mismapchartend
;mmchart_normal 7/2made no data
;	km_mismapchart	0,mmchart_start
;	km_mismapchart	35,mmchart_wolfteamfree		;35
;	km_mismapchart	38,mmchart_missilefreeze	;38
;	km_mismapchart	42,mmchart_virusbornenable	;42
;	km_mismapchart	45,mmchart_missileall		;45
;	km_mismapchart	65,mmchart_wolfteamfree		;65
;	km_mismapchart	75,mmchart_senkantotugeki	;75
;	km_mismapchart	100,mmchart_senkanhojyuu	;100
;	km_mismapchart	115,mmchart_timanappear		;125
;	km_mismapchart	130,mmchart_senkantotugeki	;140
;	km_mismapchart	140,mmchart_wolfteamfree	;110
;	km_mismapchart	200,mmchart_missileall		;200
;	km_mismapchartwolfappear
;	km_mismapchartend
;;;yasashisugita tokino
;;;mmchart_normal
;;;	km_mismapchart	0,mmchart_start
;;;	km_mismapchart	35,mmchart_wolfteamfree		;25
;;;	km_mismapchart	40,mmchart_missilefreeze	;28
;;;	km_mismapchart	42,mmchart_virusbornenable	;20
;;;	km_mismapchart	50,mmchart_missileall		;35
;;;	km_mismapchart	65,mmchart_wolfteamfree		;45
;;;	km_mismapchart	80,mmchart_senkantotugeki	;55
;;;	km_mismapchart	100,mmchart_senkanhojyuu	;65
;;;	km_mismapchart	110,mmchart_wolfteamfree	;75
;;;	km_mismapchart	125,mmchart_timanappear		;85
;;;	km_mismapchart	140,mmchart_senkantotugeki	;100
;;;	km_mismapchart	200,mmchart_missileall		;200
;;;	km_mismapchartwolfappear
;;;	km_mismapchartend
;;;muzukashikatta tokino data
;;;mmchart_normal
;;;	km_mismapchart	0,mmchart_start
;;;	km_mismapchart	20,mmchart_virusbornenable
;;;	km_mismapchart	25,mmchart_wolfteamfree
;;;	km_mismapchart	28,mmchart_missilefreeze
;;;	km_mismapchart	35,mmchart_missileall		;35
;;;	km_mismapchart	45,mmchart_wolfteamfree
;;;	km_mismapchart	55,mmchart_senkantotugeki	;40
;;;	km_mismapchart	65,mmchart_senkanhojyuu		;50
;;;	km_mismapchart	75,mmchart_wolfteamfree
;;;	km_mismapchart	85,mmchart_timanappear		;70
;;;	km_mismapchart	100,mmchart_senkantotugeki	;100
;;;	km_mismapchart	200,mmchart_missileall		;
;;;	km_mismapchart	210,mmchart_wolfappear		;
;;;	km_mismapchartend
;;;
mmchart_hard
	km_mismapchart	0,mmchart_start
	km_mismapchart	35,mmchart_virusbornenable	;28
	km_mismapchart	49,mmchart_senkantotugeki	;50
	km_mismapchart	52,mmchart_missilefreeze	;55
	km_mismapchart	60,mmchart_planethojyuu		;65
	km_mismapchart	90,mmchart_senkanhojyuu		;95
	km_mismapchart	95,mmchart_wolfteamfree		;110
	km_mismapchart	110,mmchart_timanappear		;120
	km_mismapchart	115,mmchart_wolfteamfree	;130
	km_mismapchart	120,mmchart_senkantotugeki	;140
	km_mismapchart	145,mmchart_wolfteamfree		;80
	km_mismapchart	165,mmchart_missileall		;180
	km_mismapchart	235,mmchart_missileall		;250
	km_mismapchart	285,mmchart_missileall		;
	km_mismapchartwolfappear
	km_mismapchartend

;;mmchart_hard ;95,8,8
;;	km_mismapchart	0,mmchart_start
;;	km_mismapchart	35,mmchart_virusbornenable	;28
;;	km_mismapchart	49,mmchart_senkantotugeki	;50
;;	km_mismapchart	52,mmchart_missilefreeze	;55
;;	km_mismapchart	60,mmchart_planethojyuu		;65
;;	km_mismapchart	80,mmchart_wolfteamfree		;80
;;	km_mismapchart	90,mmchart_senkanhojyuu		;95
;;	km_mismapchart	105,mmchart_wolfteamfree		;110
;;	km_mismapchart	110,mmchart_timanappear		;120
;;	km_mismapchart	120,mmchart_senkantotugeki	;140
;;	km_mismapchart	130,mmchart_wolfteamfree	;130
;;	km_mismapchart	180,mmchart_missileall		;180
;;	km_mismapchart	250,mmchart_missileall		;250
;;	km_mismapchart	300,mmchart_missileall		;
;;	km_mismapchartwolfappear
;;	km_mismapchartend
;yasashikunattatoki
;;;mmchart_hard
;;;	km_mismapchart	0,mmchart_start
;;;	km_mismapchart	40,mmchart_virusbornenable	;28
;;;	km_mismapchart	48,mmchart_senkantotugeki	;50
;;;	km_mismapchart	50,mmchart_missilefreeze	;55
;;;	km_mismapchart	60,mmchart_planethojyuu		;65
;;;	km_mismapchart	77,mmchart_wolfteamfree		;80
;;;	km_mismapchart	92,mmchart_senkanhojyuu		;95
;;;	km_mismapchart	105,mmchart_wolfteamfree	;110
;;;	km_mismapchart	117,mmchart_timanappear		;120
;;;	km_mismapchart	125,mmchart_wolfteamfree	;130
;;;	km_mismapchart	150,mmchart_senkantotugeki	;140
;;;	km_mismapchart	180,mmchart_missileall		;180
;;;	km_mismapchart	250,mmchart_missileall		;250
;;;	km_mismapchart	300,mmchart_missileall		;
;;;	km_mismapchartwolfappear
;;;	km_mismapchartend
;mmchart_hard
;	km_mismapchart	0,mmchart_start
;	km_mismapchart	28,mmchart_virusbornenable	;28
;	km_mismapchart	50,mmchart_senkantotugeki	;50
;	km_mismapchart	55,mmchart_missilefreeze	;60
;	km_mismapchart	60,mmchart_planethojyuu		;70
;;;;	km_mismapchart	61,mmchart_missileall		;71
;	km_mismapchart	75,mmchart_wolfteamfree
;	km_mismapchart	90,mmchart_senkanhojyuu		;90
;	km_mismapchart	100,mmchart_wolfteamfree
;	km_mismapchart	110,mmchart_timanappear		;110
;	km_mismapchart	120,mmchart_wolfteamfree
;	km_mismapchart	130,mmchart_senkantotugeki	;130
;	km_mismapchart	180,mmchart_missileall		;180
;	km_mismapchartwolfappear
;	km_mismapchartend
;
