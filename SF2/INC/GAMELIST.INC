;*********************************************************************
;*			Game Debug Switch			*
;*********************************************************************
	IFEQ	debuginfo
kportinfo	equ	0	; 0/1 ... sound port display off/on 
kdemoinfo	equ	0	; 0/1 ... polygon demo on / off
kexplain	equ	0	; 0/1 ... explain on / off
kobjsub	equ	0	; 0/1 ... obj sub switch on / off
kspeedup	equ	0	; 0/1 ... speed up off / on
kenemygone	equ	0	; 0/1 ... enemy out of range check on/off
clr_bakupram	equ	0	; backup ram clear off/on
kcannonsw	equ	0	; planet cannon enable / disable
kbattle	equ	0	; off / on
kdamage0	equ	0	; off/on :(damage0)
kennum	equ	0	; test mode kenemynumber
ktdifficulty	equ	0	; difficulty (0:easy,1:normal,2:hard)
kdebugrsbgm	equ	0	; mission result BGM Debug
kdebugresult	equ	0	; mission result debug
kendingtest	equ	0	; ending demo (easy,normal,hard) test
kendingskip	equ	0	; ending skip
kinagaki	equ	0	; debug
	ELSEIF

kportinfo	equ	0	; 0/1 ... sound port display off/on 
kdemoinfo	equ	0	; 0/1 ... polygon demo on / off
kexplain	equ	0	; 0/1 ... explain on / off
kobjsub	equ	0	; 0/1 ... obj sub switch  on / off
kspeedup	equ	1	; 0/1 ... speed up off / on
kenemygone	equ	0	; 0/1 ... enemy out of range check on/off
clr_bakupram	equ	0	; backup ram clear off/on
kcannonsw	equ	0	; planet cannon enable / disable
kbattle	equ	0	; off / on :(battlemode off)
kdamage0	equ	0	; off/on :(damage0)
kennum	equ	9	; test mode kenemynumber
ktdifficulty	equ	2	; difficulty (0:easy,1:normal,2:hard)
kdebugrsbgm	equ	0	; mission result BGM Debug
kdebugresult	equ	0	; mission result debug
kendingtest	equ	0	; ending demo (easy,normal,hard) test
kendingskip	equ	0	; ending demo skip
kinagaki	equ	0	; debug off / on
	ENDC

;*********************************************************************
;*			Demo Fade Out Time			*
;*********************************************************************
fade_titledemo		equ	8
fade_startenemydemo		equ	8
fade_startarwingdemo		equ	8
fade_corneriafelldemo	equ	15
fade_endingdemo		equ	15
fade_specialenemydemo	equ	8
fade_planetcannondemo	equ	8

;*********************************************************************
;*			BG Check				*
;*********************************************************************
bgchk_corneria	equ	0
bgchk_cannon		equ	9
bgchk_Asteroid	equ	7

;*********************************************************************
;*			HP Meter				*
;*********************************************************************
ff_hp	equ	32 ; Fox/Falco
sp_hp	equ	40 ; Slippy/Peppy
mf_hp	equ	24 ; Miyu/Fay

;*********************************************************************
;*			Score Bonus				*
;*********************************************************************
timebonus_easy	equ	100 ; Normal
timebonus_normal	equ	180 ; Hard
timebonus_hard	equ	280 ; Expert

;*********************************************************************
;*			Freeze Timer				*
;*********************************************************************
allfreezetm	equ	10	;Game Start no tokino WAIT
safetywaittm	equ	3	;map ni modotte kitatokino enemy wait time

;*********************************************************************
;*		Mission Game Clear Condition			*
;*********************************************************************
gametimemax_map	equ	999
gametimemax_mission	equ	99

;====================== Clear no tameno Kazu =========================

;**** Planet no kazu ****
planetkazu_max	equ	6
planetkazu_easy	equ	2
planetkazu_normal	equ	3
planetkazu_hard	equ	6
planetkazu_hard_1st	equ	3
planetkazu_hard_2nd	equ	planetkazu_hard-planetkazu_hard_1st

;**** Battle Ship no kazu ****
bskazu_easy		equ	2
bskazu_normal	equ	4
bskazu_hard		equ	4

;**** clear total enemy kazu ****
clrtotal_easy	equ	planetkazu_easy+bskazu_easy
clrtotal_normal	equ	planetkazu_normal+bskazu_normal
clrtotal_hard	equ	planetkazu_hard+bskazu_hard

;**** Zaco Enemy no Max Number ***
mm_missilemax	equ	6
mm_zacomax		equ	2
mm_bshipmax		equ	2
mm_specialmax	equ	2
mm_virusmax		equ	1
mm_wolfmax		equ	3
;total = 16
mm_enemymax		equ	mm_missilemax+mm_zacomax+mm_bshipmax+mm_specialmax+mm_virusmax+mm_wolfmax

;**** Syoki Zaco Syutugen !! *****
zacokazu_1st		equ	3	;1st Zaco Enemy toujyou kazu 
zacokazu_2nd		equ	2	;2nd Zaco Enemy toujyou kazu 
missiletm_1st	equ	10	;1st Missile hasyya Timer 

;**** Item Planet Appear Jyouken (amount of Pepper Medals needed on each difficulty to make the secret base appear) ****
kemedal_easy		equ	13 ; Normal
kemedal_normal	equ	19 ; Hard
kemedal_hard		equ	20 ; Expert

;********************************************************************
;*			GameTimer				*
;*********************************************************************
gmframe	equ	5			;average game frame
mapgftm	equ	60			;60 frame/sec
timescale	equ	20			;map : mission = 1:20 (kanarazu 5 no baisuu!!)
secframe	equ	60/gmframe		;12game frame/sec (60frame/sec)
missgftm	equ	secframe*timescale	;mission 1 sec timer
enstrattm	equ	timescale/gmframe	;stratage moving timer (5 game frame *2 =10 game frame ni 1 kai no syori)
decimaltm	equ	timescale*secframe/10	;0~9 made decimal sec timer

;*********************************************************************
;*			Radar Scaleing				*
;*********************************************************************
;------ Radar Character -------
YajiChr	equ	$0
EnshipChr	equ	$69
BuildChr	equ	$97
ItemChr	equ	$2d
EnemyChr	equ	$5b

;*********************************************************************
;*			Screen Clipping				*
;*********************************************************************
screen_leftedge	equ	$0c
screen_rightedge	equ	$f4
screen_topedge	equ	$10
screen_bottomedge	equ	$16*8-4

;* Cursor Appear Animation Clipping *
clip_cursorsx	equ	$08
clip_cursorex	equ	$f8
clip_cursorsy	equ	$08
clip_cursorey	equ	$f8

;*********************************************************************
;*								*
;*			Arwing Label				*
;*								*
;*********************************************************************
arwingreturnspeed	equ	32*8*8
arwingstartspeed	equ	32*8*8

;*********************************************************************
;*								*
;*			MotherShip Label			*
;*								*
;*********************************************************************
mshipcoll		equ	16		;My ship Collision Area
mshipx		equ	$02*8+4		;My Ship Center Postion X
mshipy		equ	$14*8		;My Ship Center Postion Y
mshipwarpsp		equ	10000

spr_mshipL		equ	$128		;my ship sprite  Left Chara
spr_mshipR		equ	$12A		;my ship sprite  Right Cara

recovertm		equ	8		;Arwing kaifuku timer (8 frame/sec)

;*********************************************************************
;*			Cursor					*
;*********************************************************************
init_cursorX		equ	$5*8	;mshipx+$40
init_cursorY		equ	$12*8	;mshipy

init_cursorwidth	equ	$28
cursor_shuttime	equ	16
cursor_vel		equ	((init_cursorwidth-1+0)<<8)/cursor_shuttime
cursor_colpaltm	equ	cursor_shuttime-4

cursor_plcoll	equ	8
cursor_encoll	equ	4
;*********************************************************************
;*								*
;*			Enemy Sprite Base Number		*
;*								*
;*********************************************************************
sproff_zaco1		equ	$b3
sproff_zaco2		equ	$b3
sproff_zaco3		equ	$b3
sproff_missile	equ	$b0
sproff_virus		equ	$a0
sproff_taiman	equ	$140
sproff_wolf		equ	$a3
sproff_tamedama1	equ	$1af
sproff_tamedama2	equ	$1cf
sproff_battleship	equ	$12e
sproff_warpdot	equ	$d1
sproff_satellite	equ	$c6
sproff_number	equ	$e0
sproff_bignumber	equ	$f0

sproff_spweapon	equ	$60

;*********************************************************************
;*								*
;*			Planet List Label			*
;*								*
;*********************************************************************
;**** Mother Planet Center Postion ****
corneriaX		equ	mshipx	;$4*8	;corneria center X
corneriaY		equ	mshipy	;$12*8	;corneria center Y

corneriaHP		equ	100	;Corneria Planet Hit Point
corneriaAttentionHP	equ	50	;Corneria Attention HP
corneriaDangerHP	equ	20	;Corneria Danger HP
corneriaAttentionDamage	equ	corneriaHP-corneriaAttentionHP	;Corneria Danger Damage
corneriaDangerDamage		equ	corneriaHP-corneriaDangerHP	;Corneria Danger Damage

nearplanetarea	equ	16	;Near Planet Collision Area

;* planet skill offset *
planetoff_easy	equ	4	;0~3
planetoff_normal	equ	8	;0~7
planetoff_hard	equ	13	;0~12

venomCX	equ	$19*8
venomCY	equ	$0a*8
venomDX	equ	$05*8
venomDY	equ	$12*8

taitaniaCX	equ	$04*8
taitaniaCY	equ	$04*8
taitaniaDX	equ	$02*8
taitaniaDY	equ	$0f*8

macbethCX	equ	$11*8
macbethCY	equ	$04*8
macbethDX	equ	$06*8
macbethDY	equ	$12*8

eladardCX	equ	$1c*8
eladardCY	equ	$10*8
eladardDX	equ	$07*8
eladardDY	equ	$13*8

meteorCX	equ	$10*8
meteorCY	equ	$0b*8
meteorDX	equ	$05*8
meteorDY	equ	$12*8

fortunaCX	equ	$12*8
fortunaCY	equ	$14*8
fortunaDX	equ	$08*8
fortunaDY	equ	$13*8

;**** Item Planet Skill *****
itemplanetCX		equ	$a8
itemplanetCY		equ	$30
itemplanetskill	equ	6


;*********************************************************************
;*								*
;*			Enemy Base				*
;*								*
;*********************************************************************
;---------------------------------------------------------------------
enemybaseX	equ	$ec
enemybaseY	equ	$18
;---------------------------------------------------------------------
;---------------------------------------------------------------------
planetcannonchargetm		equ	10*60
chargestep1	equ	6*10
chargestep2	equ	2*10
;---------------------------------------------------------------------
;---------------------------------------------------------------------
;*********************************************************************
;*								*
;*			BattleShip List				*
;*								*
;*********************************************************************
btship_aptm	equ	1	;Battle Ship Appear Timing
btship_apsp	equ	$1000	;Battle Ship Appear Speed
;---------------------------------------------------------------------
btship_collision	equ	8
;---------------------------------------------------------------------
bsskill_easy		equ	0 ; Normal
bsskill_normal	equ	4 ; Hard
bsskill_hard		equ	12 ; Expert
;---------------------------------------------------------------------
btship_ASX	equ	$0a*8
btship_ASY	equ	$05*8
btship_AEX	equ	$04*8
btship_AEY	equ	$10*8
cannon_ASX	equ	$06*8
cannon_ASY	equ	$0B*8
cannon_AEX	equ	$01*8
cannon_AEY	equ	$12*8

btship_BSX	equ	$18*8
btship_BSY	equ	($08-3)*8
btship_BEX	equ	$0c*8
btship_BEY	equ	($10-3)*8
cannon_BEX	equ	$04*8
cannon_BEY	equ	($16-3)*8

btship_CSX	equ	$1c*8
btship_CSY	equ	$0c*8
btship_CEX	equ	$07*8
btship_CEY	equ	$14*8
cannon_CSX	equ	$0e*8
cannon_CSY	equ	$0f*8
cannon_CEX	equ	$08*8
cannon_CEY	equ	$15*8
;---------------------------------------------------------------------
	km_labelstart
	km_label	btship_zacotype1,2
	km_label	btship_zacotype2,2
	km_label	btship_zacotype3,2
	km_label	btship_zacotype4,2
	km_label	btship_zacotype5,2
	km_label	btship_zacotype6,2
	km_label	btship_zacotype7,2
	km_label	btship_zacotype8,2
	km_label	btship_zacotype9,2
	km_label	btship_zacotype10,2
	km_label	btship_zacotype11,2
	km_label	btship_zacotype12,2
	km_label	btship_zacotype13,2

;*********************************************************************
;*								*
;*			Step Up LIST				*
;*								*
;*********************************************************************
;* Step Up Collision *
stup_collision	equ	10
;=====================================================================
;*		Step Up Appear Postion				*
;=====================================================================
;* STEP UP Params *
stepup_posx0	equ	$04*8
stepup_posy0	equ	$08*8
stepup_posx1	equ	$0c*8
stepup_posy1	equ	$08*8
stepup_posx2	equ	$14*8
stepup_posy2	equ	$08*8
stepup_posx3	equ	$1c*8
stepup_posy3	equ	$08*8

;=====================================================================
;*		Step Up Skill OFFSET				*
;=====================================================================
stupoff_easy		equ	0
stupoff_normal	equ	4
stupoff_hard		equ	4

;=====================================================================
;*			Step Up Speed				*
;=====================================================================
stup_speed1	equ	128
stup_speed2	equ	128

;=====================================================================
;*			Step Up Appear Time			*
;=====================================================================
stup_appeartmEasy	equ	30*8
stup_appeartmNormal	equ	30*8
stup_appeartmHard	equ	30*8

stup_easytmbase	equ	00*2
stup_normaltmbase	equ	06*2
stup_hardtmbase	equ	12*2

;* EASY *
stup_initappeartmE1	equ	1*8
stup_initappeartmE2	equ	2*8
stup_initappeartmE3	equ	3*8
stup_initappeartmE4	equ	4*8
stup_initappeartmE5	equ	90*8
stup_initappeartmE6	equ	120*8

;* NORMAL *
stup_initappeartmN1	equ	1*8
stup_initappeartmN2	equ	2*8
stup_initappeartmN3	equ	3*8
stup_initappeartmN4	equ	60*8
stup_initappeartmN5	equ	90*8
stup_initappeartmN6	equ	120*8

;* HARD *
stup_initappeartmH1	equ	1*8
stup_initappeartmH2	equ	2*8
stup_initappeartmH3	equ	3*8
stup_initappeartmH4	equ	60*8
stup_initappeartmH5	equ	90*8
stup_initappeartmH6	equ	120*8


;*********************************************************************
;*								*
;*			SOS LIST				*
;*								*
;*********************************************************************
sos_demoappeartm	equ	3*8
sos_plsearchcoll	equ	$30

zaco_collision	equ	8
mis_collision	equ	6

;=====================================================================
;*		SOS Destination Postion				*
;=====================================================================
endestposAX		equ	$03*8
endestposAY		equ	$14*8
endestvelAX		equ	$3000
endestvelAY		equ	$4000

endestposBX		equ	$05*8
endestposBY		equ	$15*8
endestvelBX		equ	-$1000
endestvelBY		equ	$3000

endestposCX		equ	$06*8
endestposCY		equ	$16*8
endestvelCX		equ	-$3000
endestvelCY		equ	$3000

endestposDX		equ	$07*8
endestposDY		equ	$17*8
endestvelDX		equ	-$4000
endestvelDY		equ	-$2000

;=====================================================================
;*		SOS Skill OFFSET				*
;=====================================================================
sosoff_easy		equ	$00
sosoff_normal	equ	$06	;08
sosoff_hard		equ	$0c	;10

misoff_easy		equ	$0	;not use
misoff_normal	equ	$0	;not use
misoff_hard		equ	$0	;not use

;=====================================================================
;*			SOS Speed				*
;=====================================================================
arwingspeed			equ	600	;arwing speed
btship_speed			equ	25	;senkan speed
sos_specialsp		equ	500	;taiman speed
sos_virussp			equ	400	;virus speed
sos_wolfsp			equ	550	;wolf speed

sos_zacosp1_easy		equ	150	;80*2
sos_zacosp2_easy		equ	200	;180*2
sos_zacosp3_easy		equ	250	;300*2
sos_missilesp_easy		equ	300	;230*2

sos_zacosp1_normal		equ	170	;80*2
sos_zacosp2_normal		equ	200	;180*2
sos_zacosp3_normal		equ	250	;130*2
sos_missilesp_normal		equ	320	;230*2

sos_zacosp1_hard		equ	220	;80*2
sos_zacosp2_hard		equ	250	;180*2
sos_zacosp3_hard		equ	300	;130*2
sos_missilesp_hard		equ	360	;230*2

;---------------------------------------------------------------------
sos_appearspeed	equ	256/8
sos_aroundspeed	equ	128*8
;---------------------------------------------------------------------
;=====================================================================
;*			Satellite 				*
;=====================================================================
satellitecx		equ	$0a*8
satellitecy		equ	$0e*8

sa_chargeanmtm	equ	5*60

sa_tameinittmE	equ	20*60
sa_tameinittmN	equ	20*60
sa_tameinittmH	equ	20*60

sa_tametimeE		equ	25*60
sa_tametimeN		equ	23*60
sa_tametimeH		equ	20*60

sa_angletm		equ	1*60
sa_lockontm		equ	16	;16 frame ni 1 kai enemy lock ON Check wo Suru !!
sa_lockonang		equ	11	;enemy lock on check angle length (-11 ~ 11) 
sa_lockonang_co	equ	8	;corneria lockon check length (-8 ~ 8)

sa_skill		equ	8

sa_beemvel		equ	$2000
sa_beemcoll		equ	12

;=====================================================================
;*			WolfTeam 				*
;=====================================================================
wolf_planetcollision	equ	10
wolf_appearcollision	equ	2
wolf_freecollision	equ	8

wolf_teamskill	equ	10
wolf_bossskill	equ	11

;=====================================================================
;*			Virus	 				*
;=====================================================================
vir_appeartmN	equ	32*60
vir_appeartmH	equ	24*60
vir_collision	equ	6
;=====================================================================
;*			SpecialEnemy 		[taimankun]	*
;=====================================================================
sp_easykazu		equ	1 ; Normal
sp_normalkazu	equ	1 ; Hard
sp_hardkazu		equ	2 ; Expert
sp_skillbase		equ	$1c
taiman_collision	equ	8
;=====================================================================
;*			SOS Zaco Appear Time			*
;=====================================================================
;(zaco no shyutugen kankaku)
sos_zacotmE	equ	12*60	;easy
sos_zacotmN	equ	18*60	;normal
sos_zacotmH	equ	15*60	;hard

;=====================================================================
;*			Missile Appear Time			*
;=====================================================================
sos_easytmbase	equ	00 ; Normal
sos_normaltmbase	equ	06 ; Hard
sos_hardtmbase	equ	12 ; Expert
;---------------------------------------------------------------------
sos_stg1tmE	equ	20*60	;18
sos_stg2tmE	equ	32*60	;30
sos_stg3tmE	equ	27*60	;25
sos_stg4tmE	equ	24*60	;22
sos_stg5tmE	equ	34*60	;32
sos_stg6tmE	equ	37*60	;35
sos_shiptmE	equ	82*60	;80
;-------------------------------------------------------------------
sos_stg1tmN	equ	22*60	;16
sos_stg2tmN	equ	32*60	;28
sos_stg3tmN	equ	26*60	;22
sos_stg4tmN	equ	24*60	;20
sos_stg5tmN	equ	32*60	;30
sos_stg6tmN	equ	35*60	;32
sos_shiptmN	equ	82*60	;80
;-------------------------------------------------------------------
sos_stg1tmH	equ	20*60	;15
sos_stg2tmH	equ	29*60	;25
sos_stg3tmH	equ	24*60	;20
sos_stg4tmH	equ	22*60	;18
sos_stg5tmH	equ	32*60	;28
sos_stg6tmH	equ	34*60	;30
sos_shiptmH	equ	82*60	;80
;-------------------------------------------------------------------
sos_intstg1tm	equ	18*60
sos_intstg2tm	equ	22*60
sos_intstg3tm	equ	25*60
sos_intstg4tm	equ	20*60
sos_intstg5tm	equ	26*60
sos_intstg6tm	equ	28*60
sos_intshiptm	equ	04*60
;-------------------------------------------------------------------
;=====================================================================
;*		SOS Attack Corneria Time & Attack Point		*
;=====================================================================
sos_zacoattm		equ	1
sos_misattm		equ	1
sos_shipattm		equ	1
sos_stupattm		equ	1
sos_guardattm	equ	2
;-------------------------------------------------------------------
sos_zacoatpo		equ	2
sos_misatpo		equ	5
sos_shipatpo		equ	2
sos_taimanatpo	equ	5
planetcannonAp	equ	50	;Planet cannon Attack Point
sa_atpo		equ	20	;satellite attack point
