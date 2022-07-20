;=====================================================================
;*								*
;*			SOUND Parameter		1995. 8. 9	*
;*								*
;=====================================================================
;========= tensou ===========
sndpl2addr		equ	$0c	;player 2 no sound data wo okuru baai ni hituyou

;========= port 0 =========
;*** FLAGS ***
ksf_nodata		equ	0

;* player mode *
ksf_plmode		equ	1<<7	;0/1 .. player1 / PLayer2

;* angle & distance *
ksf_nearC		equ	%00000000
ksf_nearL		equ	%00010000
ksf_nearR		equ	%00100000
ksf_midC		equ	%00110000
ksf_midL		equ	%01000000
ksf_midR		equ	%01010000
ksf_far			equ	%01100000

;* mission or battle *
;ksf_mission		equ	0
;ksf_battle		equ	1<<7

;* place flag *
ksf_baseplace		equ	$f9

ksf_space		equ	0<<4
ksf_room		equ	1<<4
ksf_ground		equ	2<<4
ksf_sea			equ	3<<4

;--- BGM Start ---	
kbgm_map1		equ	$01
kbgm_stg1		equ	$01
kbgm_continue		equ	$01
kbgm_heaven		equ	$01
kbgm_escape		equ	$01
kbgm_easy_ending	equ	$01
kbgm_result_over	equ	$01
kbgm_result		equ	$01
kbgm_end_theme		equ	$01

kbgm_hassha		equ	$02
kbgm_map2		equ	$02
kbgm_stg2		equ	$02
kbgm_gmover		equ	$02
kbgm_hell		equ	$02
kbgm_attention		equ	$02
kbgm_androf_tunnel	equ	$02
kbgm_all_clear		equ	$02
kbgm_end_jan_0		equ	$02

kbgm_map3		equ	$03
kbgm_danger		equ	$03
kbgm_androf_fight	equ	$03
kbgm_boss		equ	$03
kbgm_demo		equ	$03
kbgm_result_clear	equ	$03
kbgm_hard_ending	equ	$03
kbgm_end_jan_1		equ	$03
kbgm_result_fan_E	equ	$03

kbgm_demo2		equ	$04
kbgm_pldown		equ	$04
kbgm_result_perfect	equ	$04
kbgm_result_fan_D	equ	$04

kbgm_tprologue		equ	$05
kbgm_ememy_gone		equ	$05
kbgm_androf_base	equ	$05
kbgm_map_explain	equ	$05
kbgm_result_fan_C	equ	$05

kbgm_stgclr		equ	$06
kbgm_stepclr		equ	$06
kbgm_result_fan_B	equ	$06

kbgm_boss_prologue	equ	$07
kbgm_result_fan_A	equ	$07

kbgm_corneria100	equ	$08
kbgm_starfox1		equ	$08
kbgm_last_wolf		equ	$08
kbgm_result_fan_S	equ	$08

kbgm_Fast_FadeOut	equ	$09
kbgm_FadeOut		equ	$0a
kbgm_MuteOn		equ	$0b
kbgm_MuteOff		equ	$0c
kbgm_TempoFast		equ	$0d
;kbgm_TempoSlow		equ	$0e
kbgm_Stop		equ	$0e	;$09
kbgm_SoundTrans		equ	$0f
			
;========= port1 ==========
sport1_stop		equ	0
sport1_eng		equ	4
sport1_boost		equ	8

;========= port2 ==========
sport2_sonear		equ	0<<4	;%00000000
sport2_near		equ	1<<4	;%00010000
sport2_far		equ	2<<4	;%00100000
sport2_sofar		equ	3<<4	;%00110000

sport2_stop		equ	0
sport2_0pos		equ	0<6	;%00000000
sport2_left		equ	1<<6	;%01000000
sport2_center		equ	2<<6	;%10000000
sport2_right		equ	3<<6	;%11000000

;========= strat address replace ==========
playchar_start		equ	$02e60
partchar_start		equ	$02ee0

;========= map BGM damage check ==========
mapbgm_border1		equ	050
mapbgm_border2		equ	080	;090

