ashiofsx_FF		equ	15	;17
ashiofsx_SP		equ	20
ashiofsx_GG		equ	15

robotyofstab_FF	equ	35	; body offset y
robotyofstab_SP	equ	30
robotyofstab_GG	equ	40

playerHP	equ	40
playerAP	equ	0	;2

ROBOTleg_HP	equ	100
ROBOTleg_AP	equ	1

enterbossx	equ	0
enterbossz	equ	7fffH	;25000	;3fffH
enterbossy	equ	-3058

enterofsx	equ	200
enterofsz	equ	200
enterendy	equ	-500

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³palyer ga damage wo uketa tokino muteki jikan³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

plnohitfrm		equ	10
plscrflashfrm	equ	8	;4
plnohitfrm_s		equ	4
plscrflashfrm_s	equ	2

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

magmadmgint	equ	20

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	WEAPON STATUS
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;player's special weapon

;flamethrowHP		equ	255
;flamethrowAP		equ	2
;flamethrowVEL	equ	30
;flamethrowLIF	equ	7

PmissileHP		equ	1
PmissileAP		equ	4
PmissileVEL		equ	50
PmissileLIF		equ	80

spreadHP		equ	120		;255
spreadAP		equ	4
spreadVEL		equ	60
spreadLIF		equ	100

reboundHP		equ	120		;255
reboundAP		equ	2
reboundLIF		equ	10
reboundVEL		equ	60

dummyHP		equ	1
dummyAP		equ	16
dummyLIF		equ	127
dummyVEL		equ	8

;----------------------------------------------------------------------------------------------

healitem_addHP	equ	16

;---------------------------------------------------------------------------
; child number list

childno_legLR	equ	100
childno_armerjetL	equ	10
childno_armerjetR	equ	11
childno_boost	equ	12
childno_brakeL	equ	13
childno_brakeR	equ	14
childno_bubble	equ	15
childno_splash	equ	16
childno_hamon	equ	17
childno_barrier	equ	18
childno_overheat	equ	19
childno_gottun	equ	20
childno_shadow	equ	21
childno_heal		equ	22
;;;childno_healparts	equ	23
childno_healeffect	equ	24
childno_spread	equ	25
childno_missile	equ	26
childno_dummy	equ	28
childno_particle	equ	29
childno_smoke	equ	30
childno_clrdemo	equ	31
childno_clrdemo1	equ	32
childno_youwin	equ	33
childno_youlost	equ	34
childno_Plaser	equ	35
childno_gunblaze	equ	36
childno_flame	equ	37
childno_bomeffect	equ	38
childno_tametame	equ	39
childno_last_ka	equ	40
childno_healparts_l	equ	41
childno_healparts_r	equ	42

;----------------------------------------------------------------------------------------------
; powerd laser

PpowerdlaserHP		equ	120		;255
PpowerdlaserAP		equ	10
PpowerdlaserVEL		equ	255>>1
PpowerdlaserVEL_space	equ	255>>1
PpowerdlaserLIF		equ	40	;23
PpowerdlaserLIF_space	equ	40	;23

; player's normal weapon

Plaser1HP		equ	120			;255
Plaser1AP		equ	1
Plaser1VEL		equ	124>>1
Plaser1VEL_space	equ	124>>1
Plaser1LIF		equ	23
Plaser1LIF_space	equ	23
Plaser1twinAP	equ	2
Plaser1twintwinAP	equ	4

Pplasma1HP			equ	120		;255
Pplasma1AP			equ	2
Pplasma1VEL			equ	120>>1
Pplasma1VEL_space		equ	120>>1
Pplasma1LIF			equ	23	; mission mode
Pplasma1LIF_s		equ	20	; battle mode
Pplasma1LIF_space		equ	23	; mission mode
Pplasma1LIF_s_space		equ	20	; battle mode

Pplasma1twinAP	equ	4
Pplasma1twintwinAP	equ	4
;----------------------------------------------------------------------------------------------
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; enemy's weapons

HomEmissileHP	equ	1
HomEmissileAP	equ	6
HomEmissileVEL	equ	20+20
HomEmissileLIF	equ	120

;----------------------------------------------------------------------------------------------

Eplasma1HP		equ	1
Eplasma1AP		equ	4
Eplasma1LIF		equ	110
;---
EPlasma1spmostfarVEL	equ	45
EPlasma1spfarVEL	equ	41
EPlasma1spmidVEL	equ	38
EPlasma1spnearVEL	equ	35
EPlasma1splastVEL	equ	25
EPlasma1grVEL	equ	30
;---

;Eplasma1VEL		equ	30
Eplasma1VELaw	equ	40
Eplasma1VELrb	equ	60

RelEplasma1HP	equ	10
RelEplasma1AP	equ	4
RelEplasma1LIF	equ	40
RelEplasma1VEL	equ	80

;----------------------------------------------------------------------------------------------

ElaserHP		equ	10
;ElaserAP		equ	2
;;;---
ElaserLIF		equ	45
ElaserspLIF		equ	60
ElasersplastVEL	equ	30
Elaserspmovein	equ	100
ElaserVEL		equ	30
;;;---
ElaserVELaw		equ	40
ElaserVELrb		equ	70

RelElaserHP		equ	10
RelElaserAP		equ	2
RelElaserLIF		equ	33
RelElaserVEL		equ	90

Elaserzofs		equ	35

RelElaserhspVEL	equ	150>>1

;----------------------------------------------------------------------------------------------

FlaserHP		equ	1
FlaserAP		equ	2
FlaserLIF		equ	20
FlaserVEL		equ	120

;----------------------------------------------------------------------------------------------



EringHP		equ	120		;255
EringAP		equ	4
EringLIF		equ	50
;EringVEL		equ	10
ERingroomVel		equ	20
ERingroomLIF		equ	50
EringVELaw		equ	40
EringVELrb		equ	60

RelEringHP		equ	120		;255
RelEringAP		equ	1
RelEringLIF		equ	40
RelEringVEL		equ	80
Eringlocktime	equ	80

;----------------------------------------------------------------------------------------------
Eweap_size		equ	5
;----------------------------------------------------------------------------------------------
bombtimer		equ	12
