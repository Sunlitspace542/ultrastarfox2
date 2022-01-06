;*********************************************************************
;*								*
;*	------------------------				*
;*		STARFOX2 					*
;*	------------------------				*
;*								*
;*	File 		: mesdata.asm				*
;* 	Description	: map message data			*
;*	Date		: 1995.6.17				*
;*	Author		: H.Yajima				*
;*								*
;*********************************************************************


;*********************************************************************
;	map trigger message 
;			( WRAM map_trigmessage )
;*********************************************************************

MTGdata	macro	[flag,m0,m1,m2,color]
	dw	ymes_{flag}		; check message flag
	db	{m0},{m1},{m2}		; message 1,2,3
	db	mapmessage_{color}	; message color
	endm

;=====================================================================

tgmessage_select
  
	MTGdata	taimanE,111,0,0,enemycolor		;(0)
	MTGdata	taimanN,118,0,0,enemycolor		;(1)
	MTGdata	taimanH,134,0,0,enemycolor3		;(2)
	MTGdata	planetcannonarea,115,0,0,enemycolor2	;(3)
  	MTGdata	planetcannonfire,116,0,0,enemycolor2	;(4) ;;<---- Pri MAX
  	MTGdata	battleshipaddN,117,0,0,enemycolor	;(5)
  	MTGdata	battleshipaddH,120,0,0,enemycolor2 	;(6) 
	MTGdata	battleshiptotugeki,121,0,0,enemycolor 	;(7)
  	MTGdata	missileallfire,113,114,0,enemycolor2 	;(8)
  	MTGdata	target_last1,87,0,0,enemycolor3		;(9)
  	MTGdata	wolfappear,182,0,0,wolfcolor		;(a)
  	MTGdata	wolfdead,88,0,0,enemycolor		;(b)
  	MTGdata	sabeemfire,196,0,0,redcolor		;(c)
  	MTGdata	attacklastboss,210,211,0,blackcolor	;(d) :pepper

	dw	0  					; (endcode )

;*********************************************************************
;	map planet message 
;			( WRAM mmx_plantname )
;*********************************************************************

mapmessage_planetinfo

	db	13	;(0)  stage 1
	db	13	;(1)  stage 2
	db	13	;(2)  stage 3
	db	13	;(3)  stage 4
	db	13	;(4)  stage 5
	db	13	;(5)  stage 6
	db	13	;(6)  -------------- corneria
	db	14	;(7)  battleship
	db	195	;(8)  mothership
	db	93	;(9)  friendside
	db	94	;(10) enemyside
	db	216	;(11) itemplanet


;=====================================================================
; end end end end end end end end end end end end end end end end end
;=====================================================================





