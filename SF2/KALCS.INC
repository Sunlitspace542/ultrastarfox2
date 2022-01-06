;*********************************************************************
;*								*
;*								*
;*		Kawaguchi using Work RAM area			*
;*								*
;*								*
;*********************************************************************

;=====================================================================
;*		Memory Alloc Start				*
;=====================================================================
	alc	kw_start,0
	xalc	kx_start,0

;=====================================================================
;*		Free Memory (For Kawaguchi)			*
;=====================================================================
	alc	kawaguchi1,16

;=====================================================================
;*			DEBUG WORK				*
;*7ffff0~7fffff:BUG check WORK					*
;=====================================================================
kbugwork	equ	$7ffff0
kbugbreak	equ	$7ffffe

	alc	checkirq,2
	alc	checkirq1,2
	alc	checkirq2,2
	alc	checkirq3,2
	alc	kprint,2

;=====================================================================
;*								*
;*		GAME Sequence Work				*
;*								*
;=====================================================================
;--- game sequence ----
	alc	Kw_GameMode,2		;GAME zentai no SEQUENCE Pointer
	alc	kw_TmpGameMode,2	;Game SEQUENCE KARI no RAM
	alc	kw_setbgsaddr,2		;BG    mode address
	alc	kw_setsndaddr,2		;SOUND mode address
;---------------------------------------------------------------------
;* sequence number *
; kmode_{addr}	equ	num
;---------------------------------------------------------------------
	km_gamemodelist
;* Polygon Screen *
	km_gameptr	title			;
	km_gameptr	initmission		;
	km_gameptr	missionexplain		;
	km_gameptr	playerdown		;
	km_gameptr	demo			;
	km_gameptr	training		;

;* No Polygon Screen *
	km_gameptr	selectmissionplayer	;
	km_gameptr	selectmissionmap	;
	km_gameptr	missionresult		;
	km_gameptr	hiscoreinput		;
	km_gameptr	record			;
	km_gameptr	detail			;

;*** TEST ***
	km_gameptr	debugmissionmap		;
	km_gameptr	testmissionmap		;
	km_gameptr	testplanetstep		;
	km_gameptr	config			;
;*** END ***
	km_gameptr	end			;


;--- game syori ----
	alc	kw_GameSyori,2		;Game Syori no SEQUENCE Pointer
	alc	kw_TmpGameSyori,2	;Game Syori no NEXT SEQUENCE Pointer

	km_labelstart
	km_label	kgamef_rts	;0... rts
	km_label	kgamef_main	;1... main
	km_label	kgamef_pause	;2... pause
	km_label	kgamef_bgmtrans	;3... BGM Totyuu tensou!!

;---- Game Mission Map Syori ----
	alc	kw_MisMapSyori,2
	km_gmlabelstart	mmsy,0
	km_gmlabel	normal		;Normal Syori
	km_gmlabel	explainfinish	;Mission Map Explain Finsh (1 kai dake)
	km_gmlabel	missionstart	;Mission Start (Planet or Battleship ,Encount Enemy)
	km_gmlabel	corneriafell	;Corneria Fell
	km_gmlabel	specialenemy	;Taiman Demo Jump
	km_gmlabel	planetcannon	;Planet Canon Demo Jump

;--- demo number ---
	alc	kw_DemoNumber,2		;Game Demo Number
	km_gmlabelstart	kdemo,0
	km_gmlabel	nothing,4		;0 :$00
	km_gmlabel	titledemo,4		;1 :$04
	km_gmlabel	startenemydemo,4	;2 :$08
	km_gmlabel	entermshipdemo,4	;3 :$0c
	km_gmlabel	startarwingdemo,4	;4 :$10
	km_gmlabel	corneriafelldemo,4	;5 :$14
	km_gmlabel	gamecleardemo,4		;6 :$18
	km_gmlabel	endingdemo,4		;7 :$1c
	km_gmlabel	specialendemo,4		;8 :$20
	km_gmlabel	dummy2demo,4		;9 :$24
	km_gmlabel	planetcannondemo,4	;10:$28

;---- 3D battle ----
	alc	kw_MissionSyori,2
	km_gmlabelstart	msy,0	;(intro.asm)
	km_gmlabel	normal
	km_gmlabel	wait
	km_gmlabel	playerdown
	km_gmlabel	corneriafell
	km_gmlabel	stageclear
	km_gmlabel	gameclear
	km_gmlabel	enemyrunawaytrig
	km_gmlabel	enemyrunaway

	alc	kw_nextmissionsyori,2
	alc	kw_miswaittm,2
	alc	kw_charttm,2

;---- Battle Mode ----
	alc	kw_BattleSyori,2
	km_gmlabelstart	bsy,0	;(intro.asm)
	km_gmlabel	normal,2
	km_gmlabel	timeup,2
	km_gmlabel	timeupwait,2
	km_gmlabel	result,2
	km_gmlabel	resultwait,2
	km_gmlabel	continue,2

;=====================================================================
;*								*
;*			GAME Flag Work				*
;*								*
;=====================================================================
;---- Total Flag ----
	alc	kw_TotalFlag,2
ktof_all	equ	-1
	defflaglist	ktof	;ktof_{flag}
	defflag	battle		;0/1 ... mission/battle
	defflag	yjscore		;0/1 ... record / hiscore input

;---- GAME Flag ----
	alc	kw_GameFlag,2
kgf_all	equ	-1
	defflaglist	kgf	;kgf_{pointer}

	defflag	battle		;0/1 ... mission mode / battle mode
	defflag	freeze		;0/1 ... freeze strategies for demo.
	defflag	kawairq		;0/1 ... normal irq / kawaguchi irq
	defflag	test		;0/1 ... normal mode /test mode

	defflag	keydisable	;0/1 ... key enable / key disable
	defflag	pausedisable	;0/1 ... enable / disable
ef_pausedisable	equ	fbit	;(eguchi's set suru)
	defflag	pauseon		;0/1 ... OFF /ON
	defflag	debug		;0/1 ... syori meter OFF/ON

	defflag	areaout		;0/1 ... area out nashi / area out ari
	defflag	fade1		;0/1 ... no fade / fade in
	defflag	plreset		;0/1 ... no reset / player states reset (for kawagoe)
	defflag	lookresult	;0/1 ... nothing look result

;=====================================================================
;*								*
;*			Mission Map Flag			*
;*								*
;=====================================================================
;---- Mission Total Flag ----
	alc	kw_MisTotalFlag,2
kmtof_all	equ	-1
	defflaglist	kmtof	;ktof_{flag}

	defflag	retry		;0/1 ... reset random planet  / retry map (fix map)
	defflag	partner1	;0/1 ... nothing / partner continue
	defflag	playerdown	;0/1 ... nothing / player down
	defflag	corneriafell	;0/1 ... nothing / destruction corneria

	defflag	mission		;0/1 ... map game / mission game
	defflag	finalbossbattle	;0/1 ... nothing / final boss appear
	defflag	initialmap	;0/1 ... need initial / nothing
	defflag	explain1	;0/1 ... explain finish / not yet

	defflag	missile_1st	;0/1 ... 1 ban saisyo ni utu missile
	defflag	bonus		;0/1 ... bonus nashi / ari
	defflag	bshojyuu	;0/1 ... senkan hojyuu nothing / shita
	defflag	bstotugeki	;0/1 ... senkan totugeki nothing / shita

	defflag	plhojyuu	;0/1 ... planet hojyuu nothing / shita
	defflag	gameend		;0/1 ... nothing / game end

;	defflag	p1dead		;0/1 ... alive / dead [player 1]
;	defflag	p2dead		;0/1 ... alive / dead [player 2]
;--- Game Mission Map Flag ---
	alc	kw_MisMapFlag,2
kmimpf_all	equ	-1
	defflaglist	kmimpf		;kmimpf_{pointer}

	defflag		autoradar	;0/1 ... fix scale radar / auto scale radar
	defflag		missionresult	;0/1 ... fail/success (intro.asm)
	defflag		enemylist	;0/1 ... planet list /enemy list
	defflag		battleship	;0/1 ... planet  / battleship

	defflag		returnmap	;0/1 ... nothing / return map from mission
	defflag		battleplayer	;0/1 ... nothing / Player battle tyuu
	defflag		playernocoll	;0/1 ... nothing / Player No Collision
	defflag		cannonstart	;0/1 ... nothing / planet cannon fire

	defflag		corneriafell	;0/1 ... normal / corneria fell
	defflag		missilefell	;0/1 ... nothing / missile fell in corneria
ef_missilefell	equ	fbit	;(eguchi's set suru)
	defflag		finalboss	;0/1 ... nothing / final boss appear
	defflag		spenappear	;0/1 ... nothing / special enemy appear

	defflag		attackcorneria	;0/1 ... nothing / attack corneria tyuu
	defflag		asteroid	;0/1 ... nothing / asteroid
	defflag		enemygone	;0/1 ... player exit / enemy has gone
	defflag		expcancel	;0/1 ... normal / explain totyuu cancel

	alc	kw_MisMapFlag2,2
kmimpf2_all	equ	-1
	defflaglist	kmimpf2		;kmimpf2_{pointer}

	defflag		debugenable	 ;0/1 ... disable / enable
	defflag		planetcannondemo ;0/1 ... demo off/on
	defflag		returnmother	 ;0/1 ... nothing / return corneria
	defflag		warpwait	 ;0/1 ... finish / warp tyuu (mother ship warp no animation ga syuuryou shitaka douka check)

	defflag		rannyuenable     ;0/1 ... disable / enable
	defflag		rannyutrig	 ;0/1 ... nothing / rannyu ari

	defflag		wolffreecurrent	 ;0/1 ... ima free no wolf ga inai/iru
	defflag		wolfboss	 ;0/1 ... wolf boss inai/iru

	defflag		itemplanet	 ;0/1 ... nashi /ari
	defflag		damagedisable	 ;0/1 ... corneria damage add enable / disable

	alc	kw_MisMapFreezeFlag,2
	alc	kw_MisMapFreezeFlagBak,2
kfz_all	equ	-1
	defflaglist	kfz
;* all clear OK !! *
	defflag		timefreeze	;0/1 ... continue / pause
	defflag		enemyfreeze	;0/1 ... nothing / enemy stratage stop
	defflag		playerfreeze	;0/1 ... nothing / player stratage stop
	defflag		cursorfreeze	;0/1 ... nothing / cursor freeze

	defflag		ketteifreeze	;0/1 ... nothing / kettei button freeze
	defflag		pausefreeze	;0/1 ... nothing / pause cancell
	defflag		expcancelfreeze ;0/1 ... explain cancel check enable / disable

kfz_normalfreeze	equ	kfz_timefreeze!kfz_enemyfreeze!kfz_playerfreeze!kfz_cursorfreeze!kfz_ketteifreeze
kfz_gamefreeze	equ	kfz_normalfreeze!kfz_pausefreeze

;* moshi encount enemy or arrive planet no toki *
kfz_battlefreeze	equ	kfz_playerfreeze!kfz_enemyfreeze!kfz_cursorfreeze!kfz_ketteifreeze

	alc	kw_MisMapEventFlag,2
kev_all	equ	-1
	defflaglist	kev
;* sequence ga kawattemo clear shinai !! *
	defflag		btshipfreeze	;0/1 ... nothing / battle ship sequence freeze
	defflag		sosfreeze	;0/1 ... nothing / sos enemy (zaco,missile) sequence freeze
	defflag		bossfreeze	;0/1 ... nothing / boss freeze
	defflag		misbornfreeze	;0/1 ... nothing / missile born freeze

	defflag		sosbornfreeze	;0/1 ... nothing / zaco born freeze 
	defflag		virusbornfreeze	;0/1 ... nothing / virus born freeze

;--- Game Mission Map States Flag ---
;Game Sequence ga kawattara Flag wo All Clear suru
	alc	kw_MisMapStateFlag,2
kmimpstf_all	equ	-1
	defflaglist	kmimpstf

	defflag		replay		;0/1 ... nothing / time count up demo (mission finish)
	defflag		hourpast	;0/1 ... 1 hour past
	defflag		finishtrans	;0/1 ... tranfer finish bitmap data
	defflag		speedup		;0/1 ... normal /speed up

	defflag		message		;0/1 ... message display OFF/ON
	defflag		gmframesyori	;0/1 ... syori shinai / do game syori
	defflag		noirqsyori	;0/1 ... irq syori OK /noirq
	defflag		bg1scrtrans	;0/1 ... nothing / screen transfer

	defflag		finalbosstrig	;0/1 ... nothing / final boss appear
	defflag		irqfinish	;0/1 ... finish irq syori / irq wait
	defflag		arwingspup	;0/1 ... nothing / arwing speed up
	defflag		wolfgone	;0/1 ... nothing / wolf team had gone

	defflag		corneriaexplode	;0/1 ... nothing / corneria explode (for planet cannon)
	defflag		corneriadamage	;0/1 ... nothing / corneria damage
	defflag		nokori1		;0/1 ... (planet + senkan) = 1
	defflag		wolfbossdead	;0/1 ... wolf boss arrive / dead

;	defflag		expdemostart	;0/1 ... wait / explain demo start trigger

	xalc	kx_MisMapTrigFlag,2
ktrf_all	equ	-1
	defflaglist	ktrf

	defflag		timechartstop	;0/1 ... event enabel(mission success shitara flag clear !!) / event stop (mission clear ji igai ni event ga okitara flag on)
	defflag		eventdisable	;0/1 ... event enable(mission success shitara flag clear !!) / disable (mission kara map ni modottekiteeventchart ga owattara set)
	defflag		enemytotal0	;0/1 ... nothing / enemy toal =0 notoki event ga kitara kyouseitekini event wo okosu !!
	defflag		mapgameenable	;0/1 ... return map demo tyuu / map game tyuu

	defflag		missileall	;0/1 ...
	defflag		bstotugeki	;0/1 ...
	defflag		bshojyuu	;0/1 ...
	defflag		specialenemy	;0/1 ...

	defflag		wolffree	;0/1 ...
	defflag		planethojyuu 	;0/1 ... kono bit wa missile all se clear
	defflag		misallcancel	;0/1 ...

ktrf_forceevent	equ	ktrf_enemytotal0!ktrf_mapgameenable

	xalc	kx_MisMapChartFlag,2
kchf_all	equ	-1
	defflaglist	kchf
	defflag		tmchartenable	;0/1 ... disable / enable
	defflag		tmchartwait	;0/1 ... nothing / time chart wait

	defflag		pcchartenable	;0/1 ... disable / planetcannon demo enable
	defflag		pcdemowait	;0/1 ... nothing / planetcannon demo start

	defflag		fbchartenable	;0/1 ... finalboss chart disable /enable
	defflag		fbdemowait	;0/1 ... nothing / final boss demo start

	defflag		tgchartenable	;0/1 ... battleship totugeki chart disable / enable
	defflag		tgdemowait	;0/1 ... nothing / battle ship totugeki demo start

	defflag		mschartenable	;0/1 ... missile all fire chart disable / enable
	defflag		msdemowait	;0/1 ... nothing / missile all fire demo start

	defflag		sachartenable	;0/1 ... satellite beem fire chart disable / enable
	defflag		sademowait	;0/1 ... nothing / satellite beem demo start


kchf_allenable	equ	kchf_tmchartenable!kchf_pcchartenable!kchf_fbchartenable!kchf_tgchartenable!kchf_mschartenable!kchf_sachartenable
kchf_mainenable	equ	kchf_tmchartenable!kchf_pcchartenable!kchf_fbchartenable!kchf_sachartenable!kchf_mschartenable

;--- Mission Map Demo Flag ----
	alc	kw_MisMapDemoFlag,2
kmdmf_all	equ	-1
	defflaglist	kmdmf	;kmdmf_{flag}

	defflag		missilefelldemo
	defflag		missilealldemo
	defflag		battleshiphojyuudemo
	defflag		battleshiptotugekidemo

	defflag		satellitebeemdemo
	defflag		specialenemydemo
	defflag		wolfbossdemo
	defflag		planethojyuudemo

	defflag		warpdemo
	defflag		partnerchange

	xalc	kx_MisMapDemoNumber,2
	km_gmlabelstart	kdemo,0
	km_gmlabel	nothingdemo,2
	km_gmlabel	missilefelldemo,2
	km_gmlabel	missilealldemo,2
	km_gmlabel	battleshiphojyuudemo,2
	km_gmlabel	satellitebeemdemo,2
	km_gmlabel	specialenemydemo,2
	km_gmlabel	wolfbossdemo,2

;--- Game Mission Flag ---
	alc	kw_MissionFlag,2
kmif_all	equ	-1
	defflaglist	kmif	;kmif_{flag}

	defflag	ringout		;0/1 ... IN/OUT
	defflag	explain		;0/1 ... nothing/do game explain
	defflag	parallel	;0/1 ... not moving / parallel moving (map enemy strat moving)
	defflag	enemymove	;0/1 ... Game tyuu wa 2 Game Flame ni 1 kai Parallel suru

	defflag	godemofinish	;0/1 ... Game Over Demo Finish Switch
	defflag	keycheckenable	;0/1 ... keycheck disable / enable
	defflag	spriteoff	;0/1 ... nothing / spriteoff (demo)
	defflag	finalboss	;0/1 ... Fianl Boss Flag

	defflag	enemyrunaway	;0/1 ... nothing / enemy run away
	defflag	noenemy		;0/1 ... nothing / no enemy
	defflag	spriteswap	;0/1 ... normal sprite / sprite CGX transfer
	defflag	transsprcgx	;0/1 ... Transfer Stage Clear Sprite

	defflag	pause		;0/1 ... OFF/ON
	defflag	wolfboss	;0/1 ... nothing / wolf boss
	defflag	enemygonefreeze	;0/1 ... nothing / enemy run away
	defflag	timemax		;0/1 ... nothing / timer max (99.9)

;--- Game Battle Flag ---
	alc	kw_BattleFlag,2
kbtf_all	equ	-1
	defflaglist	kbtf	;kbtf_{pointer}
	defflag	timeup		;0/1 ... do game/time up
	defflag	gameover	;0/1 ... Game do /Game Over
	defflag	p1dead		;0/1 ... alive/dead
	defflag	p2dead		;0/1 ... alive/dead
	defflag	p1pause		;0/1 ... OFF/ON
	defflag	p2pause		;0/1 ... OFF/ON
;;;	defflag	p1ringout	;0/1 ... IN/OUT
;;;	defflag	p2ringout	;0/1 ... IN/OUT
kbtf_p12pauseflag	equ	kbtf_p1pause!kbtf_p2pause

;--- Game Over Flag ---
	alc	kw_GameOverFlag,2
kgof_all	equ	-1
	defflaglist	kgof	;kgof_{pointer}
	defflag	player		;0/1 ... player 1/player 2

;---------------------------------------------------------------------
;*			GAME SCREEN Flags			*
;---------------------------------------------------------------------
	alc	kw_screenflag,2		;screen mode switch
kscf_all	equ	-1
	defflaglist	kscf	; current screen mode

	defflag	oamtensou	;0/1 ... buf1 trans(buf2 write) / buf2 trans (buf1 write)
	defflag	sprwbuf		;0/1 ... single buffer / double buffer
	defflag	screenadd	;0/1 ... no screen add  / screen add
	defflag	halfadd		;0/1 ... normal add / halfadd

	defflag	screentrans	;0/1 ... nothing / screen data dma transfer (IRQ)
	defflag	tutumode	;0/1 ... room mode / tutu mode
	defflag	noset_col	;0/1 ... set_bg de colour tensou suru/shinai
	defflag	objcolpal	;0/1 ... no change / obj colpal change

	defflag	colpaltrans	;0/1 ... colour palette dma trans OFF/ON
	defflag	bgcolpal	;0/1 ... no change / bg colpal change
	defflag	bgcolpal3	;0/1 ... no change / bg colpal change
	defflag	bgcolpal4	;0/1 ... no change / bg colpal change

	defflag	yjchartrans	;0/1 ... no trans / yajima's character transfer enable
	defflag	damagetrig	;0/1 ... corneria damage OFF / ON
;---------------------------------------------------------------------------
	alc	kw_spritemode,2
	alc	kw_spritetmpmode,2
	km_spriteptrlist	ksprf		; current screen mode
	km_spriteptr	nosprite
	km_spriteptr	title
	km_spriteptr	mismap
	km_spriteptr	explain
	km_spriteptr	mission
	km_spriteptr	selectmissionplayer
	km_spriteptr	missionpause
	km_spriteptr	missiongameover
	km_spriteptr	missionresult
	km_spriteptr	record
	km_spriteptr	hiscoreinput
	km_spriteptr	missioncontinue

	km_spriteptr	battle
	km_spriteptr 	selectbattlefield
	km_spriteptr	selectbattleplayer
	km_spriteptr	battlepause
	km_spriteptr	typesel
;---------------------------------------------------------------------------
	alc	kw_screenmode,1
	km_screenptrlist	kscmf		; current screen mode
	km_screenptr	noscreen
	km_screenptr	title
	km_screenptr	mission
	km_screenptr	battle
	km_screenptr	explain
	km_screenptr	mismap
	km_screenptr	missiongameover
	km_screenptr	missioncontinue
	km_screenptr	missionresult

;=====================================================================
;*								*
;*			GAME  Work				*
;*								*
;=====================================================================
;--- Game Difficulty ---
;	alc	Kdifficulty,2		;easy/normal/hard
	alc	Kdifficulty2,2		;easy/normal/hard

	km_gmlabelstart	dif,0
	km_gmlabel	easy
	km_gmlabel	normal
	km_gmlabel	hard


;--- Game Skill ---
	alc	currentlevel,2
	km_gmlabelstart	step,0
	km_gmlabel	0
	km_gmlabel	1
	km_gmlabel	2
	km_gmlabel	3
	km_gmlabel	4
	km_gmlabel	5
	km_gmlabel	6
	km_gmlabel	7
step_Neutral	equ	15

;( For Eguchi's Work)
;	alc	PlanetSwitch,2		;Planet no Clear State Switch
	alc	KStackNumber,2		;Enemy Stack Number
	xalc	kx_stackbaseptr,2	;Enemy Stack Base Pointer
kstacklen	equ	16
	xalc	kx_stackbuffer,kstacklen	 ;Enemy Stack Buffer

;--- Enemy Angle --
	alc	Kinitroty,1

;---------------------------------------------------------------------
;*								*
;*			Player Work				*
;*								*
;---------------------------------------------------------------------
;***** Player Info ******
;* dochino player ka handan suru (sprites & BG no set notoki)
	alc	kplayer,1		;0/1 ... 1player / 2player
;(talcs.inc)
;	alc	p1_pilotNo,1
;	alc	p2_pilotNo,1

	xalc	kx_p1_pilotNo,1	;(0,1,2,3,4,5)	;FIX :(b7 = dead flag)
	xalc	kx_p2_pilotNo,1 :(0,1,2,3,4,5)	;FIX :(b7 = dead flag)
	xalc	kx_p1_TypePtr,2	;(0,2,4)	;Active
	xalc	kx_p2_TypePtr,2	;(0,2,4)	;Active

;(p1_pilotNo,p2_pilotNo)
;ep_fox		equ	0
;ep_falco		equ	1
;ep_peppy		equ	2
;ep_slippy		equ	3
;ep_gal1		equ	4
;ep_gal2		equ	5


;* player type & arwing type *
;	alc	karpltype1,1
;	alc	karpltype2,1
;kpltyf_fox		equ	%00000001
;kpltyf_falco	equ	%00000010
;kpltyf_peppy	equ	%00000100
;kpltyf_slippy	equ	%00001000
;kpltyf_gal1		equ	%00010000
;kpltyf_gal2		equ	%00100000

;* Player Sound Pointer *
	alc	kw_plsndptr,2
	km_gmlabelstart	plsnd,0
	km_gmlabel	fox
	km_gmlabel	falco
	km_gmlabel	peppy
	km_gmlabel	slippy
	km_gmlabel	gal1
	km_gmlabel	gal2
	km_gmlabellen	plsndlen

;* total score *
	alc	kw_totalscore1,4
	alc	kw_extrabonus1,4


	xalc	kx_basicscore,4
	xalc	kx_timebonus,4
	xalc	kx_damagebonus,4
	xalc	kx_bsclearbonus,4
	xalc	kx_plclearbonus,4
	xalc	kx_partnerbonus,4

;* rank *
	xalc	kx_rank,2	;(0,1,2,3,4,5 :S,A,B,C,D,E)

;* result flag *
	xalc	kx_resultflag,2		;(kw_MisTotalFlag)

;---------------------------------------------------------------------
;*			Game MAPS				*
;---------------------------------------------------------------------
	alc	KGameMapPtr,2	;(0,1,2,3,...)
	km_gmlabelstart	stg,0
	km_gmlabel	stg1
	km_gmlabel	stg2
	km_gmlabel	stg3
	km_gmlabel	stg4
	km_gmlabel	stg5
	km_gmlabel	stg6
	km_gmlabel	sos1
	km_gmlabel	sos2
	km_gmlabel	sos3
	km_gmlabel	sos4
	km_gmlabel	ext1
	km_gmlabel	ext2
	km_gmlabel	ext3
	km_gmlabel	ext4
	km_gmlabel	demo

	km_gmlabelstart	stg,0
	km_gmlabel	bat1
	km_gmlabel	bat2
	km_gmlabel	bat3
	km_gmlabel	bat4
	km_gmlabel	bat5

	alc	KGameMap,1		;(1,2,3,...)
	xalc	kx_testmapptr_bak,2
	xalc	kx_testskillptr_bak,2
	alc	kw_PlanetCol,1	;planet palette pointer
	alc	kw_planetptr,2	;planet sofet ware sprite pointer
;* ps... colour flashing no pointer nimo natteiru *

;*** Sound Map Pointer ***
	alc	KSoundMapPtr,1

;*** Radar Map Pointer ****
	alc	KRDMapPtr,2
	xalc	KRDMapBuffer,64*5+2

;* Yamada san ga set suru koteibutu(building nado) no MAP Pointer
;radr map no data wa (X,Y,ChrNo) no 5 byte de kousei sareteiru.
;  radarmaptbl
;	dw	DataTotal	(All RAdar Map Data)
;	db	DataCounter	(Building Number)*5
;	db	Total Ennemy Numbrer

;	dw	X zahyou		;0
;	dw	Z zahyou		;1
;	db	Enemy Character Number	;3
;		.
;		.
;		.

;--- Clear Target no kazu ---
;	alc	KEnemyNumber,2		;teki no kazu (sprites)

;--- Fade Wait Timer ---
	alc	kw_FadeWaitTm,2

;*********************************************************************
;*								*
;*			GAME TEMPORARY WORK			*
;*								*
;*********************************************************************
;=====================================================================
;*		TEMPORARY ZALC WORK [22 byte]		[rank0]	*
;=====================================================================
;* zalc ram *
kz_x1	equ	x1	;2 byte
kz_y1	equ	y1	;2 byte
kz_z1	equ	z1	;2 byte
kz_x2	equ	x2	;2 byte
kz_y2	equ	y2	;2 byte
kz_z2	equ	z2	;2 byte
kz_x3	equ	x3	;2 byte
kz_y3	equ	y3	;2 byte
kz_tpa	equ	tpa	;2 byte
kz_tpx	equ	tpx	;2 byte
kz_tpy	equ	tpy	;2 byte
kz_textpt	equ	textpt	;4 byte
kz_tempaddrl	equ   tempaddrl ;3 byte
	zalc	address,3
kz_address	equ	address	;3 byte

kz_wkdividend_L	equ	kz_textpt
kz_wkdividend_H	equ	kz_textpt+2
kz_wkdivisor		equ	kz_tempaddrl

;* Mario RAM Zwork *
;km_x1	equ	m_x1	;2 byte
;km_y1	equ	m_y1	;2 byte
;km_z1	equ	m_z1	;2 byte
;km_bigx	equ	m_bigx	;2 byte
;km_bigy	equ	m_bigy	;2 byte
;km_bigz	equ	m_bigz	;2 byte

;=====================================================================
;*		TEMPORARY WORK RAM [32 byte]	[rank0]		*
;=====================================================================
	alc	kwork,32
kworkstart	equ	kwork+0
kworkend	equ	kwork+31
;-----------------------------------------------------
;*	commom work (WORK0 ~ WORK15)		*
;-----------------------------------------------------
	km_worklabelstart	kwork
	km_worklabel	B,kwork0
	km_worklabel	B,kwork1
	km_worklabel	B,kwork2
	km_worklabel	B,kwork3
	km_worklabel	B,kwork4
	km_worklabel	B,kwork5
	km_worklabel	B,kwork6
	km_worklabel	B,kwork7
;---------------------------------------------
	km_worklabel	W,kflag		;2 byte
	km_worklabel	W,kcounter	;2 byte
	km_worklabel	W,kpointer	;2 byte
	km_worklabel	W,koffset	;2 byte
	km_worklabel	W,ksource	;2 byte
	km_worklabel	W,kdest	 	;2 byte
	km_worklabel	W,kx1		;2 byte
	km_worklabel	W,ky1		;2 byte
	km_worklabel	W,kz1		;2 byte
;---------------------------------------------
	km_worklabellen	kworklen	; length
	km_workvalcheck  32

;=====================================================================
;*		Special Work	[32 byte]	[RANK1]		*
;=====================================================================
	alc	kw_swork,32

kw_sworkstart	equ	kw_swork+0
kw_sworkend		equ	kw_swork+31
;=====================================================================
;*			TEMPORARY RAM		[RANK1]		*
;=====================================================================
;* kono work ha sub routine wo matagatte tukau kotoga dekiru.
;* shikashi kscreen.asm to sprites.asm noyouni mattaku chigau syorini
;* heiyoushite tukau kotoga dekinai 
;* mata data keep ha sono flame nai nomidesu 
	xalc	kxwork,48

kxworkstart	equ	kxwork+0
kxworkend	equ	kxwork+47
;=====================================================================
;*			TEMPORARY RAM	(64 Byte)	[RANK2]	*
;=====================================================================
;kono work RAM ha flame wo matagattemo data wo keep shimasu.
;map select,player select nadoni tukaimasu
	xalc	kxswork,64

kxsworkstart	equ	kxswork+0
kxsworkend	equ	kxswork+63

;---------------------------------------------------------------------
;*			Buffer					*
;---------------------------------------------------------------------
;---- Covert Hex Value to Decima -----
	xalc	kx_DecimalBuffer,9	;8 keta bunn

;---------------------------------------------------------------------
;*			TITLE					*
;---------------------------------------------------------------------
	km_worklabelstart	kw_swork
	km_worklabel	W,tiw_sprmode
	km_worklabel	W,tiw_gamemode
	km_worklabel	W,tiw_returndemo

;---------------------------------------------------------------------
;*								*
;*			MISSIONRESULT				*
;*								*
;---------------------------------------------------------------------
	xalc	kx_timemax,2
	xalc	kx_expertflag,2

;(kw_swork :32 byte)
	km_worklabelstart	kw_swork
	km_worklabel	W,mre_chartptr
	km_worklabel	W,mre_mainspriteoff	;0/1 ... main sprite ON/OFF
	km_worklabel	W,mre_fingeron		;0/1 ... finger sprite OFF/ON
	km_worklabel	W,mre_kettei		;0/1 ... kettei OFF/ON
	km_worklabel	W,mre_OKtimer		;OK Wait Timer 
	km_worklabel	W,mre_HiscoreFlag
	km_worklabel	W,mre_ChartEnable
	km_worklabel	W,mre_RecordEndFlag
	km_worklabel	W,mre_chartwaittm

	km_gmlabelstart	mrchart,0
	km_gmlabel	chart0,2
	km_gmlabel	chart1,2
	km_gmlabel	chart2,2
	km_gmlabel	chart3,2
	km_gmlabel	chart4,2
	km_gmlabel	chart5,2
	km_gmlabel	fadeout,2
	km_gmlabel	fadeoutwait,2
	km_gmlabel	recordend,2

;(kxwork :48 byte)
	km_worklabelstart	kxwork
	km_worklabel	W,mre_bscolour
	km_worklabel	W,mre_scorechart
	km_worklabel	W,mre_soundtimer
	km_worklabel	W,mre_KuruKuruTm
	km_worklabel	W,mre_KuruKuruPtr
	km_worklabel	W,mre_tmpX
	km_worklabel	W,mre_tmpY
	km_worklabel	W,mre_tmpXScore
	km_worklabel	W,mre_tmpYScore

	km_worklabel	W,mre_tmpTm
	km_worklabel	W,mre_tmpTmMax
	km_worklabel	W,mre_resultkazu
	km_worklabel	W,mre_tmpkazu
	km_worklabel	W,mre_tmpmaxkazu
	km_worklabel	W,mre_clrkazu
	km_worklabel	W,mre_clrchar
	km_worklabel	W,mre_tmpchar

	km_worklabel	W,mre_TotalScore
	km_worklabel	W,mre_TotalScore_H
	km_worklabel	W,mre_countupscore
	km_worklabel	W,mre_tmpscore
	km_worklabel	W,mre_tmpscoreH
	km_worklabel	W,mre_cdscore
	km_worklabel	W,mre_cdscoreH
	km_worklabel	W,mre_prscore
	km_worklabel	W,mre_prscoreH
	km_worklabel	W,mre_tmscore
	km_worklabel	W,mre_tmscoreH
	km_worklabel	W,mre_dmscore
	km_worklabel	W,mre_dmscoreH
	km_worklabel	W,mre_ptscore
	km_worklabel	W,mre_ptscoreH

;(kxswork:48 byte)
	km_worklabelstart	kxswork

	km_worklabel	W,mre_meter
	km_worklabel	W,mre_meter_back
	km_worklabel	W,mre_metertmp
	km_worklabel	W,mre_meterptr
	km_worklabel	W,mre_meteroffx
	km_worklabel	W,mre_meteroffy
	km_worklabel	W,mre_meterx
	km_worklabel	W,mre_metery
	km_worklabel	W,mre_meterflag
	km_worklabel	W,mre_rank
	km_worklabel	W,mre_rankflag
	km_worklabel	W,mre_recordflag
	km_worklabel	W,mre_kirarianmptr
	km_worklabel	W,mre_kirarianmtm
	km_worklabel	W,mre_expertanmptr
	km_worklabel	W,mre_expertanmtm
	km_worklabel	W,mre_expertdisplay
;---------------------------------------------------------------------
;*								*
;*			MISSIONGAMEOVER				*
;*								*
;---------------------------------------------------------------------
;(kw_swork :32 byte)
	km_worklabelstart	kw_swork
	km_worklabel	W,mgv_eyeanmptr
	km_worklabel	W,mgv_eyeanmtm
	km_worklabel	W,mgv_handLanmptr
	km_worklabel	W,mgv_handLanmtm
	km_worklabel	W,mgv_handRanmptr
	km_worklabel	W,mgv_handRanmtm

;(kxwork :48 byte)
	km_worklabelstart	kxwork
;(kxswork:48 byte)
	km_worklabelstart	kxswork
;---------------------------------------------------------------------
;*								*
;*			MISSIONMAP Select			*
;*								*
;---------------------------------------------------------------------
;--------------------------------------------------
;*  Koko kara shita wa Game Over shitemo 
;*  RAM Clear shinai
;--------------------------------------------------
;* Pointer *
	alc	kw_RandomPtr,2		;Random Pointer
	alc	kw_RndPlanetPtr,2	;Random Planet Pointer
	alc	kw_RndPlanetPtrBak,2	;Random Planet Contiune Pointer

	xalc	pl_rnd_offset,2		;Eguchi's Planet Random Table Pointer
	xalc	step_rnd_offset,2	;Eguchi's Step Up Random Table Pointer
	xalc	sos_rnd_offset,2	;Eguchi's SOS Random Table Pointer
	xalc	miss_rnd_offset,2	;Eguchi's Missile Random Table Pointer

;* taiman kun work *
	alc	demotaiman,1
	alc	demotaiman2,1

dt_dragon	equ	0
dt_stepup	equ	1
dt_ninja	equ	2
dt_crusher	equ	3
dt_d_sen	equ	4
dt_d_sen2	equ	5

;--------------------------------------------------
;*  Koko kara shita wa Game Over shitara 
;*  All RAM Clear shitemo Yoi
	xalc	MISSIONXRAM,0
;--------------------------------------------------
;--- Mission Map Chart ---
	xalc	kx_MisMapSeq,2
	xalc	kx_MisMapNextSeq,2
	xalc	kx_mismaptmchart,2
	xalc	kx_mismaptmchartNum,2

	km_gmlabelstart	mmseq,0
	km_gmlabel	nothing,2		;00 ... nothing

	km_gmlabel	timechartcheck,2

	km_gmlabel	messagetrig,2
	km_gmlabel	messagestartwait,2
	km_gmlabel	messagestarttrig,2
	km_gmlabel	messagewait,2

	km_gmlabel	eventwait,2
	km_gmlabel	clearwait,2

	km_gmlabel	start,2
	km_gmlabel	startdemowait,2
	km_gmlabel	explaindo,2
	km_gmlabel	explainfinish,2

	km_gmlabel	capture1_1,2
	km_gmlabel	capture1_2,2

	km_gmlabel	capture2_1,2
	km_gmlabel	capture2_2,2
	km_gmlabel	capture2_3,2
	km_gmlabel	capture2_4,2
	km_gmlabel	capture2_5,2

	km_gmlabel	capture3_1,2
	km_gmlabel	capture3_2,2
	km_gmlabel	capture3_3,2
	km_gmlabel	capture3_4,2

	km_gmlabel	capture4_1,2
	km_gmlabel	capture4_2,2
	km_gmlabel	capture4_3,2
	km_gmlabel	capture4_4,2

	km_gmlabel	capture5_1,2
	km_gmlabel	capture5_2,2
	km_gmlabel	capture5_3,2
	km_gmlabel	capture5_4,2
	km_gmlabel	capture5_5,2
	km_gmlabel	capture5_6,2
	km_gmlabel	capture5_7,2

	km_gmlabel	misallcancelcheck,2
	km_gmlabel	totugekicancelcheck,2

	xalc	kx_expdemowait,2
;---- Message Chart Sequence -----
	xalc	kx_MessageSeq,2
	km_gmlabelstart	messeq,0
	km_gmlabel	nothing,2		;00 ... nothing
	km_gmlabel	messagetrig,2
	km_gmlabel	messagestartwait,2
	km_gmlabel	messagestarttrig,2
	km_gmlabel	messagewait,2

	xalc	kx_messtartwait,2
	xalc	kx_messagewait,2

;--- Mission Map Player Demo Sequence ---
	xalc	kx_MMPlayerSeq,2
	xalc	kx_MMPlayerSeq_next,2
	km_gmlabelstart	plseq,0
	km_gmlabel	nothing,2		;00 ... nothing
	km_gmlabel	enterplanet,2		;02 ... 
	km_gmlabel	escapebattle,2		;04 ...
	km_gmlabel	planetclear,2		;06 ...
	km_gmlabel	enemyclear,2		;08 ...

	km_gmlabel	starttrig,2		
	km_gmlabel	startwait,2		
	km_gmlabel	startmothershiptrig,2	
	km_gmlabel	startmothershipwait,2	
	km_gmlabel	partnerwait,2

	km_gmlabel	plamiscleardemotrig,2
	km_gmlabel	plamiscleardemo,2
	km_gmlabel	plareturnmaptrig,2
	km_gmlabel	plareturnmapwait,2

	km_gmlabel	batmiscleardemotrig,2
	km_gmlabel	batmiscleardemo,2
	km_gmlabel	batreturnmaptrig,2
	km_gmlabel	batreturnmapwait,2

	km_gmlabel	sosmiscleardemotrig,2
	km_gmlabel	sosmiscleardemo,2

	km_gmlabel	sosgonedemotrig,2
	km_gmlabel	sosgonedemowait,2

	km_gmlabel	sosreturnmaptrig,2
	km_gmlabel	sosreturnmapwait,2
	km_gmlabel	zacoexplodewait,2

	km_gmlabel	missilefelltrig,2
	km_gmlabel	missilefellwait,2

	km_gmlabel	rannyuCheck,2
	km_gmlabel	rannyuwait,2

	km_gmlabel	ptcont_wolfboss,2
	km_gmlabel	ptcont_wolfboss2,2

	km_gmlabel	messagetrig,2
	km_gmlabel	messagewait,2

	km_gmlabel	tmcharttrig,2
	km_gmlabel	tmchartwait,2
	km_gmlabel	tmchartwait2,2

	km_gmlabel	tgdemotrig,2
	km_gmlabel	tgdemowait,2

	km_gmlabel	fbdemotrig,2
	km_gmlabel	fbdemowait,2

	km_gmlabel	pcdemotrig,2
	km_gmlabel	pcdemowait,2

	km_gmlabel	msdemotrig,2
	km_gmlabel	msdemowait,2

	km_gmlabel	sademotrig,2
	km_gmlabel	sademowait,2

	km_gmlabel	cursortrig,2
	km_gmlabel	cursorwait,2		

	km_gmlabel	yjbeginwait,2
	km_gmlabel	yjwait,2

	km_gmlabel	ketteiwait,2
	km_gmlabel	safetywait,2
	km_gmlabel	wipeopen,2

	xalc	kx_playerdemowait,2
	xalc	kx_messagedemowait,2

;--- Missile Sequence ---
	xalc	kx_MissileAllSeq,2
	km_gmlabelstart	msseq,0
	km_gmlabel	missileall0,2		;00 ... nothing
	km_gmlabel	missileall1,2		;02 ...
	km_gmlabel	missileall2,2		;04
	km_gmlabel	missileall3,2		;06
	km_gmlabel	missileall4,2		;08
	km_gmlabel	missileall5,2		;10

;--- Battle Ship Sequence ---
	xalc	kx_TotugekiSeq,2
	km_gmlabelstart	tgseq,0
	km_gmlabel	totugeki0,2		;00 ... nothing
	km_gmlabel	totugeki1,2		;02 ...
	km_gmlabel	totugeki2,2		;04
	km_gmlabel	totugeki3,2		;06

;--- Final Boss Sequence ---
	xalc	kx_FinalBossSeq,2
	km_gmlabelstart	fbseq,0
	km_gmlabel	nothing,2		;00 ... nothing
	km_gmlabel	finalbosstrig,2
	km_gmlabel	sosdestwait,2
	km_gmlabel	warpwait,2
	km_gmlabel	battlestart,2

	km_gmlabel	zacoenemykill,2
	km_gmlabel	missilekill,2
	km_gmlabel	planetkill,2
	km_gmlabel	battleshipkill,2
	km_gmlabel	allenemykill,2

;--- Partner Change -----
	xalc	kx_PartnerChangeSeq,2
	km_gmlabelstart	ptchseq,0
	km_gmlabel	nothing,2		;00 ... nothing


;* For Yajim's Wipe Switch *
	xalc	kx_demoflag,2
	xalc	kx_demonumber,2

;* kx_demoflag (Yajima's)*
demof_all	equ	-1
	km_gmflagstart	demof
	km_gmflag	wipeopen	;0/1 ... nothing / wipe open trigger
	km_gmflag	fell		;0/1 ... nothing / corneria fell


;	km_gmflag	demo		;0/1 ... normal / demo tyuu
;	km_gmflag	sosappear	;0/1 ... sos wo 1 ko demo set shitara flag on


;* kx_demonumber *
	km_gmlabelstart	demo
	km_gmlabel	normal		;0
	km_gmlabel	scrollopentrig	;1	;(yajima san ga ON suru)
	km_gmlabel	scrollopen	;2
	km_gmlabel	scrollclosetrig	;3	;(yajima san ga ON suru)
	km_gmlabel	scrollclose	;4
	km_gmlabel	enemyappeartrig	;5
	km_gmlabel	enemyappear	;6
	km_gmlabel	explainstart	;7
	km_gmlabel	explainfinish	;8	;(yajima san ga ON suru)

;--- Mission Map Player Demo Sequence ---
	xalc	kx_CorneriaFellSeq,2
	km_gmlabelstart	cfseq,0
	km_gmlabel	nothing,2		;00 ... nothing
	km_gmlabel	felltrig,2
	km_gmlabel	felldemo,2

	xalc	kx_CorneriaFellTm,2

;* pointer *
	alc	kw_gameframeptr,2	; 2 byte :kaku frame (8frame) ni okeru RAM program pointer

;* Clear Condition *
	xalc	kx_clearcondition,2		;Clear Jyouken 

;* KAZU *
	xalc	kx_result,2		;(0,1,2,) ... corneriafell,playerdown,game clear
;(kx_result)
	km_gmlabelstart	kre
	km_gmlabel	corneriafell
	km_gmlabel	playerdown
	km_gmlabel	gameclear

	xalc	kx_missiontotal,2	;Mission no Total (If =0 then Mission End)
	xalc	kx_initmissiontotal,2	;Mission no Total (Fix Data) 

	xalc	kx_planetkazu,2		;Clear no tameno Planet no kazu (dec)
	xalc	kx_senryoucurrent,2	;Ima Senryou Sareteiru Planet no Kazu (dec)
	xalc	kx_initplanetkazu,2	;initial no mission planet kazu (kotei !!)
	xalc	kx_planetclearcnt,2	;moshi mission wo clear shitara count +1 !!

	xalc	kx_initbattleshipkazu,2	;initial no battleship kazu (kotei !!)
	xalc	kx_battleshipkazu,2	;Clear no tameno Battle Ship no kazu
	xalc	kx_battleshipzaico,2	;Battle Ship no Zaico
	xalc	kx_battleshipcurrent,2	;Battle Ship no Current no kazu (ima deteiru !!)
	xalc	kx_battleshipclearcnt,2	;moshi mission wo clear shitara count +1 !!

	xalc	kx_battleshipzaicoptr,2	;Battle Ship no Zaico Disappear Zahyou Pointer
	xalc	kx_battleshipskillptr,2	;Battle Ship no Skill Pointer 

	xalc	kx_enemytotal,2		;ima deteiru Enemy (Zaco,missile) no Total Number (Enemy List no nakani iru kazu)

	xalc	kx_missilecurrent,2	;ima deteiru Missile Enemy no kazu
	xalc	kx_missileappcnt,2	;missile ga isseihassya surutameno counter
	xalc	kx_missileclearcnt,2	;moshi mission wo clear shitara count +1 !!
	xalc	kx_missilegekitui,2	;

	xalc	kx_zacocurrent,2	;ima deteiru Zaco Enemy no kazu
	xalc	kx_zacoclearcnt,2	;moshi mission wo clear shitara count +1 !!
	xalc	kx_zacogekitui,2	;

	xalc	kx_specialclearcnt,2	;Clear no tameno Taiman kun no kazu
	xalc	kx_specialcurrent,2	;ima deteiru Zaco Enemy no kazu

	xalc	kx_wolfcurrent,2	;ima dateiru Wolf Team no Kazu
	xalc	kx_wolffreestock,2	;free enable no kazu

;********** Game Timer ************
	xalc	kx_TotalTime,2
	xalc	kx_TotalTimeBak,2
	xalc	kx_TotalSubTime,2	;1 second timer
	alc	kw_Gametimer,2		;Game ni kakatta time
	xalc	kx_GameTmSub,2		;1 second timer
	xalc	kx_GameTmAdd,2		;1 second timer
	xalc	kx_YJGameTm,2		;decimal time
	xalc	kx_EnStratTm,2		;enemy stratage timer
	alc	kw_KeyEnableTimer,2	;2 byte: Key Enable Timer

;* planet cannon  *
	xalc	kx_PlanetcannonPtr,2	;Planet cannon Pointer
	xalc	kx_PlanetcannonListPtr,2	;Planet cannon
	xalc	kx_PlanetcannonTm,2	;Planet cannon
	xalc	kx_PlanetcannonFlag,2	;Planet cannon
	xalc	kx_PlanetcannonTmPri,2	;Planet cannon Time Priority
	xalc	kx_PlanetcannonTmPriCheck,2	;Planet cannon Time Priority
	xalc	pc_sndtm,2		;planet cannon charge sound wait timer

;(kx_PlanetcannonPtr)
	km_gmlabelstart	pcchart
	km_gmlabel	nothing	
	km_gmlabel	charge
	km_gmlabel	messagetrig

;---------------------------------------------------------------------
;* Sound Special Work *
	alc	kw_mmsoundflag,2
	alc	kw_mmBGM,2
	alc	kw_mmBGMPtr,2

	km_gmflagstart	mmsndf
mmsndf_all	equ	-1
	km_gmflag	sosappear
	km_gmflag	missileappear
	km_gmflag	corneriaexplode
	km_gmflag	missilein

	km_gmflag	battleshipappear
	km_gmflag	specialappear
	km_gmflag	tamedama

;* Planet tensou no tameno WORK *
	xalc	kx_showmapsize,2	;(irq.asm)

;--- BOSS  Mode ---
	alc	kw_BossPtr,2
	xalc	kx_BossMeterPtr,1
	alc	kw_BossMeterDMAsw,1
	xalc	kx_bosshp,1

;---- Speed Up Timer ----
	xalc	mm_speeduptimer,2	;normal/speedup ... 1 / 8

;--- Mission Type ----
	xalc	kx_MissionType,2
	km_gmlabelstart	mistyp
	km_gmlabel	planet,2		;0
	km_gmlabel	battleship,2		;2
	km_gmlabel	sosenemy,2		;4
	km_gmlabel	special,2		;6 :(Dragon,)
	km_gmlabel	finalboss,2		;8
	km_gmlabel	itemplanet,2		;10
;----------------------------------------------------------------------
;* OBJ Demo *
	xalc	kx_objdemonumber,2
	xalc	kx_objdemopointer,2
	xalc	kx_objdemolistptr,2
	xalc	kx_objdemowaittm,2
	xalc	kx_objdemocx,2
	xalc	kx_objdemocy,2

;(kx_objdemonumber)
	km_gmlabelstart	odm
	km_gmlabel	nothing,2
	km_gmlabel	finalwarp,2
	km_gmlabel	returnmap,2	
	km_gmlabel	normalwarp,2	
	km_gmlabel	missilefell,2	
	km_gmlabel	zacoexplode,2	
	km_gmlabel	enemygone,2	
	km_gmlabel	wolfgone,2	
	km_gmlabel	bshipexplode,2	
	km_gmlabel	planetexplode,2
	km_gmlabel	wolfexplode,2
	km_gmlabel	wolfappear,2
	km_gmlabel	start_easy,2
	km_gmlabel	start_normal,2
	km_gmlabel	start_hard,2
	km_gmlabel	last1warp,2
	km_gmlabel	planethojyuu,2
	km_gmlabel	warpcancel,2	
	km_gmlabel	runawaywarp,2	
	km_gmlabel	partnerchange,2
;----------------------------------------------------------------------
;***** cursor *****
	xalc	kx_cursortemp,0
	km_worklabelstart	kx_cursortemp
	km_worklabel	W,mmx_cursorflag	; 2 byte
	km_worklabel	W,mmx_cursorflag2	; 2 byte
	km_worklabel	W,mmx_curwaittm		; 2 byte
	km_worklabel	B,mmx_curposx		; 1 byte
	km_worklabel	B,mmx_curposy		; 1 byte
	km_worklabel	B,mmx_bigcurposX	; 1 byte
	km_worklabel	B,mmx_bigcurposY	; 1 byte
	km_worklabel	B,mmx_wipeposX		; 1 byte
	km_worklabel	B,mmx_wipeposY		; 1 byte
	km_worklabellen	cursorworklen		; length
	km_workvalcheck  32
	xalc	kx_cursor,cursorworklen
;* Cursor Display Demo Work *
	xalc	kx_curdemotemp,0
	km_worklabelstart	kx_curdemotemp
	km_worklabel	W,mmx_curdemox		; 2 byte
	km_worklabel	B,mmx_curdemox_h	; 1 byte
	km_worklabel	W,mmx_curdemoy		; 2 byte
	km_worklabel	B,mmx_curdemoy_h	; 1 byte
	km_worklabel	W,mmx_curdemovx		; 2 byte
	km_worklabel	B,mmx_curdemovx_h	; 1 byte
	km_worklabel	W,mmx_curdemovy		; 2 byte
	km_worklabel	B,mmx_curdemovy_h	; 1 byte
	km_worklabel	W,mmx_curdemochar	; 2 byte
	km_worklabellen	curdemoworklen		; length
	km_workvalcheck  18
	xalc	kx_curdemo,curdemoworklen*4

	xalc	kx_planetnamebuf,8
	xalc	kx_planetcxbuf,8
	xalc	kx_planetcybuf,8

	xalc	kx_planetbufnum,2
	xalc	kx_planetbufnum_bak,2
	xalc	kx_senryoustgptr,2
	xalc	kx_warpplaceptr,2
	xalc	kx_mshipcurrentnum,2	;(0~7)

;* mmx_cursorflag (2 byte) *
	km_flagstart
curf_all	equ	-1
	km_flag	curf_wkcancel	;0/1 ... waku kakomi cancel (planet enemy)
	km_flag	curf_keypush	;0/1 ... no key push / key push
	km_flag	curf_destdisp	;0/1 ... mokutekiti no display OFF/ON 
	km_flag	curf_pushA	;0/1 ... moshi kettei button wo PUSH shitara

	km_flag	curf_pausecheck	;0/1 ... pause syori jmp (OFF/ON)
	km_flag	curf_readyspup	;0/1 ... ready speed up OFF/ON
	km_flag	curf_gospup	;0/1 ... go speed up OFF/ON

	km_flag	curf_samearwing	;0/1 ... same arwing postion
	km_flag	curf_demo	;0/1 ... cursor demo
	km_flag	curf_fzcancel	;0/1 ... nothing / freeze kaijyo

	km_flag	curf_warpselect	;0/1 ... nothing / select warp planet
	km_flag	curf_warpcancel	;0/1 ... nothing / select warp cancel

;* mmx_cursorflag2 (2 byte) *
	km_gmflagstart	curf2

	km_gmflag hitplanet	;0/1 ... moshi A push shitatoki Planet ni Hit shiteitara
	km_gmflag hitbattleship	;0/1 ... nothing / corneria planet
	km_gmflag hitmothership	;0/1 ... nothing /  mothership

	km_gmflag hitplanettrig ;0/1 ... Planet ni Hit shiteitara
	km_gmflag goplanet	;0/1 ... mokutekinashi / dest ga planet
	km_gmflag gomothership	;0/1 ... nothing / mokutekichi ga mother

	km_gmflag hitenemy	;0/1 ... moshi cursor ga enemy ni HIT shitatoki !!
	km_gmflag hitsatellite	;0/1 ... nothing /  satellite

curf2_all		equ	-1
curf2_clrhitflag	equ	curf2_hitplanet!curf2_hitenemy!curf2_hitbattleship!curf2_hitmothership!curf2_hitsatellite
;---------------------------------------------------------------------
;****** player ******
;*( ALC ) *
	alc	kw_arwingtemp,0
	km_worklabelstart	kw_arwingtemp
	km_worklabel	W,mm_arwingcgxptr1	; 2 byte :arwing cgx data poinnter (ue 2chr)
	km_worklabel	W,mm_arwingcgxptr2	; 2 byte :arwing cgx data poinnter (shita 2chr)

	km_worklabel	W,mm_arwingcgxptr1_pt	; 2 byte :arwing cgx data poinnter (ue 2chr)
	km_worklabel	W,mm_arwingcgxptr2_pt	; 2 byte :arwing cgx data poinnter (shita 2chr)
	km_worklabellen	mm_arwinglen		; length
	km_workvalcheck  8
	alc	kw_arwing,mm_arwinglen

;*( XALC )
	xalc	kx_arwingtemp,0
	km_worklabelstart	kx_arwingtemp
	km_worklabel	B,mmx_arwingposx_l	; 1 byte
	km_worklabel	W,mmx_arwingposx	; 2 byte :(hi=integer,low=decimal)
	km_worklabel	B,mmx_arwingposy_l	; 1 byte
	km_worklabel	W,mmx_arwingposy	; 2 byte :(hi=integer,low=decimal)
	km_worklabel	W,mmx_arwingangY	; 2 byte :(hi=integer,low=decimal)
	km_worklabel	W,mmx_arwinghitang	; 2 byte :(0~$00ff)
	km_worklabel	W,mmx_arwingsp		; 2 byte
	km_worklabel	W,mmx_arwingspx		; 2 byte :(hi=integer,low=decimal)
	km_worklabel	W,mmx_arwingspy		; 2 byte :(hi=integer,low=decimal)
	km_worklabel	W,mmx_arwingflag	; 2 byte
	km_worklabel	W,mmx_arwingdemoptr	; 2 byte :
	km_worklabel	W,mmx_arwingdemotimer	; 2 byte :
	km_worklabel	W,mmx_arwingdestptr	; 2 byte
	km_worklabel	W,mmx_arwinganmptr	; 2 byte :kuru kruru pattern (0~15) pointer
	km_worklabel	W,mmx_arwingjetchr	; 2 byte :Arwing jet Chr

	km_worklabel	B,mmx_arwingdx		; 1 byte
	km_worklabel	B,mmx_arwingdy		; 1 byte
	km_worklabel	B,mmx_arwingdxdy	; 1 byte
	km_worklabel	B,mmx_arwinganmtm	; 1 byte
	km_worklabel	B,mmx_arwingdestposX	; 1 byte
	km_worklabel	B,mmx_arwingdestposY	; 1 byte
	km_worklabellen	mmx_arwinglen		; length
	km_workvalcheck  36
	xalc	kx_arwing,mmx_arwinglen

;* mmx_arwingflag (2 byte)*
	km_flagstart
mmf_all	equ	-1
	km_flag	mmf_initmove	;0/1 ... initial move parameters shita/trigger
	km_flag	mmf_go		;0/1 ... stop / arwing go
	km_flag	mmf_arvx	;0/1 ... arrived X zahyou
	km_flag	mmf_arvy	;0/1 ... arrived Y zahyou

	km_flag	mmf_finish	;0/1 ... arwing arrived (X,Y)
	km_flag	mmf_nocoll	;0/1 ... arwing collison ON/OFF
	km_flag	mmf_boostsnd	;0/1 ... boost sound OFF/ON
	km_flag	mmf_asteroid	;0/1 ... Asteroid Hit Check 

	km_flag	mmf_arrive	;0/1 ... Arrive	(mismap.asm de clear)w
	km_flag	mmf_notdisplay	;0/1 ... Arwing Not Display (&Partner)
	km_flag	mmf_demo	;0/1 ... normal move / demo move

;(mmx_arwingdemoptr)
	km_gmlabelstart	ardm,0
	km_gmlabel	nothing
	km_gmlabel	rushbosstrig
	km_gmlabel	loopmove
	km_gmlabel	rushboss
	km_gmlabel	returnmaptrig
	km_gmlabel	returnmap

	xalc	kx_partnertemp,0
	km_worklabelstart	kx_partnertemp
	km_worklabel	B,mmx_partnerposx_l	; 1 byte
	km_worklabel	W,mmx_partnerposx	; 2 byte :(hi=integer,low=decimal)
	km_worklabel	B,mmx_partnerposy_l	; 1 byte
	km_worklabel	W,mmx_partnerposy	; 2 byte :(hi=integer,low=decimal)
	km_worklabel	W,mmx_partnerangY	; 2 byte :(hi=integer,low=decimal)
	km_worklabel	W,mmx_partnersp		; 2 byte
	km_worklabel	W,mmx_partnerspx	; 2 byte
	km_worklabel	W,mmx_partnerspy	; 2 byte

	km_worklabel	W,mmx_partneranmptr	; 2 byte :kuru kruru pattern (0~15) pointer
	km_worklabel	W,mmx_partnerflag	; 2 byte

	km_worklabellen	mmx_partnerlen		; length
	km_workvalcheck  18
	xalc	kx_partner,mmx_partnerlen
;---------------------------------------------------------------------
;* mother ship *
	xalc	kx_mothershiptemp,0
	km_worklabelstart	kx_mothershiptemp
	km_worklabel	B,kx_mshipx		; 1 byte :CX zahyou
	km_worklabel	B,kx_mshipy		; 1 byte :CY zahyou
	km_worklabel	W,kx_mshipwaittm	; 1 byte :Mother Recover Timer
	km_worklabel	W,kx_MotherShipSeq	; 2 byte :Mother Ship Sequence
	km_worklabel	W,kx_MotherShipDemoSeq	; 2 byte :Mother Ship Demo Sequence
	km_workvalcheck  16
	km_worklabellen	mothershiplen		; length
	xalc	kx_mothership,mothershiplen

;(kx_MotherShipSeq)
	km_gmlabelstart	motherseq
	km_gmlabel	nothing,2	;0
	km_gmlabel	arrivetrig,2	;2
	km_gmlabel	partnerwait,2
	km_gmlabel	messagewait,2
	km_gmlabel	keycheck,2
	km_gmlabel	planetseltrig,2
	km_gmlabel	planetselect,2
	km_gmlabel	warptrig,2
	km_gmlabel	warpwait,2
	km_gmlabel	warpcancelwait,2
;---------------------------------------------------------------------
;***** Message Work RAM (For Yajima) *****
	xalc	kx_messagetmplist,0
	km_worklabelstart	kx_messagetmplist
	km_worklabel	w,mmx_mapcursor
	km_worklabel	w,mmx_planetname
	km_worklabel	w,mmx_planetstep
	km_worklabel	w,mmx_message_sos
	km_worklabel	w,mmx_tmpmessagesos
	km_worklabel	w,mmx_trigmessage
	km_worklabel	w,mmx_planet_stepup
	km_worklabel	w,mmx_sosappear
	km_worklabel	w,mmx_mapcursorX
	km_worklabel	w,mmx_mapcursorY
	km_worklabel	w,mmx_playerNo
	km_worklabel	w,mmx_mapstates
;;;	km_worklabel	w,mmx_planetstatus
	km_worklabellen	messagelistlen	; length
	xalc	kx_messagelist,messagelistlen

;(mmx_message_sos)
;(mmx_tmpmessagesos) :mission & Map
	km_gmflagstart	mesosfl
	km_gmflag	planetcannonhit	 ;0 :Hit Planet Canon !!
	km_gmflag	corneriafell	 ;1 :Corneria Fell
	km_gmflag	zacoattack	 ;2 :Attack Corneria to Zaco Enemy
	km_gmflag	missileattack	 ;3 :Attack Corneria to Missile
	km_gmflag	missileappear	 ;4 :Missile Appear
	km_gmflag	zacoappear	 ;5 :Zaco Enemy Appear
	km_gmflag	battleshipappear ;6
	km_gmflag	planetcannonarea ;7 :planet canon syatei area IN
	km_gmflag	virustorituki	 ;8 :Virus ga Satellite ni Torituki
	km_gmflag	zacotubushi	 ;9 :Hit Satellite Beem (enemy) !!

mesosfl_all	equ	mesosfl_planetcannonhit!mesosfl_corneriafell!mesosfl_zacoattack!mesosfl_missileattack!mesosfl_missileappear!mesosfl_zacoappear!mesosfl_battleshipappear!mesosfl_planetcannonarea!mesosfl_virustorituki!mesosfl_zacotubushi

;(map_trigmessage) :yalcs.inc :Map
	km_gmflagstart	ymes
	km_gmflag	taimanE			;0 :(taiman easy)
	km_gmflag	taimanN			;1 :(taiman normal),(planet add)
	km_gmflag	taimanH			;2 :(taiman hard)
	km_gmflag	planetcannonarea	;3
	km_gmflag	planetcannonfire	;4
	km_gmflag	battleshipaddN		;5
	km_gmflag	battleshipaddH		;6
	km_gmflag	battleshiptotugeki	;7
	km_gmflag	missileallfire		;8
	km_gmflag	target_last1		;9
	km_gmflag	wolfappear		;a
	km_gmflag	wolfdead		;b
	km_gmflag	sabeemfire		;c
	km_gmflag	attacklastboss		;d

ymes_all	equ	ymes_taimanE!ymes_taimanN!ymes_taimanH!ymes_planetcannonarea!ymes_planetcannonfire!ymes_battleshipaddN!ymes_battleshipaddH!ymes_battleshiptotugeki!ymes_missileallfire!ymes_target_last1!ymes_wolfappear!ymes_wolfdead!ymes_sabeemfire!ymes_attacklastboss

;---------------------------------------------------------------------
;***** Corneria Work RAM ******
	xalc	kx_CorneriaPtr,2	;Mother Planet no Pointer
	xalc	kx_CorneriaHP,2		;Corneria HitPoint (100 >>>   0)
	xalc	kx_CorneriaDamage,2	;Corneria Damage   (0   >>> 100)
	xalc	kx_AttackPoint,2	;Attack Point

;**** Item Planet ****
	xalc	kx_itemplanetplptr,2
	xalc	kx_itemplanetenptr,2

;**** Battle Ship Pointer ******
	xalc	kx_battleshipptr,2

;****** Planet Work RAM ********
	xalc	kx_currentplanetptr,2	;genzai play shiteiru planet no pointer
	xalc	kx_tmpplanetptr,2	;karikettei shiteiru planet no pointer
	xalc	kx_currentplanetnum,2	;genzai play shiteiru planet no skill

	xalc	kx_NearPlanetPtr,2	;0 .. chikakuni planet nashi ,not 0 ...planet list pointer
	xalc	kx_NearPlanetNum,2	;Near Planet Battle no tokino Planet No

	xalc	kx_MotherShipPlPtr,2	;Mother Ship no Planet List Pointer
	xalc	kx_MotherShipEnPtr,2	;Mother Ship no Enemy List Pointer

	xalc	kx_FinalBossPlPtr,2	;Final Boss Planet List Pointer
	xalc	kx_FinalBossEnPtr,2	;Final Boss Enemy  List Pointer

planetkazumax	equ	15

	xalc	kx_planetfreeptr,2	;Planet List Free Pointer
	xalc	kx_planetlistptr,2	;Planet List Pointer

;*** PlanetList ***
	xalc	kx_planettmplist,0
	km_worklabelstart	0
	km_worksizestart

	km_worklabel	w,mmx_planetnext	; 2 byte
	km_worklabel	w,mmx_planetprev	; 2 byte

;--- Planet Infomation ---
	km_worklabel	w,mmx_stage		; 2 byte :stage number (planet No)
	km_worklabel	w,mmx_name		; 2 byte :name number
	km_worklabel	w,mmx_planetskill	; 2 byte :step number  (Save Pointer)
	km_worklabel	w,mmx_planetswitch	; 2 byte :planet no clear state switch
	km_worklabel	w,mmx_planetcx		; 2 byte :center X (0~$00ff)
	km_worklabel	w,mmx_planetcy		; 2 byte :center Y (0~$00ff)
	km_worklabel	w,mmx_destx		; 2 byte :dest postion X
	km_worklabel	w,mmx_desty		; 2 byte :dest postion Y
	km_worklabel	w,mmx_scrcx		; 2 byte :screen center x (0~$001f)
	km_worklabel	w,mmx_scrcy		; 2 byte :screen center y (0~$001f)
	km_worklabel	w,mmx_zacochartptr	; 2 byte :Zaco Enemy Appear Chart Pointer
	km_worklabel	w,mmx_zacochartcnt	; 2 byte :Zaco Enemy Appear Chart Counter
	km_worklabel	w,mmx_planetflag	; 2 byte :main flag
	km_worklabel	w,mmx_battleshipflag	; 2 byte :main flag
	km_worklabel	w,mmx_dokuroanm		; 2 byte :not temporary
	km_worklabel	w,mmx_timer2		; 2 byte :temporary timer
	km_worklabel	w,mmx_bsangy		; 2 byte :Battle Ship Angle Y

;--- Link Pointer ---
	km_worklabel	w,mmx_sosenlistptr	; 2 byte :enemy list pointer
	km_worklabel	w,mmx_bslinkptr		; 2 byte :Battle Ship Link Pointer (Enemy List Pointer)

;--- planet cannon ---
	km_worklabel	w,mmx_planetcannonsx	; 2 byte
	km_worklabel	w,mmx_planetcannonsy	; 2 byte
	km_worklabel	w,mmx_planetcannondx	; 2 byte
	km_worklabel	w,mmx_planetcannondy	; 2 byte
	km_worklabel	w,mmx_planetcannonchart	; 2 byte
	km_worklabel	w,mmx_planetcannontm	; 2 byte

;--- sos enemy ----
	km_worklabel	w,mmx_psos		; 2 byte :sequence number
	km_worklabel	w,mmx_psos_bak		; 2 byte :sequence number (back up)

	km_worklabel	w,mmx_sosapcnt		; 2 byte :enemy ga arawareta toki DEC suru
	km_worklabel	w,mmx_sosdeadcnt	; 2 byte :enemy ga yarareta  toki DEC suru

	km_worklabel	w,mmx_soswaittm		; 2 byte :wait timer
	km_worklabel	W,mmx_soschartptr	; 2 byte :enemy chart pointer
	km_worklabel	W,mmx_sosattacktm	; 2 byte :Corneria Attack Timer (nan FRAM oki ni kougeki suruka)
	km_worklabel	W,mmx_sosattackpo	; 2 byte :attack point

;--- step up enemy ---
	km_worklabel	w,mmx_pstepup		; 2 byte
	km_worklabel	w,mmx_pstepup_bak	; 2 byte
;	km_worklabel	w,mmx_stupenlistptr	; 2 byte :enemy list pointer
;	km_worklabel	w,mmx_stupwaittm	; 2 byte

	km_worklabel	w,mmx_pwork1		; 2 byte
	km_worklabel	w,mmx_pwork2		; 2 byte
	km_worklabel	w,mmx_pwork3		; 2 byte
	km_worklabel	w,mmx_pwork4		; 2 byte
	km_worklabel	w,mmx_pwork5		; 2 byte
	km_worklabel	w,mmx_pwork6		; 2 byte

	km_worksize	planetreplaysize	; length

	km_worklabellen	planetlistlen		; length
	km_workvalcheck  200

	xalc	kx_planetlist,planetkazumax*planetlistlen

;(mmx_planetflag)
mmpnf_all	equ	-1

	defflaglist	mmpnf

	defflag	planet		;normal planet flag
	defflag	corneria	;corneria (mother planet) flag
	defflag	battleship	;battleship
	defflag	mothership	;mother ship

	defflag	finalboss	;final boss
	defflag	satellite	;satellite
	defflag	itemplanet	;item planet
	defflag	battleplayer	;player to battle tyuu !!

	defflag	deadwait	;enmey alive/dead
	defflag	bornfreeze	;if player is doing planet mission  then enemy can't born in this planet!!
	defflag	borndemotrig	;enmey born demo check trigger off/on
	defflag	sosappear	;sos enemy not appear/appear

	defflag	complete	;senryou tyuu / hoshi dakkan
	defflag	senryou		;senryou sarete inai/iru
	defflag	dakkan		;planet dakkan demo OFF/ON
	defflag	wolfprotect	;planet protect shiteinai / iru

;(mmx_battleshipflag)
mmbsf_all	equ	-1
	defflaglist	mmbsf
	defflag	type		;battle ship type 0/1
	defflag	cannonareain	;out of range / shatei area IN
	defflag	zacoappear	;enable / disable
;(mmx_name)
	km_gmlabelstart	planet
	km_gmlabel	stage1		;0
	km_gmlabel	stage2		;1
	km_gmlabel	stage3		;2
	km_gmlabel	stage4		;3
	km_gmlabel	stage5		;4
	km_gmlabel	stage6		;5
	km_gmlabel	corneria	;6
	km_gmlabel	battleship	;7
	km_gmlabel	mothership	;8
	km_gmlabel	friendside	;9
	km_gmlabel	enemyside	;10
	km_gmlabel	itemplanet	;11
	km_gmlabel	nothing		;12

;(mmx_psos)
	km_gmlabelstart	enbase
	km_gmlabel	nothing
	km_gmlabel	inittime
	km_gmlabel	wait
	km_gmlabel	born
	km_gmlabel	jetattackwait
;(Virus)
	km_gmlabelstart	virbase
	km_gmlabel	appearcheck
	km_gmlabel	appearwait
	km_gmlabel	appear
	km_gmlabel	move

;(mmx_planetcannonchart) :planet cannon sprite chart
	km_gmlabelstart	pcspr
	km_gmlabel	nothing
	km_gmlabel	charge
	km_gmlabel	fire
	km_gmlabel	exptrig
	km_gmlabel	explode
	km_gmlabel	damagewait
	km_gmlabel	finish
	
;---------------------------------------------------------------------
;********* enemy list *********
;* enemy chart *
	xalc	kx_enemychartptr,2
	xalc	kx_enemydestptr,2
	xalc	kx_enemyinptr,2		;corneria wo attack shiteiru zaco teki !!

	xalc	kx_satelliteenptr,2
	xalc	kx_satelliteplptr,2
	xalc	kx_sachargeanmptr,2
	xalc	kx_sachargeanmtm,2

	xalc	kx_satoritukianmptr,2
	xalc	kx_satoritukianmtm,2

	xalc	kx_satelliteSeq,2
	xalc	kx_satelliteflag,2
	xalc	kx_SatelliteBeemChart,2
	xalc	kx_SatelliteBeemChartTm,2

	xalc	kx_sabeemptr,2
	xalc	kx_sabeemseq,2
	xalc	kx_salockonptr,2
	xalc	kx_satellitetype,2	; 2 byte :0/not 0 ... friend / enemy
	xalc	kx_houdaiangle,2	; 2 byte :satellite houdai angle

;(kx_satelliteflag)
	km_gmflagstart	safl

	km_gmflag	type		;0/1 ... friend / enemy
	km_gmflag	charge		;0/1 ... nothing / charge
	km_gmflag	tamedama	;0/1 ... nothing / display
	km_gmflag	lockon		;0/1 ... nothing /target lock on

	km_gmflag	beemtrig	;0/1 ... beem trigger off / on
	km_gmflag	beeminit	;0/1 ... beem initial OK / need initial
	km_gmflag	beemhit		;0/1 ... beem hit shinai / shita
	km_gmflag	explodewait	;0/1 ... finish / wait

	km_gmflag	virusbattle	;0/1 ... nothing / virus to battle tyuu
	km_gmflag	toritukitrig	;0/1 ... trituki sprite animation
	km_gmflag	virustorituki	;0/1 ... toritukarete inai /iru
	km_gmflag	virusgekitui	;0/1 ... nothing / gekitui

	km_gmflag	satellitebattle ;0/1 ... nothing / satellite battle

;* enemy list *
	xalc	kx_SOSEnemyptr,2	;Current SOS Enemy Pointer

	xalc	kx_RannyuEnemyptr,2	;Rannyu Enemy Pointer
	xalc	kx_RannyuStratptr,2	;Rannyu Enemy Strat Pointer
	xalc	kx_RannyuSeqPtr,2	;Rannyu Enemy Sequence Pointer

	xalc	kx_enarrivetmptr,2

	xalc	kx_wolfgonestratptr_bak,2	;wolf team ga enemy has gone shita toki stratege wo back up suru work

	xalc	kx_enlistptr,2
	xalc	kx_enfreeptr,2

_enemynum	equ	23
	km_worklabelstart	0
	km_worklabel	W,mmx_ennext		; 2 byte
	km_worklabel	W,mmx_enprev		; 2 byte

;* sequence *
	km_worklabel	W,mmx_ensequence	; 2 byte enemy sequence
	km_worklabel	W,mmx_ensequence_bak	; 2 byte enemy sequence
	km_worklabel	W,mmx_enwaittm		; 2 byte enemy wait timer
;* move *
	km_worklabel	W,mmx_enmvchart		; 2 byte :enemy move chart pointer
	km_worklabel	W,mmx_enmvwaittm	; 2 byte :enemy move wait time

;* pointer *
	km_worklabel	W,mmx_enstratptr	; 2 byte :stratage (move) pointer
	km_worklabel	W,mmx_enstratptr_bak	; 2 byte :stratage (move) pointer push
	km_worklabel	W,mmx_enlinkptr		; 2 byte Link Pointer (Mother Pointer)
	km_worklabel	W,mmx_ensourplanetptr	; 2 byte :(umareta hoshi or senkan)
	km_worklabel	W,mmx_endestplanetptr	; 2 byte :(iki saki)
	km_worklabel	W,mmx_enchildlinkptr	; 2 byte Link Pointer

;* postion *
	km_worklabel	B,mmx_enposx_l		; 1 byte (decimal)
	km_worklabel	W,mmx_enposx		; 2 byte (hi=integer,low=decimal)
	km_worklabel	B,mmx_enposy_l		; 1 byte (decimal)
	km_worklabel	W,mmx_enposy		; 2 byte (hi=integer,low=decimal)
	km_worklabel	W,mmx_endestx		; 2 byte :enemy ga mukatteiru Planet no X zahyou
	km_worklabel	W,mmx_endesty		; 2 byte :enemy ga mukatteiru Planet no Y zahyou
;* angle *
	km_worklabel	W,mmx_enangY		; 2 byte (0~$ffff) :(hi=integer,low=decimal)
;* velocity *
	km_worklabel	W,mmx_envel		; 2 byte (hi=integer,low=decimal)
	km_worklabel	B,mmx_envelx_l		; 1 byte (decimal)
	km_worklabel	W,mmx_envelx		; 2 byte (hi=integer,low=decimal)
	km_worklabel	B,mmx_envely_l		; 1 byte (decimal)
	km_worklabel	W,mmx_envely		; 2 byte (hi=integer,low=decimal)
;* flag *
	km_worklabel	W,mmx_enflags		; 2 byte :enemy flags
	km_worklabel	W,mmx_enflags2		; 2 byte :enemy flags2
;* states *
	km_worklabel	W,mmx_enstage		; 2 byte :stage (sos1,sos2,sos3)
	km_worklabel	W,mmx_enskill		; 2 byte :enemy current level
	km_worklabel	W,mmx_entype		; 2 byte :zaco(0,1)/missile(2,3)/ship(4,5)
	km_worklabel	W,mmx_enkazu		; 2 byte :enemy no hentai suu
	km_worklabel	W,mmx_enstackptr	; 2 byte :enemy no nokori kazu
	km_worklabel	W,mmx_enattackpo	; 2 byte :attack point
	km_worklabel	W,mmx_enwolfnum		; 2 byte :(0,1,2,3)

;* collision *
	km_worklabel	W,mmx_encoll		; 2 byte :collision
	km_worklabel	W,mmx_eninvtm		; 2 byte :muteki jikan

;* animation *
	km_worklabel	W,mmx_enanmpatt		; 2 byte :animation pattern sequence No (yajima's)
	km_worklabel	W,mmx_enanmtm		; 2 byte :animation sequence timer (yajima's)
	km_worklabel	W,mmx_enanmmax		; 2 byte :animation pattern frame max (Loop)

;* temp work *
	km_worklabel	W,mmx_enwork1		; 2 byte :(enter planet work,zaco around angY)
	km_worklabel	W,mmx_enwork2		; 2 byte
	km_worklabel	W,mmx_enwork3		; 2 byte
	km_worklabel	W,mmx_enwork4		; 2 byte

	km_worklabellen	mmx_enemylen		; length

;;	km_worklabel	W,mmx_enplanetNo	; 2 byte :enemy ga mukatteiru Planet no Number
;;	km_worklabel	W,mmx_enanmptr		; 2 byte
;;	km_worklabel	W,mmx_ensenkyowaittm	; 2 byte :step up wait time
;;	km_worklabel	W,mmx_enattacktm	; 2 byte :Corneria Attack Timer (nan FRAM oki ni kougeki suruka)
;;	km_worklabel	W,mmx_enchranm		; 2 byte :animation character No & (H,V)Flip
;;	km_worklabel	W,mmx_ensprposx		; 2 byte sprite postion X
;;	km_worklabel	W,mmx_ensprposy		; 2 byte sprite postion Y
;;	km_worklabel	B,mmx_endestptr		; 1 byte :enemy ga mukatteiru Planet no Pointer
;;	km_worklabel	W,mmx_enchrbase		; 2 byte :enemy character Base No
;;	km_worklabel	W,mmx_enarrivetm	; 2 byte :arrive time (to corneria)
	km_workvalcheck  86

	xalc	kx_enemylist,mmx_enemylen*_enemynum

;(mmx_ensequence)
	km_gmlabelstart	enseq
	km_gmlabel	nothing
	km_gmlabel	appeardemo
	km_gmlabel	chaseangle
	km_gmlabel	spenappear1
	km_gmlabel	spenappear2
	km_gmlabel	planetsenryou1
	km_gmlabel	planetsenryou2
	km_gmlabel	move
	km_gmlabel	attackcorneria
	km_gmlabel	friendbattle
	km_gmlabel	virusmove
	km_gmlabel	virustorituki
	km_gmlabel	beemexplodetrig
	km_gmlabel	beemexplodeLtrig
	km_gmlabel	beemexplode
	km_gmlabel	enterdemo1
	km_gmlabel	enterdemo2
	km_gmlabel	explodedemo
	km_gmlabel	disappear

;	km_gmlabel	battleplayer

	km_gmlabelstart	bsseq
	km_gmlabel	nothing
	km_gmlabel	appeardemowait
	km_gmlabel	appeardemotrig
	km_gmlabel	appeardemo1
	km_gmlabel	appeardemo2
	km_gmlabel	appeardemo3
	km_gmlabel	move
	km_gmlabel	battleplayer
	km_gmlabel	attackcorneria

;* enmey flags (mmx_enflags)*
enfl_all	equ	-1

	km_gmflagstart	enfl

	km_gmflag	encountplayer	;0/1 ... nothing / encount player
	km_gmflag	attackcorneria	;0/1 ... not attack / attack corneria
	km_gmflag	arrive		;0/1 ... not arrive / arrive
	km_gmflag	wolf		;0/1 ... wolf (pig,mokey,chameleon)

	km_gmflag	zaco		;0/1 ... zaco enemy
	km_gmflag	missile		;0/1 ... missile
	km_gmflag	battleship	;0/1 ... battle ship
	km_gmflag	special		;0/1 ... taimankun

	km_gmflag	mothership	;0/1 ... mothership
	km_gmflag	finalboss	;0/1 ... finalboss
	km_gmflag	satellite	;0/1 ... tyuuritu chitai
	km_gmflag	virus		;0/1 ... virus

	km_gmflag	invisible	;0/1 ... visible / invisible
	km_gmflag	nocollision	;0/1 ... atari ari /muteki(no collision)
	km_gmflag	demo		;0/1 ... normal / demo tyuu
	km_gmflag	itemplanet	;0/1 ... item planet

;;;	km_gmflag	child		;0/1 ... normal / child

enfl_enskip		equ	enfl_wolf!enfl_battleship!enfl_special!enfl_mothership!enfl_finalboss!enfl_satellite!enfl_virus!enfl_itemplanet
enfl_lockonskip	equ	enfl_encountplayer!enfl_nocollision!enfl_invisible!enfl_enskip

;* enmey flags (mmx_enflags2)*
enfl2_all	equ	-1

	km_gmflagstart	enfl2

	km_gmflag	nosprite	;0/1 ... display / nosprite
	km_gmflag	asteroid	;0/1 ... asteroid nohit/hit
	km_gmflag	nojet		;0/1 ... nothing / enter planet animation start trigger (stepup)
	km_gmflag	SearchAreaIn	;0/1 ... nothing / player search area IN

	km_gmflag	anmloop		;0/1 ... nothing / animation LOOP
	km_gmflag	hachinoji	;0/1 ... nothing / around planet 8noji
	km_gmflag	fix		;0/1 ... nothing / Fix Sprite Display
	km_gmflag	type		;0/1 ... type1 / type2	;zaco enemy type

	km_gmflag	searchenemy	;0/1 ... nothing / player search enemy
	km_gmflag	searchon	;0/1 ... search enable off/on
	km_gmflag	planetprotect	;0/1 ... wolf team free / planet protect

	km_gmflag	fireenable	;0/1 ... charge / fire enable
	km_gmflag	deadcnt		;0/1 ... dead cnt shinai/suru
	km_gmflag	tyuuritu	;0/1 ... friend / enemy

;* enemy stratage (mmx_enstratptr) *
	km_gmlabelstart	enstrat
	km_gmlabel	nothing
	km_gmlabel	straight
	km_gmlabel	angvel
	km_gmlabel	posvel
	km_gmlabel	turn
	km_gmlabel	hachinoji
	km_gmlabel	spin
	km_gmlabel	chase
	km_gmlabel	scurve

;* enemy type (mmx_entype :2 byte) *
	km_gmlabelstart	entyp
	km_gmlabel	zaco1
	km_gmlabel	zaco2
	km_gmlabel	zaco3
	km_gmlabel	missile
	km_gmlabel	special
	km_gmlabel	virus
	km_gmlabel	wolf
	km_gmlabel	battleship
	km_gmlabel	mothership
	km_gmlabel	satellite
	km_gmlabel	finalboss
	km_gmlabel	itemplanet

;---------------------------------------------------------------------
;*		Enemy Child List Pointer			*
;---------------------------------------------------------------------
	IFEQ	1
	xalc	kx_childlistptr,2
	xalc	kx_childfreeptr,2
_childnum	=	10
	km_worklabelstart	0		;kx_enemylisttemp
	km_worklabel	W,mmx_childnext		; 2 byte
	km_worklabel	W,mmx_childprev		; 2 byte

	km_worklabel	W,mmx_childlinkptr	; 2 byte 
	km_worklabel	W,mmx_childsx		; 2 byte (hi=integer,low=decimal)
	km_worklabel	W,mmx_childsy		; 2 byte (hi=integer,low=decimal)
	km_worklabel	W,mmx_childvelx		; 2 byte (hi=integer,low=decimal)
	km_worklabel	W,mmx_childvely		; 2 byte (hi=integer,low=decimal)
	km_worklabel	W,mmx_childtimer	; 2 byte

	km_worklabellen	mmx_childlen		; length
	xalc	kx_childlist,mmx_childlen*_childnum
	ENDC

;=====================================================================
;*		Enemy Type Info ( For Eguchi )			*
;=====================================================================
	xalc	EEnemyShapeA_0,16
	xalc	EEnemyShapeB_0,16
	xalc	EEnemyTypeA,2
	xalc	EEnemyKazuA,2
	xalc	EEnemyTypeB,2
	xalc	EEnemyKazuB,2

;---------------------------------------------------------------------
;*			Common WORK				*
;---------------------------------------------------------------------
;(kw_swork :32 byte)
	km_worklabelstart	kw_swork
;* Bit Map Planet *
	km_worklabel	W,mmw_wbuffercounter	; 2 byte
	km_worklabel	W,mmw_dmabaseptr	; 2 byte
	km_worklabel	W,mmw_dmabase_moto	; 2 byte
	km_worklabel	W,mmw_dmabase_sakistep	; 2 byte
	km_worklabel	W,mmw_vrambase		; 2 byte
	km_worklabel	W,mmw_vramadr		; 2 byte
	km_worklabel	W,mmw_mrambase		; 2 byte
	km_worklabel	W,mmw_4f3pptr		; 2 byte
	km_worklabel	W,mmw_pldangertm	; 2 byte
	km_worklabel	W,mmw_wolfgonetrig	; 2 byte :wolf ga enmeygone katu rannyuu shita toki ON
	km_workvalcheck  32

;(kxwork :48 byte)
	km_worklabelstart	kxwork
;* Cursor Work *
	km_worklabel	B,mmx_curaccelx		; 1 byte
	km_worklabel	B,mmx_curspeedx		; 1 byte
	km_worklabel	B,mmx_curaccely		; 1 byte
	km_worklabel	B,mmx_curspeedy		; 1 byte
	km_worklabel	B,mmx_curaccel		; 1 byte
	km_worklabel	B,mmx_curspeed		; 1 byte
	km_worklabel	B,mmx_curchar		; 1 byte
	km_worklabel	B,mmx_curanmtm		; 1 byte
	km_worklabel	B,mmx_curanmptr		; 1 byte
	km_worklabel	B,mmx_destmarktm	; 1 byte
	km_worklabel	W,mmx_destmarkptr	; 2 byte
	km_worklabel	W,mmx_spx_dec		; 2 byte :Temp Speed (X) :decimal
	km_worklabel	W,mmx_spx_int		; 2 byte :Temp Speed (X) :integer
	km_worklabel	W,mmx_spy_dec		; 2 byte :Temp Speed (Y) :decimal
	km_worklabel	W,mmx_spy_int		; 2 byte :Temp Speed (Y) :integer
	km_worklabel	B,mmx_jetanmptr		; 1 byte :Arwing Boost Animatio Pointer
	km_worklabel	w,mmx_DrawPlanetCnt	; 2 byte :Draw Planet Counter
	km_worklabel	w,mmx_battleshipcnt	; 2 byte :Battle Ship Counter
	km_worklabel	w,mmx_clocksubptr	; 2 byte :Total Timer no Sub Meter Pointer
	km_worklabel	B,mmx_enbaseanmptr	; 1 byte :Enemy Base Animation Pointer
	km_worklabel	w,mmx_jetptr		; 2 byte :Zaco Enemy Jet Pointer
	km_worklabel	w,mmx_expzacojetptr	; 2 byte :Explain Zaco Jet Animation Pointer
	km_worklabel	w,mmx_expwaitcnt	; 2 byte :Explin Start Wait Counter
	km_worklabel	w,mmx_senryoucnt	; 2 byte :Senryou sareru Planet No Kazu No Counter
	km_worklabel	w,mmx_posxbak		; 2 byte :postion x back up
	km_worklabel	w,mmx_posybak		; 2 byte :postion y back up

;	km_worklabel	w,mmx_stupXposhosei	; 2 byte
;	km_worklabel	B,mmx_meteoranmptr	; 1 byte :Meteor Animation Pointer
;	km_worklabel	W,mmx_pausescroll	; 2 byte
;	km_worklabel	W,mmx_scrollwaittm	; 2 byte
;	km_worklabel	B,mmx_ballsettm		; 1 byte
;	km_worklabel	w,mmx_stepupsetcnt	; 2 byte :Step Up First Setting Counter (easy,normal,hard)
;	km_worklabel	w,mmx_stepupsetptr	; 2 byte :Step Up First Setting Pointer (easy,normal,hard)

	km_workvalcheck  48

;(mmx_pausescroll)
scrl_normal		equ	0
scrl_openscrollwait	equ	1
scrl_openscroll	equ	2
scrl_pausekeywait	equ	3
scrl_pause		equ	4
scrl_closescrollwait	equ	5
scrl_closescroll	equ	6
scrl_closefinish	equ	7

;	km_worklabel	B,mmx_curtimer		; 1 byte
;	km_worklabel	W,mmx_curanmpat		; 2 byte
;	km_worklabel	W,mmx_curanmpat2	; 2 byte
;	km_worklabel	B,mmx_planetposcx	; 1 byte
;	km_worklabel	B,mmx_planetposcy	; 1 byte
;	km_worklabel	B,mmw_ok		; 1 byte
;	km_worklabel	W,mmw_planetdataptr	; 2 byte
;	km_worklabel	W,mmw_planetanmptr	; 2 byte
;	km_worklabel	W,mmw_planetvheight	; 2 byte
;	km_worklabel	W,mmx_planetangx	; 2 byte
;	km_worklabel	W,mmx_planetangy	; 2 byte
;	km_worklabel	W,mmx_planetangz	; 2 byte
;	km_worklabel	B,mmx_stationtm		; 1 byte
;	km_worklabel	B,mmx_stationanmptr	; 1 byte

;(kxswork:64 byte)
;** Mission Map Select parameters **
	km_worklabelstart	kxswork
;* Mission Total Timer Work *
	km_worklabel	W,mmx_TMSendAnmPtr	; 2 byte :Add Timer Yajirushi
	km_worklabel	W,mmx_SOSMark		; 2 byte :SOS Mark Anim Timer

	km_worklabel	W,mmx_RndPlanetCnt	; 2 byte :Random Planet Set Order Number
	km_worklabel	W,mmx_soszaicocnt	; 2 byte :SOS Enemy Zaico Counter
	km_worklabel	W,mmx_specialapcocnt	; 2 byte :Special Enemy Appear Count
	km_worklabel	W,mmx_specialaploop	; 2 byte :Special Enemy Appear Set Loop Count (SetSpecialEnemy)

	km_worklabel	B,mmx_RndPlanetStage	;
	km_worklabel	B,mmx_RndPlanetName	;
	km_worklabel	B,mmx_RndPlanetSX	;
	km_worklabel	B,mmx_RndPlanetSY	;
	km_worklabel	B,mmx_RndPlanetDX	;
	km_worklabel	B,mmx_RndPlanetDY	;
	km_worklabel	B,mmx_cannonPointX	;
	km_worklabel	B,mmx_cannonPointY	;
	km_worklabel	B,mmx_RndPlanetR	;
	km_worklabel	B,mmx_BShipType		;

	km_worklabel	W,mmx_RndPlanetPtr	;
	km_worklabel	W,mmx_FinalBossTm

	km_worklabel	W,mmx_warpselect	; 2 byte
	km_worklabel	W,mmx_warpseltrig	; 2 byte

	km_worklabel	W,mmx_enemydestptr	; 2 byte :Step Up Destination Planet Pointer

;* Heap Pointer *
	km_worklabel	W,mmx_objcgxaddr	;OBJ CGX BUFFER Top Addr (ARWING)
	km_worklabel	W,mmx_ramprogaddr	;RAM PROGAM Top Addr
	km_worklabel	W,mmx_ramprogptr	;RAM Program Pointer
	km_worklabel	W,mmx_sprarwingaddr	;Arwing  Anm Data Top Addr

;* Planet cannon *
	km_worklabel	W,mmx_cannonExplodeCnt
	km_worklabel	W,mmx_cannonListPtr

	km_worklabel	B,mmx_cannonExplodeX1
	km_worklabel	B,mmx_cannonExplodeY1
	km_worklabel	B,mmx_cannonExplodeptr1
	km_worklabel	B,mmx_cannonExplodetm1
	km_worklabel	B,mmx_cannonExplodeEn1

	km_worklabel	B,mmx_cannonExplodeX2
	km_worklabel	B,mmx_cannonExplodeY2
	km_worklabel	B,mmx_cannonExplodeptr2
	km_worklabel	B,mmx_cannonExplodetm2
	km_worklabel	B,mmx_cannonExplodeEn2

	km_worklabel	B,mmx_cannonExplodeX3
	km_worklabel	B,mmx_cannonExplodeY3
	km_worklabel	B,mmx_cannonExplodeptr3
	km_worklabel	B,mmx_cannonExplodetm3
	km_worklabel	B,mmx_cannonExplodeEn3

	km_worklabel	B,mmx_cannonExplodeX4
	km_worklabel	B,mmx_cannonExplodeY4
	km_worklabel	B,mmx_cannonExplodeptr4
	km_worklabel	B,mmx_cannonExplodetm4
	km_worklabel	B,mmx_cannonExplodeEn4

;	km_worklabel	W,mmx_DokuroMark	; 2 byte :Dokuro Mark Anim Timer
;	km_worklabel	W,mmx_sprballaddr	; 2 byte :Ball Top Addr
;	km_worklabel	W,mmx_enemychartaddr	; 2 byte :
;	km_worklabel	W,mmx_sprstationaddr	;Station Anm Data Top Addr
;	km_worklabel	W,mmx_sprsizeaddr	;Sprite Size Table Top Addr
;	km_worklabel	W,mmx_SCRtensou		; 2 byte
;	km_worklabel	W,mmx_SCRtensou2	; 2 byte
;	km_worklabel	W,mmx_SCRtensou4	; 2 byte
;	km_worklabel	W,mmx_SCRtensou6	; 2 byte
;	km_worklabel	W,mmx_SCRtensou8	; 2 byte
;	km_worklabel	W,mmx_SCRtensou10	; 2 byte
;	km_worklabel	W,mmx_SCRtensou12	; 2 byte
;	km_worklabel	W,mmx_SCRtensou14	; 2 byte
;;;;	km_worklabel	W,mmx_collisaddr	;Collison List Top Addr
;;;	km_worklabel	W,mmx_sprgessoaddr	;Gesso Anm Data Top Addr
;;;	km_worklabel	W,mmx_sprghost1addr	;Ghost1 Anm Data Top Addr
;;;	km_worklabel	W,mmx_sprghost2addr	;Ghost2 Anm Data Top Addr
;;;	km_worklabel	W,mmx_sprghost3addr	;Ghost3 Anm Data Top Addr
	km_workvalcheck  64

	IFEQ	1
;* ball (form arwing to planet) *
	km_worklabelstart	heap
	km_worklabel	B,mmx_ballsx		; 1 byte
	km_worklabel	B,mmx_ballsy		; 1 byte
	km_worklabel	B,mmx_ballex		; 1 byte
	km_worklabel	B,mmx_balley		; 1 byte
	km_worklabel	B,mmx_ballsp		; 1 byte
	km_worklabel	B,mmx_ballspx		; 1 byte
	km_worklabel	B,mmx_ballspy		; 1 byte
	km_worklabel	B,mmx_balldx		; 1 byte
	km_worklabel	B,mmx_balldy		; 1 byte
	km_worklabel	B,mmx_balldxdy		; 1 byte
	km_worklabel	B,mmx_ballflags		; 1 byte
	km_worklabel	B,mmx_ballcntx		; 1 byte
	km_worklabel	B,mmx_ballcnty		; 1 byte
	km_worklabellen	mmx_balllen		; length
	ENDC

;* Mission Map Clear RAM END Address *
	xalc	MISSIONXRAMEND,0
	km_datalen	MISSIONXRAM

;* 7f ram (obj animation buffer) *
;objchart		equ	cockpitcgx_buf		;(yajima    2000h byte using :mission map)
mmxx_screenbuffer	equ	cockpitcgx_buf		;(kawaguchi 1000h byte using :mission map)
BGcheckBuffer	equ	(cockpitcgx_buf+$800)	;$400 length


swapsprstNo	equ	$80
swapsprkazu	equ	4
swapsprlen	equ	swapsprkazu*16*32
swapsprvram	equ	_obj_cgx+swapsprstNo*16

SwapCGXBuffer1	equ	(cockpitcgx_buf+$1000)
SwapCGXBuffer2	equ	(cockpitcgx_buf+$1000+swapsprlen)

;**** Screen kakikae data (no Att) buffer (800h byte) ****
;BG2 wa 04 chr/line :tensou
mm_scrdatabg2start	equ	$17*32*2	:start address (Y = $17)
mm_scrbufbg2start	equ	$17*32*2	:start address (Y = $17)
mm_scrbg2len		equ	4*32*2		;(4 char Line)
mm_bitmapbg2start	equ	mm_scrdatabg2start
mm_scrbg2souraddr	equ	mmxx_screenbuffer+mm_scrbufbg2start
mm_vmbg2start	equ	mm_scrdatabg2start/2
mm_vmscrbg2addr	equ	mm_bg2_scr+mm_vmbg2start
mm_vmscrbufbg2len	equ	mm_scrbg2len

;---------------------------------------------------------------------
;*			Battle Field Select			*
;---------------------------------------------------------------------
;**** battle field select ****
rarwingmvx	equ	kxwork+0	;1 byte	:idou ryo (x)
rarwingmvy	equ	kxwork+1	;1 byte	:idou ryo (y)
rarwingx	equ	kxwork+2	;1 byte :base zahyou (x)
rarwingy	equ	kxwork+3	;1 byte :base zahyou (y)
rarwinghosx	equ	kxwork+4	;1 byte :zahyou hosei (x)
rarwinghosy	equ	kxwork+5	;1 byte :zahyou hosei (y)

rarwingmvptr	equ	kxwork+6	;1 byte :idou pattern pointer
rarwingmvtm	equ	kxwork+7	;1 byte :idou timer
boostanmfl	equ	kxwork+8	;1 byte :boost animation pointer

rarwingptr	equ	kxwork+10	;1 byte :idou pattern pointer
rarwingtm	equ	kxwork+11	;1 byte :idou pattern pointer

rarwingbase1	equ	kxwork+12	;2 byte :arwing base character 1
rarwingbase2	equ	kxwork+14	;2 byte :arwing base character 2
rarwinganmfl	equ	kxwork+16	;1 byte :hi (timer),low(anime pointer)

;---------------------------------------------------------------------
;** Battle field select temporary parameter
rarwingx1	equ	kxswork+0	;1 byte
rarwingy1	equ	kxswork+1	;1 byte
rarwingptr1	equ	kxswork+2	;1 byte
rarwingmvtm1	equ	kxswork+3	;1 byte

rarwingx2	equ	kxswork+4	;1 byte
rarwingy2	equ	kxswork+5	;1 byte
rarwingptr2	equ	kxswork+6	;1 byte
rarwingmvtm2	equ	kxswork+7	;1 byte

bfs_cursortm	equ	kxswork+8	;1 byte

bfs_OKflag	equ	kxswork+9	;1 byte
bfs_okanmtm	equ	kxswork+10	;1 byte
bfs_okanmptr	equ	kxswork+11	;1 byte


;---------------------------------------------------------------------
;*			Battle  Player Select			*
;*			Mission Player Select			*
;---------------------------------------------------------------------
;(kw_swork :32 byte)
	km_worklabelstart	kw_swork
	km_worklabel	W,mpw_misplayerflag	; 2 byte
	km_worklabel	W,mpw_keyflag		; 2 byte

mpkf_pushAB		equ	%01000000
mpkf_pushXY		equ	%10000000	
;**** battle player select *****
	km_worklabelstart	kxwork

 km_worklabel B,bps_ksproffx		;1 byte :zahyou no kari set X
 km_worklabel B,bps_ksproffy		;1 byte :zahyou no kari set Y
 km_worklabel B,bps_ksprchr		;1 byte :character no kari set

;* cursor *
 km_worklabel B,bps_OKflag		;1 byte	;OK flag
; [bfs_OKflag]
;fbfs_OKptrmax	equ	%00000111	;field select pointer check val
;fbfs_OKInitptr	equ	%00000000	;spr init
;fbfs_OKanmptr	equ	%00000001	;spr Ok anime display
;fbfs_OKflashptr	equ	%00000010	;spr OK flash
;fbfs_OKcancelptr	equ	%00000011	;spr OK disp cancell
;fbfs_ok		equ	%00001000	;field select OK? flag
;fbfs_selEND		equ	%00010000	;field select ALL OK flag
;fbfs_cancel		equ	%00100000	;field select Cancel flag
;fbfs_buttondisable	equ	%01000000	;button read disable flag
;fbfs_keydisable	equ	%10000000	;key read disable flag

;* Pilot *
 km_worklabel B,bps_pilotmovptr	;1 byte :pilot 
 km_worklabel B,bps_pilotoffx 	;1 byte ;pilot offset X postion
 km_worklabel B,bps_pilotoffy 	;1 byte ;pilot offset Y postion

;* arwing *
 km_worklabel B,bps_arwingoffx 	;1 byte ;arwing offset X postion
 km_worklabel B,bps_arwingoffy 	;1 byte ;arwing offset Y postion
 km_worklabel B,bps_arwingvelxptr	;1 byte :
 km_worklabel B,bps_arwingvelyptr	;1 byte :
 km_worklabel B,bps_arwingvelX	;1 byte :arwing Velocity X
 km_worklabel B,bps_arwingvelY	;1 byte :arwing Velocity X

;* boost *
 km_worklabel B,bps_boostptr		;1 byte :boost animation pointer,timer
 km_worklabel B,bps_boostoffx	;1 byte :boost X zahyo
 km_worklabel B,bps_boostoffy	;1 byte :boost Y zahyo

;* CHECK *
 km_workvalcheck  48
;-------------------------------------------
	km_worklabelstart	kxswork
 km_worklabel B,bps_cursortm		;1 byte	;cursor anm timer
 km_worklabel B,bps_keyptrbk		;1 byte :pl1 cursor back pointer

;==== player 1 ====
;* cursor *
 km_worklabel B,bps_keyptr1		;1 byte	;pl1 cursor pointer
 km_worklabel B,bps_OKflag1		;1 byte ;pl1 OK flag
;* Pilot *
 km_worklabel B,bps_pilot1movptr	;1 byte :pilot move ptr  (pl1)
 km_worklabel B,bps_pilot1offx	;1 byte :pilot postion X (pl1)
 km_worklabel B,bps_pilot1offy	;1 byte :pilot postion Y (pl1)

;* arwing *
 km_worklabel B,bps_arwing1offx	;1 byte ;arwing offset X postion
 km_worklabel B,bps_arwing1offy	;1 byte ;arwing offset Y postion
 km_worklabel B,bps_arwing1velxptr	;1 byte :
 km_worklabel B,bps_arwing1velyptr	;1 byte :
 km_worklabel B,bps_arwing1velX	;1 byte :arwing Velocity X
 km_worklabel B,bps_arwing1velY	;1 byte :arwing Velocity Y

;* boost *
 km_worklabel B,bps_boost1ptr	;1 byte :boost animation pointer,timer
 km_worklabel B,bps_boost1offx	;1 byte :boost X zahyo
 km_worklabel B,bps_boost1offy	;1 byte :boost Y zahyo

;==== player 2 ====
;* cursor *
 km_worklabel B,bps_keyptr2		;1 byte	;pl2 cursor pointer
 km_worklabel B,bps_OKflag2		;1 byte ;pl2 OK flag
;* Pilot *
 km_worklabel B,bps_pilot2offx	;1 byte :pilot postion X (pl2)
 km_worklabel B,bps_pilot2offy	;1 byte :pilot postion Y (pl2)
 km_worklabel B,bps_pilot2movptr	;1 byte :pilot move ptr  (pl2)
;* arwing *
 km_worklabel B,bps_arwing2offx 	;1 byte ;arwing offset X postion
 km_worklabel B,bps_arwing2offy 	;1 byte ;arwing offset Y postion
 km_worklabel B,bps_arwing2velxptr	;1 byte :
 km_worklabel B,bps_arwing2velyptr	;1 byte :
 km_worklabel B,bps_arwing2velX	;1 byte :arwing Velocity X
 km_worklabel B,bps_arwing2velY	;1 byte :arwing Velocity Y
;* boost *
 km_worklabel B,bps_boost2ptr	;1 byte :boost animation pointer,timer
 km_worklabel B,bps_boost2offx	;1 byte :boost X zahyo
 km_worklabel B,bps_boost2offy	;1 byte :boost Y zahyo

	km_workvalcheck  48

;---------------------------------------------------------------------
;*			Type Select (Training)			*
;---------------------------------------------------------------------
	xalc	tsx_keytateflag,1		;1 byte

	km_worklabelstart	kxwork
	km_worklabel	B,tsx_keyyokoptr	;1 byte
	km_worklabel	B,tsx_keytateptr	;1 byte

	km_worklabel	B,tsx_wakubaseX		;1 byte
	km_worklabel	B,tsx_wakubaseY		;1 byte
	km_worklabel	B,tsx_wakuposX		;1 byte
	km_worklabel	B,tsx_wakuposY		;1 byte

	km_worklabel	B,tsx_aiconposX		;1 byte
	km_worklabel	B,tsx_aiconposY		;1 byte

;---------------------------------------------------------------------
;*			MainGame				*
;---------------------------------------------------------------------
	xalc	kx_radarscale,2
	xalc	kx_radarmax,2
	xalc	kx_radarmin,2

	km_worklabelstart	kw_swork
	km_worklabel	W,mew_ketteiflag	; 2 byte
	km_worklabel	W,kspriteflag		; 2 byte
	km_workvalcheck  32

	km_gmflagstart	sf
sf_all	equ	-1
	km_gmflag	corneriaflash


;scaling :(kx_radarscale)
;-4 ... 1 dot =   32
;-2 ... 1 dot =   64
;-1 ... 1 dot =  128
; 0 ... 1 dot =  256
;+1 ... 1 dot =  512
;+2 ... 1 dot = 1024 :!!!! Can't Use !!!!! Too Big !
;+4 ... 1 dot = 2048 :!!!! Can't Use !!!!! Too Big !
;************* Main GAME Sprites *************
	km_worklabelstart	kxwork
	km_worklabel	W,p1x		;2 byte	;player 1 x postion
	km_worklabel	W,p1y		;2 byte	;player 1 y postion
	km_worklabel	W,p1z		;2 byte	;player 1 z postion
	km_worklabel	W,p2x		;2 byte	;player 2 x postion
	km_worklabel	W,p2y		;2 byte	;player 2 y postion
	km_worklabel	W,p2z		;2 byte	;player 2 z postion

;**** Sprites Cockpit temporary parameter (sprites.asm)
	km_worklabel	W,kpx		;2 byte :Player World X
	km_worklabel	W,kpy		;2 byte :Player World Y
	km_worklabel	W,kpz		;2 byte :Player World Z
	km_worklabel	W,kroty		;1 byte :player angle Y
	km_worklabel	B,ksproffx	;1 byte :sprite (radar,screen) offset x
	km_worklabel	B,ksproffy	;1 byte :sprite (radar,screen) offset y
	km_worklabel	B,ktargetx	;1 byte :sprite syoujyun offset x
	km_worklabel	B,ktargety	;1 byte :sprite syoujyun offset y
	km_worklabel	B,kareaminX	;2 byte :
	km_worklabel	B,kareamaxX	;2 byte :
	km_worklabel	B,kareaminZ	;2 byte :
	km_worklabel	B,kareamaxZ	;2 byte :
; BG Cockpit temporary parameter (kscreen.asm)
	km_worklabel	B,kwindowoffx	;1 byte :Mario CGX offset
	km_worklabel	W,kclipsx	;2 byte :Circle Window Clip SX
	km_worklabel	W,kclipex	;2 byte :Circle Window Clip EX
	km_worklabel	W,kclipsy	;2 byte :Circle Window Clip SY

	km_workvalcheck  48

;**** GAME Main Sprites ****
	km_worklabelstart	kxswork
;* (windows.asm) *
;	km_worklabel	B,kx_wm_w12swl		; 1byte
;	km_worklabel	B,kx_wm_w34swl		; 1byte
;	km_worklabel	B,kx_wm_wobjsel		; 1byte
;	km_worklabel	B,kx_wm_wbglog		; 1byte
;	km_worklabel	B,kx_wm_ts		; 1byte
;	km_worklabel	B,kx_wm_cgswsel		; 1byte
;	km_worklabel	B,kx_wm_cgadsub		; 1byte
;	km_worklabel	B,kx_wm_coldata		; 1byte
;	km_worklabel	B,kx_wm_coldata_r	; 1byte
;	km_worklabel	B,kx_wm_coldata_g	; 1byte
;	km_worklabel	B,kx_wm_coldata_b	; 1byte
;	km_worklabel	B,kx_wm_chparams	; 1byte
;	km_worklabel	W,kx_wm_hdam		; 2byte
;	km_worklabel	B,kx_wm_hdam_bank	; 1byte
;	km_worklabel	B,kx_wm_val		; 1byte
;	km_worklabel	B,kx_wm_flags		; 1byte


	km_worklabel	B,kmapptr	;1 byte
	km_worklabel	W,kmapoffx	;2 byte
	km_worklabel	W,kmapoffz	;2 byte
	km_worklabel	B,kp1mapptr	;1 byte
	km_worklabel	W,kp1mapoffx	;2 byte
	km_worklabel	W,kp1mapoffz	;2 byte
	km_worklabel	B,kp2mapptr	;1 byte
	km_worklabel	W,kp2mapoffx	;2 byte
	km_worklabel	W,kp2mapoffz	;2 byte
	km_worklabel	W,msx_CorneriaDispTm	;2 byte
	km_worklabel	W,msx_ExplodeDispTm	;2 byte
	km_workvalcheck  48
;----------------------------------------------------------------------------
	IFEQ	1
; soft ware sprite temporary parameter
kswsoffcx	equ	kxwork+0	;2 byte :Soft Ware Sprite Pos CX
kswsoffcy	equ	kxwork+2	;2 byte :Soft Ware Sprite Pos CY
ksprname	equ	kxwork+4	;2 byte :Soft Ware Sprite Name
kswspointer	equ	kxwork+6	;2 byte :Soft Ware Sprite (x,y) Pointer
	ENDC
;----------------------------------------------------------------------
;*			Training				*
;----------------------------------------------------------------------
	km_worklabelstart	kw_swork
	km_worklabel	W,trw_swapbg2	; 2 byte

;---------------------------------------------------------------------
;*			Config Mode				*
;---------------------------------------------------------------------
;** CONFIG MODE **
conf_flag	equ	kxswork+0	;1 byte
conf_bgm	equ	kxswork+1	;1 byte
conf_se	equ	kxswork+2	;1 byte
conf_port0	equ	kxswork+3	;1 byte
conf_port1	equ	kxswork+4	;1 byte
conf_port2	equ	kxswork+5	;1 byte

	defflaglist	conf
	defflag		exit

;=====================================================
;*		PAD WORK	[18 byte]	*
;=====================================================
	alc	keywork,18
keyworkstart	equ	keywork+0
keyworkend	equ	keywork+17
;-----------------------------------------------------
;********** Temporary Key Check ***********
	km_worklabelstart	keywork
	km_worklabel	B,key_yokoptr1		;1 byte
	km_worklabel	B,key_tateptr1		;1 byte
	km_worklabel	B,key_yokotm1		;1 byte
	km_worklabel	B,key_tatetm1		;1 byte
	km_worklabel	B,key_yokomaxptr1	;1 byte
	km_worklabel	B,key_tatemaxptr1	;1 byte

	km_worklabel	B,keyptr	;1 byte
	km_worklabel	B,keyptrbk	;1 byte
	km_worklabel	B,keymaxptr	;1 byte
	km_worklabel	B,keyflag	;1 byte
	km_worklabel	W,keystates	;2 byte ;temp current key states
	km_worklabel	B,autotrig	;1 byte	;temp key states + trigger flag
	km_worklabel	B,autokeytm	;1 byte	;temp trigger key wait timer
	km_worklabel	B,autotrig0	;1 byte	;cont1 key states + trigger flag
	km_worklabel	B,autokeytm1	;1 byte	;cont1 trigger key wait timer
	km_worklabel	B,autotrig1	;1 byte	;cont2 key states + trigger flag
	km_worklabel	B,autokeytm2	;1 byte	;cont2 trigger key wait timer
	km_workvalcheck  18
;------------------------------------------------------------------------------------
;***** Mission Map ******
	km_worklabelstart	keywork
	km_worklabel	W,mmw_keydown
	km_worklabel	W,mmw_trigger
	km_workvalcheck  18
;------------------------------------------------------------------------------------
;* key flags *
	defflaglist	key		; current screen mode
	defflag		push
	defflag		disable
;=====================================================
;*	Macro Temporary Work	[8 byte]	*
;=====================================================
;kono work ha macro nai dakeshika tukau kotogadekinai.
	alc	kmwork,8	;Macro Work
kmbyte1	equ	kmwork+0	;1
kmbyte2	equ	kmwork+1	;1
kmword	equ	kmwork+2	;2

;=====================================================
;*	IRQ TEMPORARY WORK RAM	[8 byte]	*
;=====================================================
;kono work ha IRQ naideshika tukaukotoga dekinai.
	alc	iwork,8		;IRQ WORK RAM
;-----------------------------------------------------
isyou	equ	iwork+0
iamari	equ	iwork+2
;-----------------------------------------------------
kw_imoto	equ	iwork+0		; 2 byte
kw_isaki	equ	iwork+2		; 2 byte

;=====================================================
;*	Calculate parameter	[8 byte]	*
;=====================================================
	alc	kcalc,8
;---- division ----
ksyou	equ	kcalc+0		;2 byte
kamari	equ	kcalc+2		;2 byte
;---- mult -----
kseki	equ	kcalc+0		;2 byte
;--- normalse ---
kvecx	equ	kcalc+0		;2 byte
kvecy	equ	kcalc+2		;2 byte
kvecz	equ	kcalc+4		;2 byte
;---
kangle	equ	kcalc+0

;*********************************************************************
;*			7E Bank RAM	[XALC]			*
;*								*
;*********************************************************************
;=====================================================
;*	Sprites Parameters & Buffer 		*
;=====================================================
	alc	sprpointer,2 	;2 byte :sprites data pointer
	xalc	sprkazu,2	;2 byte :sprite no kazu
	xalc	sprdispwait,1	;2 byte :sprites display wait (mission)
	xalc	sprrdpri,2	;2 byte :sprites priority syusei
	xalc	kx_sproff,2	;2 byte :sprites character offset
	xalc	kx_sprdouble,2	;2 byte :sprites double buffer hosei work
	xalc	kx_sprsizeptr,2	;2 byte :sprite size set pointer
;---------- Sprites Data Buffer -------------
	xalc	sprites,((128*4)+(128/4))*2
sprbuf2offs	equ	(128*4)+(128/4)
spritebuf1	equ	sprites
spritebuf2	equ	sprites+sprbuf2offs
sprites_sub	equ	spritebuf1+128*4
sprites_sub2	equ	spritebuf2+128*4
;---------------------------------------------------------------------
	xalc	kx_blockanmptr,2
	xalc	kx_blockanmtm,2

	IFEQ	1
	xalc	kx_blkanmlistptr,2
	xalc	kx_blkanmfreeptr,2
	km_worklabelstart	0
	km_worklabel	w,kx_blkanmnext	; 2 byte
	km_worklabel	w,kx_blkanmprev	; 2 byte
	km_worklabel	w,kx_blkanmptr	; 2 byte
	km_worklabel	w,kx_blkanminit	; 2 byte
	km_worklabel	w,kx_blkanmtm	; 2 byte
	km_worklabel	w,kx_blkanmcx	; 2 byte
	km_worklabel	w,kx_blkanmcy	; 2 byte
	km_worklabellen	blkanmlen	; length

blkanmkazu	equ	8
	xalc	kx_blkanmlist,blkanmlen*blkanmkazu
	ENDC
;=====================================================================
;=====================================================================
;*			SPECIAL	RAM				*
;=====================================================================
;=====================================================================
;=====================================================
;*		CPU & PPU register		*
;=====================================================
;--- irq h,v timer ---
	alc	kw_vtimel,2
	alc	kw_vtimestart,2
	alc	kw_vtimeend,2
;--- col add ---
	xalc	kx_coladdflag,1
;--- through main ---
	alc	kw_tm,1
	alc	kw_tmptm,1
	alc	kw_tmbackup,1
;--- screen base ----
	alc	kw_bg2sc,2
	alc	kw_bg3sc,1
;---- cgx base ----
	alc	kw_bg12nba,1
;--- screenfade ----
	alc	kw_screenfade,1		;b7 (screen fade flag)
	xalc	kx_screenfadetm,1
	alc	kw_fadetm,1
	alc	kw_fadetmcmp,1
;--- mozaiku ----
	xalc	kx_mozaikutimer,1
	alc	kw_mozaikuflag,1	;b7 (mozaiku:on/off),b0~b3( bg select)
	alc	kw_mozaikunumber,1	;b4~b7 (mozaiku size)

;=====================================================
;*		DMA parameters			*
;=====================================================
	alc	kw_dmacnt,1	;dma counter
	alc	kw_dmatm,1	;dma timer

	alc	kw_dmasaddr,2	;source address
	alc	kw_dmasbnk,1	;source bank

	alc	kw_dmadaddr,2	;dest address
	alc	kw_dmadbnk,1	;dest address

	alc	kw_dmalength,2	;data lenght

;*********************************************************************
;*								*
;*			HDMA Parameter				*
;*								*
;*********************************************************************
;=====================================================================
;*			Window RAM				*
;=====================================================================
;***** window flag ******
	alc	kw_windowflag,2
kwinf_all	equ	-1
	defflaglist	kwinf		;kmimpf_{pointer}
	defflag	windowwbuf	;0/1 ... buf1 trans(buf2 write) / buf2 trans (buf1 write)
	defflag	wipeopen	;0/1 ... finish wipe / wipe open tyuu
	defflag	wipeclose	;0/1 ... finish wipe / wipe close tyuu
	defflag	normalwipe	;0/1 ... 1p,2p wipe / normal wipe
	defflag	init		;0/1 ... no initial / initial shita 
	defflag	fade		;0/1 ... no fade / fade on

;;	defflag	circle		;0/1 ... 

	xalc	KwindowTm,1
	alc	kw_blackfadestep,1
;***** find window prio ****
	alc	kw_findwindpri,2
;***** Window tables *****
	alc	kw_windowmode,2
	alc	kw_wipetimer,2
;=== window structure buffer ===
	alc	kw_windowstructP1_buf1,wm_sizeof
	alc	kw_windowstructP2_buf1,wm_sizeof
	alc	kw_windowstructP1_buf2,wm_sizeof
	alc	kw_windowstructP2_buf2,wm_sizeof
;=== BOM window buffer ===
;--- cilcel window ----
;	xalc	kx_circlewindowmode,2
;	xalc	kx_circleCX,2	;2 byte :Circle Window X zahyo
;	xalc	kx_circleCY,2	;2 byte :Circle Window Y zahyo
;	xalc	kx_circleTR,2	;2 byte :Circle Window Radius
;	xalc	kx_circleR,1	;1 byte :Circle Window Radius
;	xalc	kx_circlestep,1	;1 byte :circle Radius Step
;	xalc	kx_circlefade,1	;1 byte :circle Radius Step
;	xalc	kx_circlecolR,1	;1 byte :cilcle window colour Red
;	xalc	kx_circlecolG,1	;1 byte :cilcle window colour Green
;	xalc	kx_circlecolB,1	;1 byte :cilcle window colour Blue

	km_gmlabelstart	winm,0
	km_gmlabel	nothing,2
	km_gmlabel	open,2
	km_gmlabel	cilcle,2
	km_gmlabel	close,2
	km_gmlabel	off,2

	xalc	xhdma_circhofstmp,0
	km_labelstart	xhdma_circhofstmp
	km_label	xhdma_circhofsp1_buf1,bitmapvheight*8*2
	km_label	xhdma_circhofsp2_buf1,bitmapvheight*8*2
	km_label	xhdma_circhofsp1_buf2,bitmapvheight*8*2
	km_label	xhdma_circhofsp2_buf2,bitmapvheight*8*2
	km_labellen	circbuflen
	xalc	xhdma_circhofs,circbuflen

;=== Hit Flash Window Buffer ===
	xalc	xhdma_htflhofstmp,0
	km_labelstart	xhdma_htflhofstmp
	km_label	xhdma_htflhofsp1_buf1,2
	km_label	xhdma_htflhofsp2_buf1,2
	km_label	xhdma_htflhofsp1_buf2,2
	km_label	xhdma_htflhofsp2_buf2,2
	km_labellen	htflbuflen
	xalc	xhdma_htflhofs,htflbuflen

;=== Pause Window Buffer ===
	xalc	xhdma_pausehofstmp,0
	km_labelstart	xhdma_pausehofstmp
	km_label	xhdma_pausehofsp1_buf1,2
	km_label	xhdma_pausehofsp2_buf1,2
	km_label	xhdma_pausehofsp1_buf2,2
	km_label	xhdma_pausehofsp2_buf2,2
	km_labellen	pausebuflen
	xalc	xhdma_pausehofs,pausebuflen

;=== Area Out Window Buffer ===
	xalc	xhdma_outhofstmp,0

	km_label	xhdma_outhofsp1_buf1,2
	km_label	xhdma_outhofsp2_buf1,2
	km_label	xhdma_outhofsp1_buf2,2
	km_label	xhdma_outhofsp2_buf2,2
	km_labellen	outbuflen
	xalc		xhdma_outhofs,outbuflen

;* H-DMA Table Window On ,Off data RAM***
	xalc	hdmawindowon,4
	xalc	hdmawindowoff,4
;=====================================================================
;*			H-V Scroll RAM				*
;=====================================================================
;***** (HVScroll) H-DMA Table Address *****
	alc	kw_scrollflag,2
khvsf_all	equ	-1
	defflaglist	khvsf		;khvsf_{flag}
	defflag	hvscroll	;0/1 ... no scroll / scroll
	defflag	hdmascroll	;0/1 ... normal h,V scroll / hdma H,V scroll
	defflag	hvscrollwbuf	;0/1 ... buf1 trans(buf2 write) / buf2 trans (buf1 write)
	defflag	raster		;0/1 ... raster off/on

	alc	kw_rastermode,1
	km_labelstart
	km_label	krsf_noraster	;0
	km_label	krsf_marine	;1
	km_label	krsf_corona	;2

;* For mission & battle player select *
;--- scroll ---
	alc	kw_bg1hofs,2
	alc	kw_bg1vofs,2
	alc	kw_bg2hofs,2
	alc	kw_bg2vofs,2
	alc	kw_bg3hofs,2
	alc	kw_bg3vofs,2
	xalc	kx_bg3hofstm,1	;timer

	xalc	kx_hscrollp1,2
	xalc	kx_vscrollp1,2
	xalc	kx_hscrollp2,2
	xalc	kx_vscrollp2,2

;* kawaguchi test :raster scroll data set pointer *
	xxalc	xxpointer,2
	xxalc	khscrollptr,2	
	xxalc	kvscrollptr,2	
	xxalc	kseascrollptr,2
	xxalc	kseascroll,2

;*** H scroll ***
	alc	kw_hdma_hscraddr1,2
	alc	kw_hdma_hscrflag1,1
	alc	kw_hdma_hscraddr2,2
	alc	kw_hdma_hscrflag2,1
	defflaglist	khsf
	defflag		repeat		;1 ... repeat data

	xxalc	xh_hscrolltbl1,2
	xxalc	xh_vscrolltbl1,2
	xxalc	xh_hscrolltbl2,2
	xxalc	xh_vscrolltbl2,2
	xxalc	xh_yajiHtbl1_buf1,(bitmapvheight)*8*2
	xxalc	xh_yajiHtbl2_buf1,(bitmapvheight)*8*2
	xxalc	xh_yajiHtbl1_buf2,(bitmapvheight)*8*2
	xxalc	xh_yajiHtbl2_buf2,(bitmapvheight)*8*2

;*** V scroll ***
	alc	kw_hdma_vscraddr1,2
	alc	kw_hdma_vscrflag1,1
	alc	kw_hdma_vscraddr2,2
	alc	kw_hdma_vscrflag2,1
	defflaglist	kvsf
	defflag		repeat
	defflag		switch		;0/1 ... raster on

	xxalc	xh_yajiVtbl1_buf1,(bitmapvheight)*8*2
	xxalc	xh_yajiVtbl2_buf1,(bitmapvheight)*8*2
	xxalc	xh_yajiVtbl1_buf2,(bitmapvheight)*8*2
	xxalc	xh_yajiVtbl2_buf2,(bitmapvheight)*8*2
	xxalc	seavscroll_buf,19

;=====================================================
;*		CGX,Screen Transfer work	*
;=====================================================
	xalc	KCGSCTranssw,1 
	xalc	KCGSCTransTimer,1
	xalc	KCGSCTransPtr,1
	xalc	KCGXSCRTransVRAMAddr,2
	xalc	KCGXSCRTransVRAMBank,1
	xalc	KCGXSCRTransCPUAddr,2
	xalc	KCGXSCRTransCPUBank,1
	xalc	KCGXSCRTransVal,2

;=====================================================
;*		Path Data tmp work		*
;=====================================================
	xalc	kbyte1,1
	xalc	kbyte2,1
	xalc	kword1,2

;=====================================================
;*		Player Parameters		* 
;=====================================================
	xalc	KRadarFlag,1
;	P1radonFl	equ	1<<0
;	P1radmodeFl	equ	1<<1
;	P1radScChFl	equ	1<<2

;	P2radonFl	equ	1<<4
;	P2radmodeFl	equ	1<<5
;	P2radScChFl	equ	1<<6

;=====================================================
;*		Soft Ware Timer,Counter		*
;=====================================================
	xalc	ColFlPnt,2

	xalc	P1RingOutTm,1
	xalc	P2RingOutTm,1

	xalc	PushStartTm,1
;-----------------------------------------------------
;1 flame timer
	xalc	Bdectimer,3
	km_worklabelstart	Bdectimer
	km_worklabel	B,KDecTimer
	km_worklabel	B,SecondTimer
	km_worklabel	B,demoTimer
	km_worklabelend
	km_workvalcheck	3

;	km_worklabel	B,P1SecTm
;	km_worklabel	B,P2SecTm
;	km_worklabel	B,ColWinTimer
;	km_worklabel	B,FlashTimer	
;-----------------------------------------------------
	xalc	Binctimer,1
Binctmend	equ	Binctimer+1
;-----------------------------------------------------
	xalc	Wdectimer,2
Wdectmend	equ	Wdectimer+2
;-----------------------------------------------------
	xalc	Winctimer,2
Winctmend	equ	Winctimer+2
;-----------------------------------------------------
	xalc	kx_2frameTm,2	;0,1,0,1,...
	xalc	kx_4frameTm,2	;0,1,2,3,0,1,2,3,...
	xalc	kx_8frameTm,2	;0,1,2,3,4,5,6,7,0,1,...
	xalc	kx_16frameTm,2	;0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,0,1,...

	xalc	kx_2GframeTm,2	;2 frame oki ni INC
	xalc	kx_4GframeTm,2	;4 frame ni 1 kai INC
	xalc	kx_8GframeTm,2	;8 frame ni 1 kai INC
	xalc	kx_16GframeTm,2	;16 frame ni 1 kai INC
;-----------------------------------------------------
;* 94/4/15
;kono timer no seide ushirtono work wo kowashite ita
;=====================================================
;*	Color Change Parameter			*
;=====================================================
	xalc	kx_palette,512	;CG buffer
	xalc	kx_palette2,256	;colour palette tenkai RAM2
	xalc	kx_palette3,256	;colour palette tenkai RAM3
	xalc	kx_palette4,256	;colour palette tenkai RAM4
;------------------------------------------------------------------------
;* BG background *
	xalc	coltimer_2,1
	xalc	coltimermax_2,1
	xalc	colptr_2,2	;2 byte :color table pointer (step 32)
	xalc	coladr_2,3	;3 byte :color table address

	xalc	coltimer_3,1
	xalc	coltimermax_3,1
	xalc	colptr_3,2
	xalc	coladr_3,3

	xalc	coltimer_4,1
	xalc	coltimermax_4,1
	xalc	colptr_4,2
	xalc	coladr_4,3

;	xalc	RadarColChBuf,4*2
;Blcolbuf_0	equ	RadarColChBuf+$0c*2	;2 byte
;Recolbuf_0	equ	RadarColChBuf+$0d*2	;2 byte
;Yecolbuf_0	equ	RadarColChBuf+$0e*2	;2 byte
;Grcolbuf_0	equ	RadarColChBuf+$0f*2	;2 byte

;=====================================================
;*	Bit Map Character Transfer Buffer	*
;=====================================================
; (Source Address,Destinition Address)

	xalc	BmChrBuf,32
GmTmChrBuf	equ	BmChrBuf+0	;3*2*5
;-----------------------------------------------------
;=====================================================
;*		Sound Parameter			*
;=====================================================
;sound
	alc	kw_soundflag,1
ksf_all	equ	-1

	defflaglist	ksf	;ksf_{flag}
	defflag	allstop		;0/1 ... sound all stop (port 0,1,2,3)
	defflag	addrchange	;tensou address syuusei 0(shinai)/1(suru)
	defflag	translock	;0/1 ... normal / BGM transfer
	defflag	port2stop	;0/1 ... normal / port2 stop

	defflag	cannoncharge	;0/1 ... cannon charge sound off/on
	defflag	sndmode		;0/1 ... stero/monoral mode set

;* Sound Data tensou saki henkou address *
	alc	kw_sndhenkouaddr,2

;* Sound Tochyuu Tensou *
	alc	kw_soundtransaddr,3
	xalc	kx_soundchartptr,2
;* apu port 0 *
	alc	bgmcnt,1
	alc	bgm_music,4
	alc	bgm_music_back,1
	alc	bgm_musicptr,1
	alc	bgm_musicptr_limt,1

;	alc	bgm_back,1
	alc	bgm_place,2
	alc	bgm_placeback,2
;* apu port 1 *
	alc	sdport1,1

;* apu port 2 *
	alc	sdport2,1	;sound port 2
	alc	sdchkno2,1	;check sound No
	alc	sdchkptr2,2	;check alien pointer
	alc	sdchklen2,2	;check length

	alc	sdport2tmp,1	;tmp sound port 2
	alc	sdchkno2tmp,1	;tmp check sound No
	alc	sdchkptr2tmp,2	;tmp check alien pointer

	alc	sdbakport2,1	;back sound port 2
	alc	sdbakno2,1	;back sound No
	alc	sdbakptr2,2	;back alien pointer

	alc	sddist2,2	;distance check work
;* apu port 3 *
	alc	sdport3,32
	alc	sdspt3,2
	alc	sdgpt3,2
	alc	sdpck3,1

	alc	pausesnd,1
	alc	circleaff,1
	alc	firstdnld,1
	alc	monoral,1	;0/1 ... stereo / monoral


	ifeq	1
	alc	ktpx,2
	alc	ktpy,2
	alc	ktpz,2
	alc	playersndflag,1
	alc	lastplayx,2
	alc	lsnd,1
	alc	csnd,1
	alc	rsnd,1
	alc	msnd,1
	alc	fsnd,1
	alc	snd_ptr,2
	alc	lastblock,2
	endc

;*********************************************************************
;*								*
;*								*
;*********************************************************************

	alc	flashbg,1
	alc	fadetored,1
	alc	dogyirq,1
	alc	flashtunnelon,1
	alc	c_type,1
	alc	noirqbit3,1
	alc	pallen,2

;----- bg request flags
	alc	bgflags,1
bgf_restart	equ	1
bgf_foxy	equ	2
bgf_bg	equ	4
bgf_info	equ	8
bgf_text	equ	16

	alc	restartcol,1		;on level 3-3, 1=use sea, 2=use gnd

;----- end sequence vars
	alc	palfrom,2
	alc	palto,2
	alc	viewyoff,2
	alc	democnt,2
	alc	demoptr,2
	alc	bg3vofsbak,2
	alc	bg3hofsbak,2
	alc	bg2vofsbak,2
	alc	bg2hofsbak,2
	alc	bg1vofsbak,2
	alc	bg1hofsbak,2
	alc	bg3vofsreq,2
	alc	bg3hofsreq,2
	alc	bg2vofsreq,2
	alc	bg2hofsreq,2
	alc	bg1vofsreq,2
	alc	bg1hofsreq,2

;end sequence
	xalc	lrtw,4
	alc	noxrot,1

sprar_up	equ	1
sprar_down	equ	2
sprar_left	equ	4
sprar_right	equ	8
	alc	arrows,1
	alc	specflash,1
	alc	wintabptr,2
	alc	sprframe,2
	alc	onecredspr,1
	alc	doneacircle,1

	alc	nosetport3,1
	alc	doawipe,1
	alc	doingwipe,1


le_fadetowhite	equ	4
le_fadedown	equ	5
le_endofgame	equ	6
le_startgame	equ	7
le_endofcreds	equ	8
le_endtotalscore equ	9
le_gameover	equ	10
le_bhole1	equ	11
le_bhole2	equ	12
le_bhole3	equ	13
le_special	equ	14
le_enterbhole	equ	15
le_enterspec	equ	16

	alc	levelfinished,2

	alc	kcvposx,2
	alc	kcvposy,2
	alc	kcvposz,2

	alc	contsmart,1
	alc	nmitemp2,2
	alc	bg2vofsoverride,1
	xalc	hadabumhole,2
	xalc	contexit,2
	alc	prttraining,1
	alc	defaulttrain,1
	alc	numendok,1
	alc	port1bolox,1

rotate_hof	equ	0
tunnel1_hof	equ	2
tunnel2_hof	equ	4
water_hof	equ	6
tunnel3_hof	equ	8
nograd_hof	equ	10
bhole_hof	equ	12
bholescale_hof	equ	14
	alc	hposjmp,2
	xalc	bholescaleval,2


;=====================================================================
;*		Memory Alloc End				*
;=====================================================================

	alc	kw_end,0
	xalc	kx_end,0

;=====================================================================
;=====================================================================

