;ÉËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍË»
;ÌÎ»                                                       ÉÎ¹
;ºÈ¼                                                       È¼º
;º                                                           º
;º    KAWAGOE USIG WORK RAM AREA & STRUCTURES OF PLAYER      º
;º                                                           º
;ºÉ»                                                       É»º
;ÌÎ¼                                                       ÈÎ¹
;ÈÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊ¼

BOSSDEBUG	equ	1	;1:debug mode on

PLAYERHIT	equ	1

NOBATTLE	equ	1	;1:battle mode off

;--------------------------------------------------------------

demo_suisei			equ	0
demo_destruct_enemy		equ	1
demo_destruct_missile	equ	2
demo_scramble		equ	3
demo_armada			equ	4
demo_letsgo			equ	5
demo_title			equ	6
demo_logo			equ	7
demo_gameoverlogo		equ	8
demo_d_sen			equ	9
demo_enter_d_sen		equ	10
demo_chika			equ	11
demo_enter_chika		equ	12
demo_clear_d_sen		equ	13
demo_clear_chika		equ	14
demo_destruct_core		equ	15
demo_kaitei			equ	16
demo_enter_kaitei		equ	17
demo_start_chika		equ	18
demo_start_kaitei		equ	19
demo_start_d_sen		equ	20
demo_start_final		equ	21
demo_attack			equ	22
demo_attackback		equ	23
demo_endseq0			equ	24
demo_taiman			equ	25
demo_planetcanon		equ	26
demo_clear_kaitei		equ	27
demo_credits			equ	28
demo_starwolf		equ	29

demo_off			equ	254
demo_wait			equ	255
;--------------------------------------------------------------
; enemy SEtype(damage no toki)

ese_bs_cry_1	equ	1	;dragon
ese_en_cry_2	equ	2	;seibutsu small
ese_en_cry_3	equ	3	;seibutsu large
ese_en_core_dmg_big	equ	4	;core
ese_bs_andorf_damage	equ	5	;andorf
ese_en_dmg_2		equ	6	;?

rse_reboundlaser2	equ	1	;wolf

;--------------------------------------------------------------
; debug vars
	alc	testx,2
	alc	testy,2
	alc	testz,2

;--------------------------------------------------------------
	alc	slopeptrold,2
	alc	slopenumold,1
;--------------------------------------------------------------

	alc	demomode,1
	alc	demoNo,1
	alc	demoflag,1
	alc	demoNoNext,1
	alc	demoNoClear,1


demoflag_dustoff			equ	1<<7
demoflag_nextmap			equ	1<<6
demoflag_nextmap_gotodirector	equ	1<<5
demoflag_nextmap_off		equ	1<<4
demoflag_nextmap_start	equ	1<<3

demoflag_nextmap_trapped	equ	1<<2
demoflag_nextmap_trapped_on	equ	1<<1
demoflag_nextmap_inclevel	equ	1<<0

	alc	demomapbank,1
	alc	demomapptr,2

	alc	intermapbank,1
	alc	intermapptr,2

	alc	clearmapbank,1
	alc	clearmapptr,2

	alc	clearmapbg,2

	alc	clear_dustsprite,2	; star dust
	alc	clear_dustsize,2
	alc	clear_dustflags,2

	alc	corex,2	; position of core(for clear demo)
	alc	corey,2
	alc	corez,2
	alc	coreroty,1
	alc	coreENTERroty,1

	alc	p1_markptr,2

	alc	attackx,2	; game start demo
	alc	attacky,2
	alc	attackz,2
	alc	attackrnd,1

;--------------------------------------------------------------

	alc	demomsg,1
	alc	plrmsg,1

plrmsg_clear_chika	equ	1<<7
plrmsg_clear_d_sen	equ	1<<6

;--------------------------------------------------------------

	alc	calcbuf,2

	alc	voffsetflag,1

voffsetflag_p1off	equ	1<<7
voffsetflag_p2off	equ	1<<6

;--------------------------------------------------------------

	alc	chartptr,3
	alc	chartptr_inc,2
	alc	chartheapptr,2
	alc	charttimer,2

;--------------------------------------------------------------
; key buffer
	alc	p_pcont,2
	alc	p_ptrig,2

;--------------------------------------------------------------

;ÚÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂ¿
;ÃÙ                         À´
;³   --- Variable LIST ---   ³
;Ã¿                         Ú´
;ÀÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÙ

; slopes.asm no generaldynamics_l no gravity

	alc	gd_gravity,2
	alc	gd_off,1	;(0:gravity on 1:gravity off)

;ÚÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂ¿
;ÃÙ                    À´
;³   --- RAM LIST ---   ³
;Ã¿                    Ú´
;ÀÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÙ

	alc	twork,32	;work RAM

twork0	equ	twork+0
twork1	equ	twork+2
twork2	equ	twork+4
twork3	equ	twork+6
twork4	equ	twork+8
twork5	equ	twork+10
twork6	equ	twork+12
twork7	equ	twork+14
twork8	equ	twork+16
twork9	equ	twork+18
twork10	equ	twork+20
twork11	equ	twork+22
twork12	equ	twork+24
twork13	equ	twork+26
twork14	equ	twork+28
twork15	equ	twork+20

;;;	alc	debug,2

;ÚÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂ¿
;ÃÙ                       À´
;³   --- RAM for GAME---   ³
;Ã¿                       Ú´
;ÀÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÙ

	alc	PMODE,1

PMODE_CS_ARWING	equ	0
PMODE_OF_ARWING	equ	0
PMODE_ROBOT	equ	1
PMODE_ARMER	equ	1

	alc	player_controltype,1
	alc	player_controltypeABXY,1	; 0:default 1:starfoxI

player_controltype_1B	equ	1<<7
player_controltype_2B	equ	1<<6

;-------------------------------------------------------------------
; player status

	alc	p1_hp,1
	alc	p1_spweap_LMT,1
	alc	p1_spweap_type,1
	alc	p1_weap_level,1

	alc	P1_maxHP,1
	alc	P1_maxMETER,1

	alc	p2_hp,1
	alc	p2_spweap_LMT,1
	alc	p2_spweap_type,1
	alc	p2_weap_level,1

	alc	P2_maxHP,1
	alc	P2_maxMETER,1

	alc	p_tamehom,1


p_tamehom_p1	equ	1<<7
p_tamehom_p2	equ	1<<6

;-------------------------------------------------------------------
; for starwolf BGM

	alc	wolfsoundoff,1

;-------------------------------------------------------------------


	alc	shieldinit,1

;-------------------------------------------------------------------
; view change flag etc....

	alc	playerimportflag,1

pif_cockpit_on	equ	1<<7	; 0:normal  1:cockpit
pif_cockpit_off	equ	0	; 0:normal  1:cockpit
pif_cockpit_onRB	equ	1<<6	; 0:normal  1:cockpit
pif_cockpit_offRB	equ	0	; 0:normal  1:cockpit
pif_cockpit_trig	equ	1<<5	; trigger

	alc	playerexportflag,1

pef_viewchange_on	equ	1<<7

;-------------------------------------------------------------------

	alc	playerctlmode,1
	alc	playerinitmode,1

; initial mode flag

playerinitmode_ARWING	equ	0
playerinitmode_ROBOT	equ	1<<7
playerinitmode_UFO	equ	1<<7

;-------------------------------------------------------------------

	alc	p1_worldx_init,2
	alc	p1_worldy_init,2
	alc	p1_worldz_init,2
	alc	p1_roty_init,1

	alc	p2_worldx_init,2
	alc	p2_worldy_init,2
	alc	p2_worldz_init,2
	alc	p2_roty_init,1

;-------------------------------------------------------------------

	alc	p1_firerotx,1

;-------------------------------------------------------------------

	alc	e_worldx_init,2
	alc	e_worldz_init,2

;-------------------------------------------------------------------

	alc	p1_dist2enemy,2
	alc	p1_dist2cam,2

	alc	p1_vz2enemy,2

;ÚÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂ¿
;ÃÙ                        À´
;³   --- for Dummy ---      ³
;Ã¿                        Ú´
;ÀÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÙ

	alc	dummyptr,2

;ÚÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂ¿
;ÃÙ                         À´
;³   --- for Demo ---        ³
;Ã¿                         Ú´
;ÀÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÙ

	alc	demoshapeptr,2

	alc	clrdemoshape_x,2
	alc	clrdemoshape_y,2
	alc	clrdemoshape_z,2

;ÚÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂ¿
;ÃÙ                         À´
;³   --- PLANET CANNON ---   ³
;Ã¿                         Ú´
;ÀÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÙ

	alc	Pcannon_charge,1

;ÚÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂ¿
;ÃÙ                     À´
;³   --- STAR WOLF ---   ³
;Ã¿                     Ú´
;ÀÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÙ

	alc	starwolf_demo,1

starwolf_demo_on		equ	1<<7
starwolf_demo_director	equ	1<<6

	alc	starwolfNo,1

swn_WOLF	equ	0
swn_LEON	equ	1
swn_PIGMA	equ	2
swn_ANDREW	equ	3

;ÚÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂ¿
;ÃÙ                                      À´
;³   --- ENEMY MARKER(Mission mode) ---   ³
;Ã¿                                      Ú´
;ÀÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÙ

	alc	p1_markstatus,1

p1_markstatus_on	equ	1<<7

;ÚÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂ¿
;ÃÙ                               À´
;³   --- RAM for PLAYER STRAT---   ³
;Ã¿                               Ú´
;ÀÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÙ
;-- voffset --

	alc	p1_camrotzbuf,2

;player status

	alc	p1_status,1
	alc	p2_status,1

p1_status_HP0	equ	1<<0
p1_status_gameend	equ	1<<1
p1_status_win	equ	1<<2
p1_status_battleend	equ	1<<3
p1_status_bom	equ	1<<4

p2_status_HP0	equ	1<<0
p2_status_gameend	equ	1<<1
p2_status_win	equ	1<<2
p2_status_battleend	equ	1<<3

; -- depth of sea --

	alc	seadepth,2	;(set plus value)

; -- ground dot <--> startdust no kirikae no takasa ---

	alc	stardustheight,2

	alc	seatype,1	; st_{name}

; -- planet code(ground or space or marine? see var flag list) --

;	alc	planet_mode,1

planet_mode_ALL	equ	%00000111
pm_space		equ	0
pm_ground		equ	1
pm_marine		equ	2

	alc	p1_PILOTNo,1
	alc	p2_PILOTNo,1

; BOSS mode status

	alc	BOSSstatus,1

BOSSstatus_on	equ	1<<7	; BOSS MODE on
BOSSstatus_dead	equ	1<<5	; boss dead flag

	alc	andorfDEAD,1

	;;;alc	plrseqflag,1

;-- attack target test --

	alc	bossptr,2	; test alien pointer of BOSS



;-- ROBO walk  --

	alc	p1_legflag,1

	alc	player1_hpadd,1
;	alc	player2_hpadd,1

;	alc	player1_worldx,2
;	alc	player1_worldy,2
;	alc	player1_worldz,2

;	alc	player2_worldx,2
;	alc	player2_worldy,2
;	alc	player2_worldz,2

	alc	player1_vx,2
	alc	player1_vy,2
	alc	player1_vz,2

;	alc	player2_vx,2
;	alc	player2_vy,2
;	alc	player2_vz,2

	alc	name,2

	alc	playhpt1,2
	alc	playhpt2,2

	alc	p1_shapeNo,1
;	alc	p2_shapeNo,1

	alc	player_mode,2

	alc	Ktmp,2
	alc	Ktmp2,2

; for player

; for player's headup display

;	alc	p1_hudrot,2
;	alc	p2_hudrot,2
;	alc	p1_hudflag,1
;	alc	p2_hudflag,1

	alc	displayflag,1

displayflag_on	equ	1<<7


; for player's target scope(strange!)

	alc	p1_TargetX,1
	alc	p1_TargetY,1
;	alc	p2_TargetX,1
;	alc	p2_TargetY,1

;	alc	TargetX_flag,1
;TargetX_flag_p1on	equ	%00000001
;TargetX_flag_p2on	equ	%00000010


; for AREA of BATTLE

	alc	BATTLEAREA_maxY,2
	alc	BATTLEAREA_minY,2

; for view
	alc	inc_rotx,2
	alc	inc_roty,2
	alc	inc_rotz,2

	alc	player1_horizon,2
	alc	player2_horizon,2
	alc	player1_horizon_Wofs,2
	alc	player2_horizon_Wofs,2


	alc	player1_horizon_offset,2
	alc	player2_horizon_offset,2
	alc	player1_horizonbak,2
	alc	player2_horizonbak,2

; for hv scroll

	alc	player1hscroll_buf,2
;	alc	player2hscroll_buf,2
	alc	player1hscroll_offset,2
	alc	player2hscroll_offset,2

	alc	player1vscroll_offset,2
;	alc	player2vscroll_offset,2
	alc	vscrollofsrate,2
	alc	vscrollofsmax,2


	alc	plrcolflag,1

plrcolflag_transoff	equ	1<<7


	alc	bombexplode,1

; for altmeter_rate

	alc	altmeterrate,2

pX_spweap_LMT_init	equ	5	;saisyo no kazu (max15)
pX_spweap_LMT_num	equ	9	;special weapon no saidai no kazu (max15)
pX_spweap_LMT_PNTmax	equ	3	;ichido ni sonzai dekiru kazu(max15)

pX_spweap_LMT_LMT	equ	%00001111	;DONOT CHANGE! special weapon no kazu no MASK
pX_spweap_LMT_PNT	equ	%11110000	;DONOT CHANGE! special weapon no pointer no MASK

pX_missile_LMT_num	equ	%111	; max 3
pX_dummy_LMT_num	equ	%11	; max 3
p1_missile_LMT_alive	equ	1<<7
p2_missile_LMT_alive	equ	1<<7



;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;-----------------------------------------------------------------------------
;ÚÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂ¿
;ÃÙ                          À´
;³ --- ARWING'S STRUCTURE --- ³
;Ã¿                          Ú´
;ÀÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÙ

	structure	heap

	struct	exal_start,0

; --- force way trap

	struct	exal_noturn_trap,1

; --- noturn mode no "X" no limitter

	struct	exal_noturnxofsmax,2
	struct	exal_noturnxcnt,2	; center

; --- enter mode ---

	struct	exal_enterposx,2
	struct	exal_enterposy,2
	struct	exal_enterposz,2
	struct	exal_enterwidth,2

; --- to check jmp max ---

	struct	exal_jmpHIGH,2

; --- for push obj(ARMER) ---

	struct	exal_hit_framecount,1

; --- for BGM trigger ---

	struct	exal_BGM,1

; --- for transform ---

	struct	exal_transflag,1

; --- for boyoyon(ROBOT) ---

	struct	exal_vyboyoyonY,2
	struct	exal_vyold,2
	struct	exal_vydiv,2
	struct	exal_vyphase,1

	struct	exal_bodyofsy,1
	struct	exal_bodyfloatofsy,1
	struct	exal_bodyofsymotion,1

; --- (robot's) depth of pool ---

	struct	exal_pooldepth,2
	struct	exal_poolofsy,1
	struct	exal_poolptr,2
	struct	exal_pooltype,1

; --- dushcounter ---

	struct	exal_dushcounter,1
	struct	exal_dushkeybuffer,1

; --- heal effect ---

	struct	exal_healeffect_timer,1

; --- magma damage timer ---

	struct	exal_magmadmg,1

; --- for generaldynamics ---

	struct	exal_movedir,1

; --- for key control ---

	struct	exal_key_trig,2
	struct	exal_key_cont,2

; --- explosion circle ---

	struct	exal_circle_flag,1

	struct	exal_circle_decr,1
	struct	exal_circle_decg,1
	struct	exal_circle_decb,1

	struct	exal_circle_step,2


	struct	exal_circle_x,2
	struct	exal_circle_y,2
	struct	exal_circle_z,2

	struct	exal_circle_obj,2

; --- player VIEW pointer ---

	struct	exal_viewstratptr,3
	struct	exal_demoviewstratptr,3

; --- player SHAPE(vehicle) No. ---

	struct	exal_shapeNo,1
	struct	exal_shapeNoNEXT,1

; --- depth offset ---

	struct	exal_depthno,1

; --- for animation driver ---

	struct	exal_motionNo,1
	struct	exal_motiondir,1
	struct	exal_animptr,2
	struct	exal_animptrNEXT,2
	struct	exal_animptrBEFORE,2
	struct	exal_animflag,1
	struct	exal_animdush,1

; --- hit something pros ---

	struct	exal_shockvel,1

; --- 1 HO-KO- mode ---

	struct	exal_forceroty,1
	struct	exal_forcecx,2
	struct	exal_forcecy,2
	struct	exal_forcecz,2
	struct	exal_forcewidth,2
	struct	exal_forceheight,2

; --- for player's moving ---

	struct	exal_rotx,2
	struct	exal_roty,2
	struct	exal_rotz,2

	struct	exal_inccamrotx,1
	struct	exal_inccamrotz,1

	struct	exal_camworldx,2
	struct	exal_camworldy,2
	struct	exal_camworldz,2

;	struct	exal_camrotxold,1
;	struct	exal_camrotyold,1
;	struct	exal_camrotzold,1
;	struct	exal_camworldxold,2
;	struct	exal_camworldyold,2
;	struct	exal_camworldzold,2

	struct	exal_worldxold,2
	struct	exal_worldyold,2
	struct	exal_worldzold,2

	struct	exal_acclroty,2
	struct	exal_rotxoffset,1	; for looploop
	struct	exal_rotyoffset,2	; 2 bytes
	struct	exal_rotyoffsetaccel,2	; 2 bytes
	struct	exal_rotyoffsetSHOCK,1	; 2 bytes
	struct	exal_rotzoffset,1
	struct	exal_rotzofscounter,1	; counter of Arwing's shaking
	struct	exal_rotztend,1		; zoffset (push lr)
	struct	exal_rotztilt,2		; zoffset (push LR)
	struct	exal_rotzhit,1		; zoffset (when hit)
	struct	exal_worldyofscounter,1	; counter of Arwing(ROBOT)'s shaking data
	struct	exal_rollingstatus,1	; rolling counter
	struct	exal_rollingoffset,1	; rolling offset rotY
	struct	exal_RBrollingoffset,1	; rolling offset rotY
	struct	exal_clamprotyoffset,1

	struct	exal_worldxoffset,2	; Armer (tutumode offset)
	struct	exal_worldyoffset,2	; Arwing(head of ROBOT)'s shaking & Armer (tutumode offset)
	struct	exal_worldzoffset,2	; Armer (tutumode offset)


; --- SPACE BATTLE no opening demo no number

	struct	exal_demoNo_attack,1

; shift test

	struct	exal_camxofsbuf,2

; --- for armer's jet engine & Robot's leg ---

	struct	exal_jetstatus,1
	struct	exal_jetstatus2,1
	struct	exal_jetrot,1		;jet engine angle
	struct	exal_jetrotoffset,1	;jet engine angle
	struct	exal_jetrotx,1		;jet engine rotx
	struct	exal_jetroty,1		;jet engine roty
	struct	exal_jetRobjptr,2
	struct	exal_jetLobjptr,2

	struct	exal_legRheight,2
	struct	exal_legLheight,2

	struct	exal_getheight_WY,2

	struct	exal_clampx,2
	struct	exal_clampz,2
	struct	exal_clampy,2	; armer's tutumode

	struct	exal_clampcamx,2
	struct	exal_clampcamz,2
	struct	exal_clampcamy,2

	struct	exal_slopenumB,2
	struct	exal_slopenumL,2
	struct	exal_slopenumR,2

	struct	exal_vx,2	;vector X(armer) old vector(robot)
	struct	exal_vy,2	;vector Y(armer) old vector(robot)
	struct	exal_vz,2	;vector Z(armer) old vector(robot)

	struct	exal_vx_gen,2	; Arwing no room mode no vx buffer
	struct	exal_vz_gen,2	; --> generaldynamics de tsukau.

	struct	exal_sidevel,2	; Armer no yoko idou
	struct	exal_sidevelcounter,1	;move 2 left right counter

	struct	exal_TUTUdir,1
	struct	exal_TUTUlevel,2
	struct	exal_TUTUlevelcurrent,2
	struct	exal_TUTUheight,2
	struct	exal_TUTUheightcurrent,2

	struct	exal_TUTUtop,2
	struct	exal_TUTUbottom,2

	struct	exal_TUTUptr,3
	struct	exal_TUTUNo,1

; --- block map system ---

	struct	exal_blockx,1	; block map buffer
	struct	exal_blockz,1	; block map buffer
	struct	exal_blockrotyoffset,1
	struct	exal_blockxold,1	; old block map buffer
	struct	exal_blockzold,1	; old block map buffer


	struct	exal_wallblockx,1
	struct	exal_wallblockz,1


; --- camera ---

	struct	exal_camupdw,1	; flag of up down

	struct	exal_camrotx,2
	struct	exal_camroty,2
	struct	exal_camrotz,2
	struct	exal_camRotXofs,2	; ARWING
	struct	exal_camRotYofs,2
	struct	exal_camRotXtilt,2	; (16bit) camera's shock!
	struct	exal_camrotyofsNT,2	; noturn mode no offset
	struct	exal_acclcamrotx,2
	struct	exal_acclcamroty,2
	struct	exal_acclcamrotz,2

	struct	exal_camYcenter,2
	struct	exal_camYcenterOFS,2
	struct	exal_camYofsMAX,1
	struct	exal_camXofs,2		; Arwing camera offset X
	struct	exal_acclcamXofs,2	; Arwing camera offset X
	struct	exal_camYofs,2		; Arwing camera offset Y
	struct	exal_acclcamYofs,2	; Arwing camera offset Y
	struct	exal_camZofs,2		; Arwing camera offset Z
	struct	exal_camZofs_gone,2	; Arwing camera offset Z (When enemy has gone )
	struct	exal_camZofs_tame,2	; Arwing camera offset Z (When shoot TAME beam)
	struct	exal_camZofs_tame_accl,1	; Arwing camera offset Z (When enemy has gone )

	struct	exal_camYofsrate,1	; rate of camera y offset
	struct	exal_camlookYofs,2	; for Robo's camera
	struct	exal_camlookYofs_ext,2	; for Robo's camera(use path)


; -- for v scroll offset (noturn mode) --

	struct	exal_hscrollofsftotal,2

; -- weapon --

	struct		exal_weaponstatus,1
	;Low  4bit weapon timer
	;High 4bit weapon counter

	struct		exal_SPweaponstatus,1
	;Low  4bit weapon timer
	;High 4bit

; -- player speed(Robot no toki tukaku ) --

	struct	exal_vel,1

; --- camera view position value ---

	struct	exal_VIEWflag,1		; VIEW mode flag
	struct	exal_VIEWflag2,1	; VIEW mode flag
	struct	exal_VIEWflag3,1	; VIEW mode flag
	struct	exal_VIEWNo,1		; VIEW mode number
	struct	exal_camZofs_N,2
	struct	exal_camZofs_F,2
	struct	exal_camZofs_B,2
	struct	exal_camZofs_cock,2
	struct	exal_camZofs_objective,2

	struct	exal_camRotXofs_Normal,2
	struct	exal_camRotXofs_JMP,2
	struct	exal_camYofs_Normal,2


; --- player's status ---

	struct	exal_control,1
	struct	exal_control3,1
;	struct	exal_control2,1

	struct	exal_boost,1
	struct	exal_brake,1
	struct	exal_controlmode,2
	struct	exal_status,1
	struct	exal_LASTLR,1

; --- for boost --

	struct	exal_boostbuf,1
	struct	exal_boostheatup,1

; ---
	struct	exal_xyzLMT,1
	struct	exal_updown,2
	struct	exal_vxvyvz,2
	struct	exal_pulldown_timer,1	;
	struct	exal_keybutton,2	; ptrig buffer & pcont
	struct	exal_oldkeybutton,2	; ptrig buffer & pcont

; --- for Robo ---

	struct	exal_jmpstatus,1
	struct	exal_jmpstatus2,1
	struct	exal_jmpvel,2		; use for offsetY
	struct	exal_jmpcounter,1	; use for offsetY
	struct	exal_gravity,2		; gravity for generaldynamics_l
	struct	eal_pbyte1,2
	struct	exal_robostatus,1
	struct	exal_robostatus2,1
	struct	exal_robostatustrig,1
	struct	exal_gravcounter,1	; for submarine jump

	struct	exal_plashvel,1		; plash by other obj
	struct	exal_plashcounter,2	; plash by other obj

; --- sound ---

	struct	exal_transENDse,1

; --- Target scope ---

	struct	exal_target_x,2
	struct	exal_target_y,2
	struct	exal_target_z,2

; --- head up display ---

	struct	exal_hudrot,2
	struct	exal_hudflag,1

; --- altmeter ---

	struct	exal_altmeter,1		;height of player's cursor
	struct	exal_waterline,1	;height of water line
	struct	exal_altmeter_col,1	;col No.
	struct	exal_altmeter_rate,2
	struct	exal_altmeter_chr,1
	struct	exal_altmeter_rotxmax,1
	struct	exal_altmeter_flag,1

	struct	exal_enemyaltmeter_x,2
	struct	exal_enemyaltmeter_y,2
	struct	exal_enemyaltmeter_lmtx,2
	struct	exal_enemyaltmeter_lmty,2

	struct	exal_enemyaltmeter,1
	struct	exal_enemyaltmeter_status,1
	struct	exal_enemyaltmeter_status2,1
;;;;	struct	exal_enemyaltmeter_animspeed,1
	struct	exal_enemyaltmeter_objptr,2
	struct	exal_enemyaltmeter_objdist,2
	struct	exal_enemyaltmeter_objdist_ck,2
	struct	exal_enemyaltmeter_objdirY,2
	struct	exal_enemyaltmeter_objdirX,2
	struct	exal_enemyaltmeter_flag,1
	struct	exal_enemyaltmeter_OFFdist,2

	struct	exal_enemyaltmeter_type,1

	struct	exal_enemyaltmeter_locktimer,1
	struct	exal_enemyaltmeter_locktimer2,1
	struct	exal_enemyaltmeter_lockobjlast,2
	struct	exal_enemyaltmeter_lockobj,2

	struct	exal_markx,2
	struct	exal_marky,2
	struct	exal_markz,2

	struct	exal_markx_inert,2
	struct	exal_marky_inert,2
	struct	exal_markz_inert,2
	struct	exal_markdist_inert,2

	struct	exal_string_col,2
	struct	exal_string_ofsx,1
	struct	exal_string_ofsy,1
	struct	exal_string,2
	struct	exal_string2,2

; --- nohit timer ---

	struct	exal_nohitRISE,1
	struct	exal_nohit,1

; --- damage effect ---

	struct	exal_dmgeffect,1
	struct	exal_dmgfxcounter,1


	struct	exal_blockmapstatus,1

	struct	exal_reflectSE,1

;------------------------------------------------------------------------------
;******************************************************************************
;------------------------------------------------------------------------------

	struct	playerheap_clear_size,0

; --- sound ---

	struct	exal_HPmeterSE,1

; --- pallet wait timer ---

	struct	exal_paletteflag,1
	struct	exal_paletteflag_bombtimer,1

; --- blockmap ---

	struct	exal_blockflag,1

; --- hit wall etc ... ---

	struct	exal_CTLtype,1	; control automatic or manual

; --- real worldx,y,z ---

	struct	exal_worldx,2
	struct	exal_worldy,2
	struct	exal_worldz,2

	struct	exal_bodyworldy,2

; --- player moving limitter ---

	struct	exal_maxPmoveY,2
	struct	exal_minPmoveY,2

	struct	exal_maxProtx,1
	struct	exal_minProtx,1

; --- camera moving limitter ---

	struct	exal_midCmoveY,2
	struct	exal_maxCrotx,1
	struct	exal_minCrotx,1

; --- pilot(FOX,FALCO,PEPPY,SLIPPY,GAL1,GAL2) No. ---

	struct	exal_pilotNo,1

; --- player's HP(buffer) ---

	struct	exal_HP,1
	struct	exal_HPpointer,1

; --- shield ---

	struct	exal_shield,1

; -- weapon --

	struct	exal_laser_LMT,1
	struct	exal_spweap_LMT,1	;No. of special weapon
	struct	exal_spweap_TYPE,1	;special weapon type&flags
	struct	exal_weap_level,1	;normal weapon no level
	struct	exal_weap_power,2	;power laser no level
	struct	exal_weap_powerflag,1	;power laser no flag

; --- alarm ---

	struct	exal_KHPold,1

; --- for color add ---

	struct	exal_addcol_r,1
	struct	exal_addcol_g,1
	struct	exal_addcol_b,1

	struct	exal_deccol_r,1
	struct	exal_deccol_g,1
	struct	exal_deccol_b,1

	struct	exal_scrflash,1
	struct	exal_scrflash_flag,1

; --- TIME CHART ---

	struct	exal_chartptr,3
	struct	exal_charttimer,2
	struct	exal_charttimer_skip,2
	struct	exal_charttimer_work,2

; --- damage meter ---

	struct	kx_circlewindowmode,2
	struct	kx_circleCX,2	;2 byte :Circle Window X zahyo
	struct	kx_circleCY,2	;2 byte :Circle Window Y zahyo
	struct	kx_circleTR,2	;2 byte :Circle Window Radius
	struct	kx_circleR,2	;2 byte :Circle Window Radius
	struct	kx_circlestep,2	;2 byte :circle Radius Step
	struct	kx_circlefade,1	;1 byte :circle Radius Step
	struct	kx_circleadsub,1 ;1 byte :cilcle window colour Red
	struct	kx_circlecolR,1	;1 byte :cilcle window colour Red
	struct	kx_circlecolG,1	;1 byte :cilcle window colour Green
	struct	kx_circlecolB,1	;1 byte :cilcle window colour Blue

	struct	KBOMSHOT,1
	struct	KGMOVER,1
	struct	KRadarMode,1

	struct	KRINGOUT,1
	struct	KRingOutTimer,1
	struct	KRingOutSecTm,1

	struct	Kscore,3
	struct	Kgold,2
	struct	KHP,1

;----------------

	struct		playerheap_size,0

playerheap_clear_sizeof	equ	playerheap_clear_size-heap
playerheap_sizeof		equ	playerheap_size-heap


;ÚÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂ¿
;ÃÙ                       À´
;³  --- EXALVAR FLAGS ---  ³
;Ã¿                       Ú´
;ÀÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÙ

; sound for finish transform

exal_transENDse_RB	equ	1<<7
exal_transENDse_notEND	equ	1<<6
exal_transENDse_mask	equ	%111111

;exal_shapeNo (PLAYER SHAPE No.) --------

; bit 0 - 7 : control type   bit 8 - 15 : FF or SP or GG flag

exal_shapeNo_ctmask	equ	0fH
ct_OF_ARWING		equ	1	;ARWING on field
ct_CS_ARWING		equ	2	;ARWING in space
ct_ARMER		equ	3	;ARMER space
ct_ROBOT		equ	4	;ROBOT on field

;****
type_ARWING		equ	1
type_ROBOT		equ	2
type_UFO		equ	3
;type_NOTHING		equ	0

exal_shapeNo_stmask	equ	0f0H
st_OF_ARWING		equ	type_ARWING	;ARWING on field
st_CS_ARWING		equ	type_ARWING	;ARWING in space
st_ARMER		equ	type_UFO
st_ROBOT		equ	type_ROBOT

;****

exal_status_transrising	equ	1<<7
exal_status_transfalling	equ	1<<6
exal_status_transrising_w	equ	1<<5
exal_status_transfalling_w	equ	1<<4
exal_status_transfalling_g	equ	1<<3

;****

exal_BGM_CORE0	equ	1<<7
exal_BGM_CORE1	equ	1<<6
exal_BGM_wolfdead	equ	1<<5

;****

exal_shield_shield		equ	1<<7	; item de hanekaesu toki.
exal_shield_Rshield		equ	1<<6	; rolling de hanekaesu.
exal_shield_obj		equ	1<<5	; shield no object ga on.
exal_shield_mask		equ	%11111	; counter no mask

;**** trap counter

exal_noturn_trap_on		equ	1<<7	;1: trap on
exal_noturn_trap_mask	equ	%111	;trap counter

;****

exal_pilotNo_plmask	equ	0ffH
ep_FOX		equ	0
ep_FALCO		equ	1
ep_PEPPY		equ	2
ep_SLIPPY		equ	3
ep_GAL1		equ	4
ep_GAL2		equ	5
ep_FF		equ	ep_FOX
ep_SP		equ	ep_PEPPY
ep_GG		equ	ep_GAL1
max_ep_PLAYER	equ	5

exal_xyzLMT_left		equ	1<<0
exal_xyzLMT_right		equ	1<<1
exal_xyzLMT_top		equ	1<<2
exal_xyzLMT_bottom		equ	1<<3
exal_xyzLMT_front		equ	1<<4
exal_xyzLMT_rear		equ	1<<5
exal_xyzLMT_topH		equ	1<<6
exal_xyzLMT_bottomL		equ	1<<7

exal_robostatus_onthegroundtrig	equ	1<<7
exal_robostatus_plash		equ	1<<6	; Robot wo haneageru?
exal_robostatus_hamonL		equ	1<<5	; splash wo tukuttara set.
exal_robostatus_hamonR		equ	1<<4	; splash wo tukuttara set.
exal_robostatus_floating		equ	1<<3
exal_robostatus_depthlevelmask	equ	%111	; bit 0-2
exal_robostatus_DLnone	equ	0	;none
exal_robostatus_DLue		equ	1	;
exal_robostatus_DLashi	equ	2	;
exal_robostatus_DLkao	equ	3	;
exal_robostatus_DLatama	equ	4	;
exal_robostatus_DLzenbu	equ	5	;

exal_robostatus2_atamauchi	equ	1<<7
exal_robostatus2_suimen	equ	1<<6
exal_robostatus2_inmagma	equ	1<<5

exal_animdush_dush		equ	%10000000
exal_animdush_Cmask		equ	%01110000		;counter
exal_animdush_Kmask		equ	%00001111	; key

exal_animflag_repeat		equ	1<<7
exal_animflag_SEwalkpool	equ	1<<6

exal_vxvyvz_vx		equ	1<<7
exal_vxvyvz_vy		equ	1<<6
exal_vxvyvz_vz		equ	1<<5
exal_vxvyvz_ALL		equ	exal_vxvyvz_vx!exal_vxvyvz_vy!exal_vxvyvz_vz

exal_boost_boost		equ	1<<7	;bit7
exal_boost_pm		equ	1<<6	;bit6
exal_boost_mask		equ	%111111	;boost meter no counter

exal_brake_Lalive		equ	1<<7	;bit7
exal_brake_Ralive		equ	1<<6	;bit6
exal_brake_alarm		equ	1<<5	;bit5
exal_brake_timer		equ	%1111	;display timer

exal_control_boost		equ	1<<6	;bit6
exal_control_brake		equ	1<<5	;bit5
exal_control_rolling		equ	1<<4	;bit4
exal_control_brakeTurn	equ	1<<3	;bit3
exal_control_notturn		equ	1<<2	;bit2
;;;exal_control_overheat	equ	1<<1	;bit1
exal_control_on		equ	1<<0	;bit0(=0 no read key)
exal_control_RBmask		equ	%00000111

;exal_control2_enter_mask	equ	%111<<5
;exal_control2_enter_1	equ	1<<5
;exal_control2_enter_2	equ	2<<5
;exal_control2_enter_on	equ	1<<4
;exal_control2_zoneoff	equ	1<<3
;exal_control2_tutu		equ	exal_control2_enter_on

exal_LASTLR_lastLR		equ	1<<7	;bit7(1:Tright 0:Tleft)
exal_LASTLR_L		equ	1<<6	;bit6(1:Tright 0:Tleft)
exal_LASTLR_R		equ	1<<5	;bit5(1:Tright 0:Tleft)

exal_TUTUdir_down		equ	0
exal_TUTUdir_up		equ	1

exal_weaponstatus_counter	equ	$0f		;bit0-3
exal_SPweaponstatus_counter	equ	%00001111	;bit0-3
exal_SPweaponstatus_trig	equ	1<<7		;
exal_SPweaponstatus_rebound	equ	1<<6		;0 or 1

exal_nohitRISE_mask		equ	$3f	;nohit timer max $3f
exal_nohit_mask		equ	$3f	;nohit timer max $3f
;exal_nohit_scrflash		equ	1<<7	;screen no flash(RED)!
;exal_nohit_scrsplash		equ	1<<6	;screen no flash(RED)!

exal_scrflash_flag_lockreally	equ	1<<7
exal_scrflash_flag_lock		equ	1<<6
exal_scrflash_flag_set		equ	1<<5
exal_scrflash_flag_dmg		equ	1<<4
exal_scrflash_flag_shield		equ	1<<3
exal_scrflash_flag_explode		equ	1<<2
exal_scrflash_flag_white		equ	1<<1
exal_scrflash_flag_white_fast	equ	1<<0

exal_CTLtype_automatic	equ	1<<7	;ctl 1:automatic 0:manual
exal_CTLtype_hitwall		equ	1<<6	;wall ni hit suruka douka no flag
exal_CTLtype_dotrans		equ	1<<5	;ctl 1:do transform  0:off
exal_CTLtype_notrans		equ	1<<4	;ctl 1: can't transform  0:can do it.
exal_CTLtype_notransreally	equ	1<<3	;ctl 1: can't transform  0:can do it.

exal_VIEWflag_cockpit	equ	1<<7	; cockpit mode(1:on 0:off)
exal_VIEWflag_cpchg		equ	1<<6	; cockpit mode changing(1:changing 0:finished)
exal_VIEWflag_cpinbet	equ	1<<5	; cockpit mode inbetween
exal_VIEWflag_RBpushX	equ	1<<4	; ROBOT (1:view angle changing)
exal_VIEWflag_RBtrigX	equ	1<<3	; ROBOT (1:view angle changing)
exal_VIEWflag_change		equ	1<<2	; cockpit mode change flag
exal_VIEWflag_blockout	equ	1<<1	; block map no area wo OUT sitaka(1:out).

exal_VIEWflag2_insidecockpit		equ	1<<7	; invisible flag wo on ni suru.
exal_VIEWflag2_insidecockpitoff	equ	1<<6	; invisible flag wo ichiji off ni suru.
exal_VIEWflag2_initial		equ	1<<5	; camera no initial wo suru toki set suru. camera no strat wo jikkou go AUTO de clear sareru.
exal_VIEWflag2_initialNEXT		equ	1<<4	; camera no initial wo suru toki set suru. camera no strat wo jikkou go AUTO de clear sareru.
exal_VIEWflag2_demo			equ	1<<3	; set if demo mode
exal_VIEWflag2_inthesea		equ	1<<2	;
exal_VIEWflag2_intheseareally	equ	1<<1	; splash effect ga owattara set suru
;exal_VIEWflag2_inbetofftrig		equ	1<<0	; inbetween wo kyou-sei-teki ni off ni suru.

exal_VIEWflag3_splash	equ	1<<7
exal_VIEWflag3_vscrloff	equ	1<<6	; BG v scroll off
exal_VIEWflag3_forcelookyofs	equ	1<<5	; Boss mode de X ang wo kaeru tokini tsukau....
exal_VIEWflag3_insea_trig	equ	1<<4	; in the sea trigger
exal_VIEWflag3_outsea_trig	equ	1<<3	; on the sea trigger
;;;exal_VIEWflag3_poolview	equ	1<<2	;



exal_jmpstatus2_top		equ	1<<0		;jump (1:higher 0:lower)
exal_jmpstatus2_Goff		equ	1<<1		;gravity off(1) on(0)
exal_jmpstatus2_jmptrig	equ	1<<2		;gravity off(1) on(0) [submarine mode]
exal_jmpstatus2_ctrMASK	equ	%11110000	;gravity off(1) on(0) [submarine mode]

; exal_jetstatus 	(ARMER,ROBOT)
exal_jetstatus_legL0alive	equ	1<<0
exal_jetstatus_legR0alive	equ	1<<1
exal_jetstatus_bodyalive	equ	1<<2
exal_jetstatus_ALL		equ	3
exal_jetstatus_armrollsound	equ	1<<3	;ARMER'S ARM ga rolling suru oto
exal_jetstatus_legLonshape	equ	1<<4	;ashi ga mosi shape ni notteitara set suru.
exal_jetstatus_legRonshape	equ	1<<5	;(ue ni onaji)


; exal_jetstatus part 2 (ARMER,ARWING)
exal_jetstatus2_on		equ	1<<7	; (AM)jet on?
exal_jetstatus2_Lset		equ	1<<6	; (AM)jet no L no obj ga set sareteiruka..
exal_jetstatus2_Rset		equ	1<<5	; (AM)jet no R no obj ga set sareteiruka..
;exal_jetstatus2_sprkCset	equ	exal_jetstatus2_on	; (AW) nose no spark wo set siteiruka...
;exal_jetstatus2_sprkLset	equ	1<<4	; (AW&AM) Lwing no spark wo set siteiruka...
;exal_jetstatus2_sprkRset	equ	1<<3	; (AW&AM) Rwing no spark wo set siteiruka...

exal_blockflag_off	equ	1<<7	; 1: block system off
;exal_blockflag_clamp	equ	1<<6	; 1: block clamp on
;exal_blockflag_dirX	equ	1<<5	; clamp direction 1: X

exal_enemyaltmeter_flag_player	equ	1<<7
exal_enemyaltmeter_flag_on		equ	1<<6
exal_enemyaltmeter_flag_out		equ	1<<5
exal_enemyaltmeter_flag_locked	equ	1<<4
exal_enemyaltmeter_flag_nolock	equ	1<<3


exal_dmgeffect_smokemask	equ	%1111	; kietatoki no counter
exal_dmgeffect_burnning_L	equ	1<<7
exal_dmgeffect_burnning_R	equ	1<<6
exal_dmgeffect_burnning_C	equ	1<<5
exal_dmgeffect_burnning_ALL	equ	%11100000

exal_blockmapstatus_viewout		equ	1<<7
exal_blockmapstatus_playerout	equ	1<<6
exal_blockmapstatus_Bout		equ	1<<5
exal_blockmapstatus_SE		equ	1<<4
exal_blockmapstatus_SEold		equ	1<<3
exal_blockmapstatus_mask	equ	%11


exal_circle_flag_Pri		equ	1<<7	; yu-sen flag
exal_circle_flag_Pos		equ	1<<6	; direct pos flag
exal_circle_flag_step	equ	1<<5	; step lock


exal_paletteflag_trig	equ	1<<7	; trigger
exal_paletteflag_normal	equ	1<<6	; 0: normal
exal_paletteflag_alart	equ	1<<5
exal_paletteflag_bomb_normal	equ	1<<4
exal_paletteflag_bomb	equ	1<<3


exal_sidevelcounter_mask	equ	3fh	;move 2 left right counter
exal_sidevelcounter_left	equ	1<<7
exal_sidevelcounter_right	equ	1<<6


exal_weap_powerflag_pl	equ	1<<7
exal_weap_powerflag_mi	equ	1<<6
exal_weap_powerflag_SE	equ	1<<5
exal_weap_powerflag_fired	equ	1<<4

; altmeter flag

;ÚÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂ¿
;ÃÙ                     À´
;³  --- ALVAR FLAGS ---  ³
;Ã¿                     Ú´
;ÀÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÙ

;-------- al_pbyte1 (ROBOT STATUS)--------

roboF_flag		equ	$2	;walker forw flag  (pbyte1 :2bit)
roboB_flag		equ	$4	;walker back flag  (pbyte1 :3bit)
roboL_flag		equ	$8	;walker left flag  (pbyte1 :4bit)
roboR_flag		equ	$10	;walker rightflag  (pbyte1 :5bit)
roboTL_flag		equ	$20	;walker L    flag  (pbyte1 :6bit)
roboTR_flag		equ	$40	;walker R    flag  (pbyte1 :7bit)
roboJMP1_flag	equ	$20	;walker jamp flag  (pbyte1 :6bit)
roboINIT_flag	equ	$80	;motion init flag  (pbyte1 :8bit)

roboFB_flag		equ	(roboF_flag)!(roboB_flag)
roboLR_flag		equ	(roboL_flag)!(roboR_flag)
roboTLTR_flag	equ	(roboTL_flag)!(roboTR_flag)
roboFBLR_flag	equ	roboFB_flag!roboLR_flag
roboTLTRLR_flag	equ	roboTLTR_flag!roboLR_flag
roboTLTRFB_flag	equ	roboTLTR_flag!roboFB_flag
roboTLTRFBLR_flag	equ	roboTLTR_flag!roboFB_flag!roboLR_flag

;-------- al_pbyte2 (PLAYER SHAPE STATUS)-------

exal_transflag_armode_flag			equ	1<<7	;arwing mode flag  (pbyte2 :1bit)
exal_transflag_transanm1_flag		equ	1<<6	;trans anm 1 flag  (pbyte2 :bit4)
exal_transflag_transanm2_flag		equ	1<<5	;trans anm 2 flag  (pbyte2 :bit5)
exal_transflag_transform_flag		equ	exal_transflag_transanm1_flag!exal_transflag_transanm2_flag
exal_transflag_transform_really_flag	equ	1<<4	;trans anm 1 flag  (pbyte2 :bit4)

;ÚÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂ¿
;ÃÙ                                  À´
;³  --- FLAGS FOR OPTION CONTROL  --- ³
;Ã¿                                  Ú´
;ÀÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÙ
;--- al_pbyte1 ---

;optplayer2_flag	equ	$1	; player2 flag

;ÚÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂ¿
;ÃÙ                                  À´
;³ --- PLAYER'S HP & DAMAGE METER --- ³
;Ã¿                                  Ú´
;ÀÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÙ

DMETERNUM		equ	10	; number of damage meter lamp
player_HP		equ	40
arwing_HP		equ	40
robot_HP		equ	40
armer_HP		equ	40

;ÚÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂ¿
;ÃÙ                           À´
;³ --- PLAYER'S PARAMETERS --- ³
;Ã¿                           Ú´
;ÀÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÙ

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³Arwing's speed(max 127)³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
;speed	equ	35	;normal
;speedmin	equ	10	;brake
;speedmax	equ	120	;boost
;speedlr	equ	17	;push left & right

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³Robot's speed(max127)³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
;robospeed		equ	8	;normal
;robospeedFAST	equ	16	;push Y
;robospeedLR		equ	5	;L & R
;robospeedthrash	equ	10	;bata-ashi
;robospeedthrashFAST	equ	30	;bata-ashi+jump

;boostmetermax		equ	35
;powermetermax		equ	35

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³Arwing's rotation³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

; -- accl of rotation --
rotxmax		equ	15*4
rotxmin		equ	-15*4
rotxpullup		equ	5
rotyaccl		equ	200H
rotyacclLR		equ	300H
rotyacclBRAKE	equ	3c0H	;	700H

rotzmax		equ	10h
rotzmin		equ	-10h
rotzmax2		equ	40H
rotzmin2		equ	-40H
camrotxmid		equ	0
camrotzmax		equ	6
camrotzmin		equ	-6
pullup_camrotx	equ	3
pulldown_camrotx	equ	-8
rotyoffset		equ	18H	; roty offset when push lr
RBrotyoffset		equ	22h	; roty offset when push LR
RBrotyoffset_cock	equ	18h	; roty offset when push LR
shift_timer		equ	20h

arwing_length	equ	01h
ctl_plus		equ	10000000b
ctl_minus		equ	01000000b
ctl_n_plus		equ	00100000b
ctl_n_minus		equ	00010000b
dec_rate		equ	0f0h
rollinginterval	equ	7	;max15
rollingtime		equ	8	;max15

;-------------------------------------------------------

dis_CAMmaxY		equ	-70	;(+CAMmaxY)
val_CAMmaxY		equ	-50	;(+CAMmaxY)
dis_CAMminY		equ	70	;50	;(+CAMminY)
val_CAMminY		equ	50	;32	;(+CAMminY)


MAXcamY_ofs		equ	40
MINcamY_ofs		equ	20

;-------------------------------------------------------
; --- screen shock value ---

scrshock		equ	80H	; angle 16bit
scrshock_s		equ	60H	; angle 16bit

;-------------------------------------------------------
; --- weapon limitter --
LASERCONT		equ	2	; rensya kaisu(Num of fire)
LASERINT		equ	1	; rensya kankaku(lnterval of fire)
LASERINTPOWERD	equ	5	; rensya kankaku(lnterval of fire)
LASERLMT		equ	8	; limitter of total No. of laser
SPWEAPINT		equ	5	; special weapon hassya no kankaku
;-------------------------------------------------------
; --- for DISPLAY --

altmeter_height	equ	4*8+8
altmeter_outheight	equ	1*8
altmeter_Vpos	equ	6*8	;center of screen
altmeter_Hpos	equ	2*8

; --- for ENEMY CURSOR --

player_curOFFDIST	equ	10000	;enemy cursor off distance

; --- for PLAYER CURSOR --
;one screen

P1_PaltlineposX_1	equ	bitmapwidth_1*8-8
P1_PaltmeterX_1	equ	bitmapwidth_1*8-16

;two screen
P1_PaltlineposX	equ	bitmapwidth*8-8
P2_PaltlineposX	equ	1
P1_PaltmeterX	equ	bitmapwidth*8-16
P2_PaltmeterX	equ	1

PA_cur_sizeX		equ	6	;size of altmeter sting
PA_cur_sizeY		equ	6
;-------------------------------------------------------
;ÚÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂ¿
;ÃÙ                    À´
;³ - WEAPON LEVEL NO.-  ³
;Ã¿                    Ú´
;ÀÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÙ

exal_weap_level_0	equ	0
exal_weap_level_1	equ	1
exal_weap_level_2	equ	2
exal_weap_level_3	equ	3

;ÚÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂ¿
;ÃÙ                           À´
;³ - SPECIAL WEAPON TYPE NO.-  ³
;Ã¿                           Ú´
;ÀÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÙ

spweap_heal		equ	0
spweap_bomb		equ	1
spweap_dummy		equ	2
spweap_shield	equ	3
spweap_missile1	equ	4
spweap_smartplasma	equ	spweap_bomb
spweap_end		equ	5

;-------------------------------------------------------
;ÚÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂ¿
;ÃÙ                           À´
;³ --- PLANET'S PARAMETERS --- ³
;Ã¿                           Ú´
;ÀÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÙ
;onMarine mode

onmarine_PLRminY		equ	12
onmarine_PLRmaxY		equ	300
onmarine_CAMmidY		equ	130
onmarine_camYofsMAX_1	equ	100
onmarine_camYofsMAX		equ	100

onmarine_camYofsrate_1	equ	55H
onmarine_camYofsrate		equ	55H

onmarine_PLRmaxrotX	equ	15
onmarine_PLRminrotX	equ	-15
onmarine_CAMmaxrotX	equ	16
onmarine_CAMminrotX	equ	-16
onmarine_CAMmaxrotX_1	equ	16
onmarine_CAMminrotX_1	equ	-16

onmarine_BATTLEAREA_maxY	equ	-300
onmarine_BATTLEAREA_minY	equ	0
onmarine_vsclofsrate		equ	0
onmarine_vsclofsmax		equ	0
onmarine_seadepth		equ	20

;-------------------------------------------------------
;inMarine mode

inmarine_PLRminY	equ	12
inmarine_PLRmaxY	equ	300
inmarine_CAMmidY	equ	130
inmarine_camYofsMAX_1	equ	100	;(38%)
inmarine_camYofsMAX		equ	60	;(38%)

inmarine_camYofsrate_1	equ	55H
inmarine_camYofsrate		equ	55H

inmarine_PLRmaxrotX	equ	15
inmarine_PLRminrotX	equ	-15
inmarine_CAMmaxrotX	equ	16
inmarine_CAMminrotX	equ	-16
inmarine_CAMmaxrotX_1	equ	16
inmarine_CAMminrotX_1	equ	-16
;inmarine_P1HORIZONofs	equ	44H
;inmarine_P2HORIZONofs	equ	0ffdcH

inmarine_BATTLEAREA_maxY	equ	-300
inmarine_BATTLEAREA_minY	equ	0
inmarine_vsclofsrate		equ	0
inmarine_vsclofsmax		equ	0
inmarine_seadepth		equ	0
;-------------------------------------------------------
;onfield mode

onfield_PLRminY	equ	12	;+1000
onfield_PLRmaxY	equ	300	;+1000
onfield_CAMmidY	equ	130	;+1000
onfield_camYofsMAX_1	equ	100	;(38%)
onfield_camYofsMAX	equ	60	;(38%)

onfield_camYofsrate_1	equ	55H
onfield_camYofsrate		equ	65H

onfield_PLRmaxrotX	equ	15
onfield_PLRminrotX	equ	-15
onfield_CAMmaxrotX	equ	16
onfield_CAMminrotX	equ	-16
onfield_CAMmaxrotX_1	equ	16
onfield_CAMminrotX_1	equ	-16
;onfield_P1HORIZONofs	equ	44H
;onfield_P2HORIZONofs	equ	0ffdcH

onfield_BATTLEAREA_maxY	equ	-300
onfield_BATTLEAREA_minY	equ	0
onfield_vsclofsrate		equ	0
onfield_vsclofsmax		equ	0

onfield_RBCAMmaxrotX	equ	40	;15
onfield_seadepth		equ	0
;-------------------------------------------------------
;onfield mode

nosedrive_PLRminY	equ	12	;+1000
nosedrive_PLRmaxY	equ	300	;+1000
nosedrive_CAMmidY	equ	130	;+1000
nosedrive_camYofsMAX_1	equ	100	;(38%)
nosedrive_camYofsMAX	equ	60	;(38%)

nosedrive_camYofsrate_1	equ	55H
nosedrive_camYofsrate	equ	65H

nosedrive_PLRmaxrotX	equ	15
nosedrive_PLRminrotX	equ	-15
nosedrive_CAMmaxrotX	equ	16
nosedrive_CAMminrotX	equ	-16
nosedrive_CAMmaxrotX_1	equ	16
nosedrive_CAMminrotX_1	equ	-16
;nosedrive_P1HORIZONofs	equ	44H
;nosedrive_P2HORIZONofs	equ	0ffdcH

nosedrive_BATTLEAREA_maxY	equ	-300
nosedrive_BATTLEAREA_minY	equ	0
nosedrive_vsclofsrate		equ	0
nosedrive_vsclofsmax		equ	0

nosedrive_RBCAMmaxrotX	equ	15
nosedrive_RBCAMminrotX	equ	-15
nosedrive_seadepth		equ	0
;-------------------------------------------------------
;inspace mode

inspace_PLRminY	equ	0
inspace_PLRmaxY	equ	4000
inspace_CAMmidY	equ	0
inspace_camYofsMAX_1	equ	100	;(38%)
inspace_camYofsMAX	equ	60	;(38%)

inspace_camYofsrate_1	equ	0
inspace_camYofsrate		equ	0

inspace_PLRmaxrotX	equ	60
inspace_PLRminrotX	equ	-60
inspace_CAMmaxrotX	equ	50	;60
inspace_CAMminrotX	equ	-50	;-60
inspace_CAMmaxrotX_1	equ	50	;60
inspace_CAMminrotX_1	equ	-50	;-60

;inspace_P1HORIZONofs	equ	0c0H
;inspace_P2HORIZONofs	equ	058H

inspace_BATTLEAREA_maxY	equ	-2000
inspace_BATTLEAREA_minY	equ	2000
inspace_vsclofsmax		equ	64
inspace_vsclofsrate		equ	(((inspace_BATTLEAREA_minY-inspace_BATTLEAREA_maxY)/inspace_vsclofsmax/2)
inspace_seadepth		equ	0
;-------------------------------------------------------
;cosmo mode

cosmo_PLRminY	equ	-2000
cosmo_PLRmaxY	equ	2000
cosmo_CAMmidY	equ	0

cosmo_PLRmaxrotX	equ	40
cosmo_PLRminrotX	equ	-40
cosmo_CAMmaxrotX_1	equ	15	;30
cosmo_CAMminrotX_1	equ	-15	;-30
cosmo_CAMmaxrotX	equ	30	;30
cosmo_CAMminrotX	equ	-30	;-30
cosmo_camYofsMAX_1	equ	100	;(38%)
cosmo_camYofsMAX	equ	60	;(38%)

cosmo_camYofsrate_1	equ	0	;
cosmo_camYofsrate	equ	0	;

cosmo_P1HORIZONofs	equ	0c0H
cosmo_P2HORIZONofs	equ	058H

cosmo_BATTLEAREA_maxY	equ	-2000
cosmo_BATTLEAREA_minY	equ	2000
cosmo_vsclofsmax		equ	16	;64
cosmo_vsclofsrate		equ	((cosmo_BATTLEAREA_minY-cosmo_BATTLEAREA_maxY)/cosmo_vsclofsmax/2
cosmo_seadepth		equ	0

;ÚÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂ¿
;ÃÙ                    À´
;³ --- SCROLL VALUE --- ³
;Ã¿                    Ú´
;ÀÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÙ

; -- one screen mode --

SCR1_Hofs	equ	10H+0H
SCR2_Hofs	equ	10H+80H
SCR4_Hofs	equ	10H+180H
SCR6_Hofs	equ	10H+280H

; -- two screen mode --

SCR2_P1Hofs	equ	0c0h	;40H	;044H
SCR2_P2Hofs	equ	48h	;0ffdcH

SCR4_P1Hofs	equ	01c0H
SCR4_P2Hofs	equ	158H

SCR3_P1Hofs	equ	-8*8-256
;SCR3_P2Hofs	equ	-21*8-256	;-20h
SCR3_P2Hofs	equ	-23*8-256	;-20h

ground_VofsMAX	equ	0	;16
ground_VofsRATE	equ	0	;(onfield_BATTLEAREA_minY-onfield_BATTLEAREA_maxY)/(ground_VofsMAX*2)
ground_Hofs		equ	SCR2_Hofs
ground_P1Hofs	equ	SCR3_P1Hofs
ground_P2Hofs	equ	SCR3_P2Hofs
ground_planet_mode	equ	pm_ground

marine_VofsMAX	equ	0
marine_VofsRATE	equ	0
marine_Hofs		equ	SCR2_Hofs	;+200H
marine_P1Hofs	equ	SCR2_P1Hofs+80H
marine_P2Hofs	equ	SCR2_P2Hofs+80H
marine_planet_mode	equ	pm_marine

desert_VofsMAX	equ	0
desert_VofsRATE	equ	0
desert_Hofs		equ	SCR2_Hofs
desert_P1Hofs	equ	SCR3_P1Hofs
desert_P2Hofs	equ	SCR3_P2Hofs
desert_planet_mode	equ	pm_ground

cosmos_Hofs		equ	SCR4_Hofs
cosmos_P1Hofs	equ	SCR4_P1Hofs
cosmos_P2Hofs	equ	SCR4_P2Hofs
cosmos_VofsMAX	equ	256	;cosmos_P1Hofs-cosmo_CAMmaxrotX*4-((scrshock*4)>>8)-16
cosmos_VofsRATE	equ	(cosmo_BATTLEAREA_minY-cosmo_BATTLEAREA_maxY)/(cosmos_VofsMAX*2)
cosmos_planet_mode	equ	pm_space

ground2_VofsMAX	equ	0
ground2_VofsRATE	equ	0
ground2_Hofs		equ	SCR4_Hofs
ground2_P1Hofs	equ	SCR4_P1Hofs
ground2_P2Hofs	equ	SCR4_P2Hofs
ground2_planet_mode	equ	pm_ground

tunnel_VofsMAX	equ	0
tunnel_VofsRATE	equ	0
tunnel_Hofs		equ	SCR6_Hofs
tunnel_P1Hofs	equ	SCR4_P1Hofs
tunnel_P2Hofs	equ	SCR4_P2Hofs
tunnel_planet_mode	equ	pm_ground

sun_VofsMAX		equ	250	;cosmos_P1Hofs-cosmo_CAMmaxrotX*4-((scrshock*4)>>8)-16
sun_VofsRATE		equ	(inspace_BATTLEAREA_minY-inspace_BATTLEAREA_maxY)/(sun_VofsMAX*2)
sun_Hofs		equ	SCR4_Hofs
sun_P1Hofs		equ	SCR4_P1Hofs
sun_P2Hofs		equ	SCR4_P2Hofs
sun_planet_mode	equ	pm_space

;ÚÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂ¿
;ÃÙ                           À´
;³ --- CAMERA'S PARAMETERS --- ³
;Ã¿                           Ú´
;ÀÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÙ
;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ for ARWING camera ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

camera_wait_value_1	equ	15H
camera_wait_value	equ	10

;-------------------------------------
; for camera worldz offset

;-[ARWING one screen mode]-
cameraZ_offset_boost_1	equ	50
cameraZ_offset_normal_1	equ	240
cameraZ_offset_brake_1	equ	-40

;-[ARWING two screen mode]-
cameraZ_offset_boost		equ	50
cameraZ_offset_normal	equ	260
cameraZ_offset_brake		equ	-20

cameraZ_offset_cockpit	equ	-100

;-------------------------------------
; for camera worldz offset

;-[ARMER one screen mode]-
AMcameraZ_offset_boost_1	equ	30
AMcameraZ_offset_normal_1	equ	160
AMcameraZ_offset_brake_1	equ	-30

;-[ARWING two screen mode]-
AMcameraZ_offset_boost	equ	30
AMcameraZ_offset_normal	equ	180
AMcameraZ_offset_brake	equ	-30

;-------------------------------------
; for camera worldx offset

cameraX_offset_SF2		equ	100
cameraX_offset_SF1		equ	100
cameraX_offsetRB		equ	80

cameraX_offset_inside	equ	90
cameraROTY_offset		equ	0	;6
;cameraX_offset_SF1		equ	200

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ for ROBOT camera ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
; for camera offset(XZ)
RBcam_chasepar		equ	40H	; When jumpping

Viewchange_wait_value	equ	10*10H	; Xbutton wait counter(exal_VIEWNo high 4bit)

; --- Normal ---
RB0camZofs_N_1		equ	(90<<1)+30	;8/24 100<<1	; Normal
RB0camZofs_F_1		equ	20	; Foward
RB0camZofs_B_1		equ	-20	; Back

RB0camRotXofs_Normal		equ	0	; rotX (normal)
RB0camRotXofs_JMP		equ	0a00H	; rotX (jumpping)

RB0camYofs_Normal		equ	0	; offset Y(normal)
RB0camYofs_cockpit		equ	-35	; offset Y(normal)

RBcameraYofs		equ	50
RBcameralookYofs_no	equ	-20-10	;8/24

RBcameraYofs_2		equ	70
RBcameralookYofs_2		equ	-80
RBcameralookYofs_no_2	equ	-15
RBcameralookYofs_U_2		equ	40


;-[ROBOT one screen mode]-
RB_cameraZ_offset_boost_1	equ	50
RB_cameraZ_offset_normal_1	equ	240
RB_cameraZ_offset_brake_1	equ	-50

;-[ROBOT two screen mode]-
RB_cameraZ_offset_boost	equ	50
RB_cameraZ_offset_normal	equ	260
RB_cameraZ_offset_brake	equ	-50




slopezofs	equ	-200
slopeyofs	equ	-100
transrozezofs	equ	-100

marinezofs	equ	-100
marineyofs	equ	-000

;TRANS FALL view point

transfall_y	equ	-16

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ ROBOT no kaiten no hayasa.³
;³ [ 0-128 ]                 ³
;³ normal = 5                ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

roboLRrotyinc_FOX	equ	5
roboLRrotyinc_FALCO	equ	5
roboLRrotyinc_PEPPY	equ	5
roboLRrotyinc_SLIPPY	equ	5
roboLRrotyinc_GAL1	equ	5
roboLRrotyinc_GAL2	equ	5

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	TRANSFORM TIME
waittransform	equ	2	;(PLAYER)henkei kaishi wo WAIT suru FRAME suu.
looktransform	equ	waittransform	;+16

waitflashtransform	equ	looktransform		;+16
finishflashtransform	equ	waitflashtransform	;+10
finishtransform	equ	finishflashtransform
finishtransformX	equ	finishtransform+5
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; for BATTLE START sequence

BATTLESTART_TIME	equ	50
BATTLESTART_YOFS	equ	100
BATTLESTART_ZOFS	equ	20
BATTLESTART_kaitenspeed	equ	3
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;motion No.

m_stop	equ	0
m_walkF	equ	10
m_walkB	equ	11
m_walkL	equ	12
m_walkR	equ	13
m_walkFL	equ	14
m_walkFR	equ	15
m_walkBL	equ	16
m_walkBR	equ	17
m_turnL	equ	18
m_turnR	equ	19
m_walkF1	equ	20
m_walkB1	equ	21
m_walkF2	equ	22
m_walkB2	equ	23
m_brakeF	equ	24
m_brakeB	equ	25
m_jump	equ	26
m_land	equ	27
m_walkL1	equ	28
m_walkR1	equ	29
m_thrashF	equ	30
m_thrashB	equ	31
m_thrashL	equ	32
m_thrashR	equ	33
m_thrashturnL	equ	34
m_thrashturnR	equ	35
m_walkFstart		equ	36
m_walkBstart		equ	37
m_walkL2		equ	38
m_walkR2		equ	39


m_max	equ	40	;MAX last+1
m_dummy	equ	255	;dummy code


blockmap_resolution_mask	equ	blockmap_resolution-1
blockmap_resolution_sign	equ	blockmap_resolution>>1


	include	player.inc


tutuheight_keep	equ	0
tutuheight_1024	equ	1024
tutuheight_2048	equ	2048
tutuheight_4096	equ	4096
tutuheight_8192	equ	8192

;--------------------------------------------------------------------

pad_boost	equ	pad_y
pad_brake	equ	pad_a
pad_fire	equ	pad_b
pad_spfire	equ	pad_x
pad_jump	equ	pad_a
pad_jump2	equ	pad_y
pad_foward	equ	pad_y
pad_back	equ	pad_a
pad_dush	equ	pad_a
pad_dush2	equ	pad_y
pad_swim	equ	pad_y
pad_swim2	equ	pad_a

;************

padl_boost	equ	padl_y
padl_brake	equ	padl_a
padl_fire	equ	padl_b
padl_spfire	equ	padl_x
padl_jump	equ	padl_a
padl_jump2	equ	padl_y
padl_foward	equ	padl_y
padl_back	equ	padl_a
padl_dush	equ	padl_a
padl_dush2	equ	padl_y
padl_swim	equ	padl_y
padl_swim2	equ	padl_a

;--------------------------------------------------------------------
;pad_boost	equ	pad_X
;pad_brake	equ	pad_B
;pad_fire	equ	pad_Y
;pad_spfire	equ	pad_A
;pad_jump	equ	pad_B
;pad_foward	equ	pad_X
;pad_back	equ	pad_B
;pad_dush	equ	pad_Y
;pad_dush2	equ	pad_X
;pad_swim	equ	pad_B

;************

;padl_boost	equ	padl_X
;padl_brake	equ	padl_B
;padl_fire	equ	padl_Y
;padl_spfire	equ	padl_A
;padl_jump	equ	padl_B
;padl_foward	equ	padl_X
;padl_back	equ	padl_B
;padl_dush	equ	padl_Y
;padl_dush2	equ	padl_X
;padl_swim	equ	padl_B

;--------------------------------------------------------------------
;	end of file
;--------------------------------------------------------------------

