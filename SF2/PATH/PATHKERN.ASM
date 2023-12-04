;                            �������������Ŀ
;���������������������������͵  StarFox II ������������������������������ͻ
;�                           ���������������                              �
;�  Copyright Argonaut Software Limited, 1993.                            �
;�  All Rights Reserved.                                                  �
;������������������������������������������������������������������������Ķ
;�  Filename:     PATHKERN.ASM                                            �
;������������������������������������������������������������������������Ķ
;�  Description:  Simple alien path following code.                       �
;������������������������������������������������������������������������Ķ
;�  Date:         5/4/94.                                                 �
;������������������������������������������������������������������������Ķ
;�  Author:       Dylan Cuthbert                                          �
;������������������������������������������������������������������������Ķ
;�  Modification list:                                                    �
;�  Program Kernel moved out of paths.asm in order to be able to run      �
;�  from ram.                                                             �
;�                                                                        �
;������������������������������������������������������������������������ͼ

pathinfo	=	0

	include		INC\pathmacs.inc

pathnasty	equ	1	; paths run in rom/ram nasty mode?
fastdistancecalc equ	0	; calculate distances without mario chip (average x/z)

	strats_start

	incpub	pathkern



;���������������������������������������������������������������������������
; Relocate us into ram

rampathstart	equ	*
	org	rampatharea,$8000*(rampathstart>>16)+(rampathstart&$7fff)

;���������������������������������������������������������������������������


; alvars used:
; al_sbyte1 =  used for child macros
; al_sbyte2 =  loop count
; al_sbyte3 =  general purpose count
; al_sbyte4 =  friend ID
; al_sword1 =  used for child macros
; al_sword2 =  current position in path map
; al_ptr    =  used for child and shape macros

; sflags used:
; sflag1    =  Z relative to player on
; sflag2    =  always generate vecs on
; sflag3    =  helicopter flight mode on - now used for MOVEPLAYER
; sflag4    =  space flight mode on
; sflag5    =  collision with player's weapon flag
; sflag6    =  smoke on
; sflag7    =  normal collision flag
; sflag8    =  flag macros
; sflag9    =  used by the trigger 'whenthrough'
; sflag10   =  which player is selected

friendhp_unit	=	10

pathkern_start

pathdha_istrat
	s_start_strat
	s_set_aldata	x,#10,#10
	bra	path_istrat
patht_istrat
	s_start_strat
	s_set_alsflag	x,colldisable
	s_set_alsflag	x,textobj
	s_set_aldata	x,#10,#hardAP
path_istrat
pm
	s_start_strat
	s_set_alptrs	x,.strat,hit_istrat,explode_istrat
	s_set_colltype	x,ENEMY1
	s_set_alsflag	x,shadow
	s_set_alsflag	x,notslope
	s_set_alsflag	x,pathobj
	s_set_alsflag	x,noviewcheck
	s_set_alvar		B,x,al_sbyte4,#0
	stz		pathptr
	stz		pathptr+1
;	s_set_resource	L,x,start_hit,#pathhit_istrat
.strat	LOCAL
	s_start_strat

	pnastyon

; set which player is currently selected (from sflag10)

	s_jmp_alsflag	x,sflag10,.p2sel
	ldy	playpt1
	sty	pathplayer&WM
	bra	.p1seled
.p2sel
	ldy	playpt2
	sty	pathplayer&WM
.p1seled

.strat2	LOCAL
; Set up the index register for reading parameters from the next command

	a16
	IFNE	pathcount
;	lda.l	mflags
;	and	#$20
;	beq	.noinc
	inc	pathcommandcount
.noinc
	ENDC

	lda	al_sword2,x
	sta	path_pcptr
	a8
	lda	#pathbank
	sta	path_pcptr+2

	promnastyoff
	lda.l	[path_pcptr]
	beq	.extracommands
	sta	pathparam
	promnastyon

	txy
	lda	pathparam
	a16
	and	#255
	asl	a
	asl	a
	tax
	lda.l	.table+1,x
	pha
	a8
	tyx
	rts

;---------------------------------------------------------------
; These are the extra commands prefixed by p_extracommands
; labels must be defined as 'ep_<name>', not 'p_<name>' as before

.extracommands
	PATHCMD
	a16
	inc	path_pcptr
	inc	al_sword2,x
	a8
	promnastyoff
	lda.l	[path_pcptr]
	sta	pathparam
	promnastyon

	txy
	lda	pathparam
	a16
	and	#255
	asl	a
	asl	a
	tax
	lda.l	.etable+1,x
	pha
	a8
	tyx
	rts


smt_modenum	=	0

;;;	s_mode_change	x,pathparam
;;;
;;;	s_mode_table
.table
	s_mode_entry	.extracommands,p_extracommands
	s_mode_entry	.relzon,p_reltoplayeron
	s_mode_entry	.relzoff,p_reltoplayeroff
	s_mode_entry	.wait,p_wait
	s_mode_entry	.genvon,p_alwaysgenvecson
	s_mode_entry	.genvoff,p_alwaysgenvecsoff
	s_mode_entry	.setvel,p_setvel
	s_mode_entry	.addb,p_addb
	s_mode_entry	.addw,p_addw
	s_mode_entry	.faceplayer,p_faceplayer
	s_mode_entry	.faceplayery,p_faceplayery
;	s_mode_entry	.firelaser,p_firelaser
;	s_mode_entry	.firelasercanhit,p_firelasercanhit
;	s_mode_entry	.firemissile,p_firemissile
	s_mode_entry	.setb,p_setb
	s_mode_entry	.setw,p_setw
	s_mode_entry	.findobj,p_findshape
	s_mode_entry	.faceshape,p_faceshape
	s_mode_entry	.remove,p_remove
;--;	s_mode_entry	.gotopos,p_gotopos
;--;	s_mode_entry	.gotoshapepos,p_gotoshapepos
	s_mode_entry	.explode,p_explode
	s_mode_entry	.immune,p_immune
	s_mode_entry	.spaceshipon,p_spaceshipon
	s_mode_entry	.spaceshipoff,p_spaceshipoff
;--;	s_mode_entry	.zacoon,p_zacoon
;--;	s_mode_entry	.zacooff,p_zacooff
	s_mode_entry	.distless,p_distless
	s_mode_entry	.shapedistless,p_shapedistless
	s_mode_entry	.goto,p_goto
	s_mode_entry	_pjump1,p_igoto
	s_mode_entry	.accel,p_accel
	s_mode_entry	.theend,p_end
	s_mode_entry	.hitground,p_hitground
;--;	s_mode_entry	.hitwall,p_hitwall
	s_mode_entry	.initanim,p_initanim
	s_mode_entry	.addanim,p_addanim
	s_mode_entry	.initcolanim,p_initcolanim
	s_mode_entry	.addcolanim,p_addcolanim
;--;	s_mode_entry	.debris,p_debris
	s_mode_entry	.friend,p_friend
;--;	s_mode_entry	.link,p_link
	s_mode_entry	.shapedead,p_shapedead
	s_mode_entry	.iflevel,p_iflevel
	s_mode_entry	.leftofplayer,p_leftofplayer
	s_mode_entry	.rightofplayer,p_rightofplayer
	s_mode_entry	.aboveplayer,p_aboveplayer
	s_mode_entry	.notfriend,p_notfriend
	s_mode_entry	.msg,p_msg
	s_mode_entry	.damage,p_damage
	s_mode_entry	.almostdead,p_almostdead
	s_mode_entry	.randomgoto,p_randomgoto
	s_mode_entry	.ifsameb,p_ifsameb
	s_mode_entry	.ifsameW,p_ifsameW
	s_mode_entry	.ifbetweenB,p_ifbetweenB
	s_mode_entry	.ifbetweenW,p_ifbetweenW
	s_mode_entry	.invincibleon,p_invincibleon
	s_mode_entry	.invincibleoff,p_invincibleoff
	s_mode_entry	.playerdead,p_playerdead
	s_mode_entry	.spawn,p_spawn
	s_mode_entry	.spawnlink,p_spawnlink
	s_mode_entry	.spawnchild,p_spawnchild
;--;	s_mode_entry	.zremoveon,p_zremoveon
;--;	s_mode_entry	.zremoveoff,p_zremoveoff
	s_mode_entry	.debug,p_debug
	s_mode_entry	.fire,p_fire
;--;	s_mode_entry	.firecanhit,p_firecanhit
	s_mode_entry	.fireatplayer,p_fireatplayer
;--;	s_mode_entry	.fireatplayercanhit,p_fireatplayercanhit
	s_mode_entry	.fireatshape,p_fireatshape
	s_mode_entry	.fireatshapecanhit,p_fireatshapecanhit
	s_mode_entry	.setweapon,p_weapon
	s_mode_entry	.childdead,p_childdead
	s_mode_entry	.linkchild,p_linkchild
	s_mode_entry	.flagshape,p_flagshape
	s_mode_entry	.flagchild,p_flagchild
	s_mode_entry	.flagmother,p_flagmother
	s_mode_entry	.ifflag,p_ifflag
	s_mode_entry	.text,p_text
;--;	s_mode_entry	.trail,p_trail
	s_mode_entry	.gosub,p_gosub
	s_mode_entry	.return,p_return
	s_mode_entry	.do,p_do
	s_mode_entry	.next,p_next
	s_mode_entry	.inext,p_inext
	s_mode_entry	.break,p_break
	s_mode_entry	.breakc,p_breakc
	s_mode_entry	.invisibleon,p_invisibleon
	s_mode_entry	.invisibleoff,p_invisibleoff
	s_mode_entry	.always,p_always
	s_mode_entry	.alwaysoff,p_alwaysoff
	s_mode_entry	.force,p_force
	s_mode_entry	.sprite,p_sprite
	s_mode_entry	.setvBB,p_setvBB
	s_mode_entry	.setvBW,p_setvBW
	s_mode_entry	.setvWW,p_setvWW
	s_mode_entry	.setvWB,p_setvWB
	s_mode_entry	.addvBB,p_addvBB
	s_mode_entry	.addvBW,p_addvBW
	s_mode_entry	.addvWW,p_addvWW
	s_mode_entry	.addvWB,p_addvWB
	s_mode_entry	.negB,p_negB
	s_mode_entry	.negW,p_negW

	s_mode_entry	.setrandomB,p_setrandomB
	s_mode_entry	.setrandomW,p_setrandomW
	s_mode_entry	.ifhitflag,p_ifhitflag
	s_mode_entry	.collisionson,p_collisionson
	s_mode_entry	.collisionsoff,p_collisionsoff

	s_mode_entry	.qspawn,p_qspawn
	s_mode_entry	.unlinkchild,p_unlinkchild
	s_mode_entry	.behindplayer,p_behindplayer
	s_mode_entry	.msgwithmeter,p_msgwithmeter
	s_mode_entry	.doq,p_doq

	s_mode_entry	.doalvarb,p_doalvarb
	s_mode_entry	.doalvarw,p_doalvarw
	s_mode_entry	.gosubalvar,p_gosubalvar
	s_mode_entry	.unlinkself,p_unlinkself
	s_mode_entry	.removechild,p_removechild
	s_mode_entry	.ifzerob,p_ifzerob
	s_mode_entry	.ifzerow,p_ifzerow
	s_mode_entry	.ifnotzerob,p_ifnotzerob
	s_mode_entry	.ifnotzerow,p_ifnotzerow

	s_mode_entry	.set0b,p_set0b
	s_mode_entry	.set0w,p_set0w
	s_mode_entry	.incb,p_incb
	s_mode_entry	.incw,p_incw
	s_mode_entry	.decb,p_decb
	s_mode_entry	.decw,p_decw
	s_mode_entry	.addrotx,p_addrotx
	s_mode_entry	.addroty,p_addroty
	s_mode_entry	.addrotz,p_addrotz
	s_mode_entry	.addworldx,p_addworldx
	s_mode_entry	.addworldy,p_addworldy
	s_mode_entry	.addworldz,p_addworldz
	s_mode_entry	.addws,p_addws
	s_mode_entry	.wait1,p_wait1

	s_mode_entry	p.importb,p_importb
	s_mode_entry	p.importbq,p_importbq
	s_mode_entry	p.importwq,p_importwq
	s_mode_entry	p.importw,p_importw
	s_mode_entry	p.exportb,p_exportb
	s_mode_entry	p.exportw,p_exportw
	s_mode_entry	p.exportbq,p_exportbq
	s_mode_entry	p.exportwq,p_exportwq
	s_mode_entry	p.achaseB,p_achaseB
	s_mode_entry	p.achaseW,p_achaseW
	s_mode_entry	p.waitachaseB,p_waitachaseB
	s_mode_entry	p.waitachaseW,p_waitachaseW
	s_mode_entry	p.chasevBB,p_chasevBB
	s_mode_entry	p.chasevBW,p_chasevBW
	s_mode_entry	p.chasevWW,p_chasevWW
	s_mode_entry	p.chasevWB,p_chasevWB
	s_mode_entry	p.start65816,p_start65816
	s_mode_entry	p.ifnot,p_ifnot
	s_mode_entry	p.particle,p_particle
	s_mode_entry	p.shadowon,p_shadowon
	s_mode_entry	p.shadowoff,p_shadowoff
	s_mode_entry	p.div2b,p_div2b
	s_mode_entry	p.div2w,p_div2w
	s_mode_entry	p.indexb,p_indexb
	s_mode_entry	p.indexw,p_indexw
	s_mode_entry	p.autoindexbb,p_autoindexbb
	s_mode_entry	p.pushb,p_pushb
	s_mode_entry	p.pushw,p_pushw
	s_mode_entry	p.pullb,p_pullb
	s_mode_entry	p.pullw,p_pullw

	s_mode_entry	p.withinrange,p_withinrange
	s_mode_entry	p.becomechild,p_becomechild
	s_mode_entry	p.becomeshape,p_becomeshape
	s_mode_entry	p.becomemother,p_becomemother
	s_mode_entry	p.unbecome,p_unbecome
	s_mode_entry	p.become,p_become
	s_mode_entry	p.score,p_score
	s_mode_entry	p.player1,p_player1
	s_mode_entry	p.player2,p_player2
	s_mode_entry	p.ifplayer,p_ifplayer
	s_mode_entry	p.swapplayer,p_swapplayer
	s_mode_entry	p.lockplayeron,p_lockplayeron
	s_mode_entry	p.lockplayeroff,p_lockplayeroff
	s_mode_entry	p.playerincone,p_playerincone
	s_mode_entry	p.circle,p_circle
	s_mode_entry	p.circleB,p_circleB
	s_mode_entry	p.circleW,p_circleW
	s_mode_entry	p.circleplayer,p_circleplayer
	s_mode_entry	p.circleplayerB,p_circleplayerB
	s_mode_entry	p.circleplayerW,p_circleplayerW
	s_mode_entry	p.movein,p_movein
	s_mode_entry	p.moveinB,p_moveinB
	s_mode_entry	p.moveinW,p_moveinW
	s_mode_entry	p.moveinonplayer,p_moveinonplayer
	s_mode_entry	p.moveinonplayerB,p_moveinonplayerB
	s_mode_entry	p.moveinonplayerW,p_moveinonplayerW
	s_mode_entry	p.scoreb,p_scoreb
	s_mode_entry	p.scorew,p_scorew
	s_mode_entry	p.becomeinert,p_becomeinert
	s_mode_entry	p.relativeon,p_relativeon
	s_mode_entry	p.relativeoff,p_relativeoff
	s_mode_entry	p.stampstart,p_stampstart
	s_mode_entry	p.becomechildb,p_becomechildb
	s_mode_entry	p.clearstack,p_clearstack
	s_mode_entry	p.setspweap,p_setspweap
  	s_mode_entry	p.forcejump,p_forcejump
	s_mode_entry	p.incspweap,p_incspweap
	s_mode_entry	p.ifplrarwing,p_ifplrarwing
	s_mode_entry	p.ifplrrobot,p_ifplrrobot
	s_mode_entry	p.ifplrufo,p_ifplrufo
	s_mode_entry	p.shockcam1,p_shockcam1
	s_mode_entry	p.shockcam2,p_shockcam2
	s_mode_entry	p.hitflashtrig,p_hitflashtrig
	s_mode_entry	p.begindemo,p_begindemo
	s_mode_entry	p.enddemo,p_enddemo
	s_mode_entry	p.activeon,p_activeon
	s_mode_entry	p.activeoff,p_activeoff
	s_mode_entry	p.setmarker1,p_setmarker1
	s_mode_entry	p.setmarker2,p_setmarker2
	s_mode_entry	p.ifplrfullhp,p_ifplrfullhp
	s_mode_entry	p.clippingon,p_clippingon
	s_mode_entry	p.clippingoff,p_clippingoff
	s_mode_entry	p.pool,p_pool
	s_mode_entry	p.rangecheckon,p_rangecheckon
	s_mode_entry	p.rangecheckoff,p_rangecheckoff
	s_mode_entry	p.behindkplayer,p_behindkplayer
	s_mode_entry	p.plrtunnelon,p_playertunnelon
	s_mode_entry	p.plrtunneloff,p_playertunneloff
	s_mode_entry	p.ifpilot,p_ifpilot
	s_mode_entry	p.notpilot,p_notpilot
	s_mode_entry	p.rangecheckonmap,p_rangecheckonmap
	s_mode_entry	p.rangecheckoffmap,p_rangecheckoffmap
	s_mode_entry	p.setswitch,p_setswitch
	s_mode_entry	p.clrswitch,p_clrswitch
	s_mode_entry	p.ifswitch,p_ifswitch
	s_mode_entry	p.setswitchv,p_setswitchv
	s_mode_entry	p.clrswitchv,p_clrswitchv
	s_mode_entry	p.ifswitchv,p_ifswitchv
	s_mode_entry	p.plrturnon,p_plrturnon
 	s_mode_entry	p.plrturnoff,p_plrturnoff
	s_mode_entry	p.plrforceturn,p_plrforceturn
	s_mode_entry	p.plrforceway,p_plrforceway

	s_mode_entry	p.msgalvar,p_msgalvar
	s_mode_entry	p.ifbossflagon,p_ifbossflagon
	s_mode_entry	p.ifbossflagoff,p_ifbossflagoff
	s_mode_entry	p.setbossflagon,p_setbossflagon
	s_mode_entry	p.setbossflagoff,p_setbossflagoff

	s_mode_entry	p.clrbossflag,p_clrbossflag

	s_mode_entry	p.gincb,p_gincb
	s_mode_entry	p.gincw,p_gincw
	s_mode_entry	p.gdecb,p_gdecb
	s_mode_entry	p.gdecw,p_gdecw

	s_mode_entry	p.addbg,p_addbg
	s_mode_entry	p.addwg,p_addwg
	s_mode_entry	p.addgb,p_addgb
	s_mode_entry	p.addgw,p_addgw

	s_mode_entry	p.copyplayerpos,p_copyplayerpos

	s_mode_entry	p.iflargerb,p_iflargerb
	s_mode_entry	p.iflargerw,p_iflargerw

	s_mode_entry	p.ifsamebb,p_ifsamebb
	s_mode_entry	p.ifsameww,p_ifsameww

	s_mode_entry	p.adjustrot,p_adjustrot

	s_mode_entry	p.nextbossmode,p_nextbossmode
	s_mode_entry	p.forcegosub,p_forcegosub

	s_mode_entry	.spawnchildrot0,p_spawnchildrot0

	s_mode_entry	p.radarobj,p_radarobj
	s_mode_entry	p.clrtype,p_clrtype
	s_mode_entry	.trigalways,p_trigalways
	s_mode_entry	p.initanim0,p_initanim0

	s_mode_entry	p.sounddistpos,p_sounddistpos

	s_mode_entry	p.gsetb,p_gsetb
	s_mode_entry	p.gsetw,p_gsetw

	s_mode_entry	.always_r,p_always_r

;--;	s_mode_entry	.waitfaceplayer,p_waitfaceplayer

	s_mode_entry	p.circlewindow,p_circlewindow

	s_mode_entry	p.scrflash,p_scrflash

	s_mode_table_end

	;printf	"%01%31Warning:%00%36 Path command wa ",256-smt_modenum," shika nokottenai yo!%00%n"
	printf	"%01%31Warning:%00%36 The only PATH command would be ",256-smt_modenum,"!%00%n"



smt_modenum	=	0

;;;	s_mode_change	x,pathparam
;;;
;;;	s_mode_table
.etable
	s_mode_entry	.loop,ep_loop

	s_mode_entry	.belowplayer,ep_belowplayer
	s_mode_entry	.findnextobj,ep_findnextshape

	s_mode_entry	p.autoindexbw,ep_autoindexbw
	s_mode_entry	p.sound,ep_sound
	s_mode_entry	p.sound2,ep_sound2
	s_mode_entry	p.sounddist,ep_sounddist
	s_mode_entry	p.soundpos,ep_soundpos
	s_mode_entry	p.soundnear,ep_soundnear
	s_mode_entry	p.soundnearpos,ep_soundnearpos
	s_mode_entry	p.sounddirect,ep_sounddirect
	s_mode_entry	p.soundvis,ep_soundvis

	s_mode_entry	p.fadein,ep_fadein
	s_mode_entry	p.fadeout,ep_fadeout

	s_mode_entry	.faceshapeimmediate,ep_faceshapeimmediate

	s_mode_entry	.faceplayerimmediate,ep_faceplayerimmediate

	s_mode_entry	p.setcamera,ep_setcamera
	s_mode_entry	p.setcameraimmed,ep_setcameraimmediate


	s_mode_entry	p.ifplrboost,ep_ifplrboost
	s_mode_entry	p.ifplrbrake,ep_ifplrbrake
	s_mode_entry	p.findenemyobj,ep_findenemyshape
	s_mode_entry	p.objincone,ep_objincone
;	s_mode_entry	p.objdead,ep_objdead
;	s_mode_entry	p.notobjdead,ep_notobjdead
	s_mode_entry	p.plrburn,ep_plrburn

	s_mode_entry	p.moveplayeron,ep_moveplayeron
	s_mode_entry	p.moveplayeroff,ep_moveplayeroff

	s_mode_entry	p.plrshield,ep_plrshield
	s_mode_entry	p.camrbyofs,ep_camrbyofs
	s_mode_entry	p.plrweaplevelup,ep_plrweaplevelup

	s_mode_entry	.poschildrenon,ep_poschildrenon
	s_mode_entry	.poschildrenoff,ep_poschildrenoff

	s_mode_entry	p.scenery,ep_scenery

	s_mode_entry	p.clearsequence,ep_clearsequence

	s_mode_entry	p.zdistless,ep_zdistless

	s_mode_entry	p.inplayerscone,ep_inplayerscone

	s_mode_entry	p.moveinonshape,ep_moveinonshape
	s_mode_entry	p.moveinonshapeB,ep_moveinonshapeB
	s_mode_entry	p.moveinonshapeW,ep_moveinonshapeW

	s_mode_entry	p.circleshape,ep_circleshape
	s_mode_entry	p.circleshapeB,ep_circleshapeB
	s_mode_entry	p.circleshapeW,ep_circleshapeW

	s_mode_entry	p.waitB,ep_waitB

	s_mode_entry	p.groundobjon,ep_groundobjon
	s_mode_entry	p.groundobjoff,ep_groundobjoff

	s_mode_entry	.hitflashon,ep_hitflashon
	s_mode_entry	.hitflashoff,ep_hitflashoff



	s_mode_entry	p.andframegoto,ep_andframegoto
	s_mode_entry	p.chainpos,ep_chainpos
	s_mode_entry	p.chainposalvar,ep_chainposalvar
	s_mode_entry	p.faceplayerofs,ep_faceplayerofs
	s_mode_entry	p.pweaphit,ep_pweaphit
	s_mode_entry	p.pweapinclmt,ep_pweapinclmt
	s_mode_entry	p.pweapdeclmt,ep_pweapdeclmt

	s_mode_entry	p.campanshapeimmede,ep_campanshapeimmediate
	s_mode_entry	p.campanplayerimmede,ep_campanplayerimmediate
	s_mode_entry	p.campanshape,ep_campanshape
	s_mode_entry	p.campanplayer,ep_campanplayer
	s_mode_entry	p.campandemoshapeimmede,ep_campandemoshapeimmediate
	s_mode_entry	p.campandemoshape,ep_campandemoshape
	s_mode_entry	p.demoshape,ep_demoshape
	s_mode_entry	p.clrdemoshape,ep_clrdemoshape

	s_mode_entry	p.setdemo,ep_setdemo
	s_mode_entry	p.demoend,ep_demoend
	s_mode_entry	p.demosetmap,ep_demosetmap
	s_mode_entry	p.ifdemoend,ep_ifdemoend
	s_mode_entry	p.ifnotdemo,ep_ifnotdemo
	s_mode_entry	p.ifsamedemo,ep_ifsamedemo
	s_mode_entry	p.copypos2view,ep_copypos2view
	s_mode_entry	p.copyrot2view,ep_copyrot2view
	s_mode_entry	p.copyplayerrot,ep_copyplayerrot
	s_mode_entry	p.copyrot2player,ep_copyrot2player
	s_mode_entry	p.copypos2player,ep_copypos2player
	s_mode_entry	p.ifplrweaplevel,ep_ifplrweaplevel
	s_mode_entry	p.playershape,ep_playershape
	s_mode_entry	p.setsndplace,ep_setsndplace
	s_mode_entry	p.reboundlaser,ep_reboundlaser

	s_mode_entry	.faceviewimmediate,ep_faceviewimmediate


	s_mode_entry	p.copypos2viewimmede,ep_copypos2viewimmediate
	s_mode_entry	p.copyrot2viewimmede,ep_copyrot2viewimmediate
	s_mode_entry	p.copyviewpos,ep_copyviewpos
	s_mode_entry	p.copyviewrots,ep_copyviewrots

	s_mode_entry	p.copyviewpos_demo,ep_copyviewpos_demo
	s_mode_entry	p.copyviewrots_demo,ep_copyviewrots_demo

	s_mode_entry	p.setbg,ep_setbg
	s_mode_entry	p.hitslope,ep_hitslope

	s_mode_entry	p.shiftrb,ep_shiftrb
	s_mode_entry	p.shiftrw,ep_shiftrw


	s_mode_entry	p.circlewindowpos,ep_circlewindowpos

	s_mode_entry	p.bigcirclewindow,ep_bigcirclewindow
	s_mode_entry	p.warpcirclewindow,ep_warpcirclewindow

	s_mode_entry	p.indexbw,ep_indexbw
	s_mode_entry	p.indexww,ep_indexww
	s_mode_entry	p.nextmap,ep_nextmap

	s_mode_entry	.quadvecson,ep_quadvecson
	s_mode_entry	.quadvecsoff,ep_quadvecsoff

	s_mode_entry	.setstrat,ep_setstrat

	s_mode_entry	p.ifareaout,ep_ifareaout
	s_mode_entry	p.ifplrturnon,ep_ifplrturnon
	s_mode_entry	p.ifplrturnoff,ep_ifplrturnoff
	s_mode_entry	p.plrcontroloff,ep_plrcontroloff
	s_mode_entry	p.plrcontrolon,ep_plrcontrolon

	s_mode_entry	p.wobble,ep_wobble


	s_mode_entry	.alwayscnt,ep_alwayscnt

	s_mode_entry	p.iflasttrig,ep_iflasttrig


	s_mode_entry	p.passsoundon,ep_passsoundon
	s_mode_entry	p.passsoundoff,ep_passsoundoff

	s_mode_entry	p.enemydmgSE,ep_enemydmgSE
	s_mode_entry	p.enemyrbdSE,ep_enemyrbdSE

	s_mode_entry	p.translock,ep_plrtranslock
	s_mode_entry	p.translockoff,ep_plrtranslockoff

	s_mode_entry	p.transsparwing,ep_transsparwing
	s_mode_entry	p.transgdarwing,ep_transgdarwing
	s_mode_entry	p.transrobot,ep_transrobot
	s_mode_entry	p.transufo,ep_transufo

	s_mode_entry	p.shapeinrange,ep_shapeinrange

	s_mode_entry	p.fireobjon,ep_fireobjon
	s_mode_entry	p.fireobjoff,ep_fireobjoff

	s_mode_entry	p.addrandomB,ep_addrandomB
	s_mode_entry	p.addrandomW,ep_addrandomW

	s_mode_entry	p.settype,ep_Settype

	s_mode_entry	p.setbossmode,ep_setbossmode
	s_mode_entry	p.swapvar,ep_swapvar

	s_mode_entry	p.tamehomon,ep_tamehomon
	s_mode_entry	p.iftamehomon,ep_iftamehomon
	s_mode_entry	.alwaysoff_all,ep_alwaysoff_all

	s_mode_table_end

	;printf	"%01%31Warning:%00%36 EXTRA Path command wa ",256-smt_modenum," shika nokottenai yo!%00%n" ; original romanized japanese string
	printf	"%01%31Warning:%00%36 EXTRA path command must be ",256-smt_modenum,"!%00%n"

	IFEQ	1
;**********
.zacoon	PATHCMD
	s_set_alsflag	x,sflag3
	jmp		_padd1
;**********
.zacooff	PATHCMD
	s_clr_alsflag	x,sflag3
	jmp		_padd1

	ENDC

;**********
.spaceshipoff PATHCMD
	s_clr_alsflag	x,sflag4
	jmp		_padd1
;**********
.spaceshipon	PATHCMD
	s_set_alsflag	x,sflag4
	jmp		_padd1
;**********
.relzon	PATHCMD
	s_set_alsflag	x,sflag1
	jmp		_padd1

;**********
.relzoff	PATHCMD
	s_clr_alsflag	x,sflag1
	jmp		_padd1

;**********
.wait	PATHCMD
	getparam	1
	cmp		al_sbyte3,x
	s_beq		_pzadd2
	s_inc_alvar	B,x,al_sbyte3
	jmp		.move

;**********
.wait1	PATHCMD
	s_inc_alvar	W,x,al_sword2
	jmp		.move
	
;**********
.genvon	PATHCMD
	s_set_alsflag	x,sflag2
	jmp		_padd1
;**********
.genvoff	PATHCMD
	s_clr_alsflag	x,sflag2
	jmp		_padd1

;**********
.quadvecsON	PATHCMD
	s_set_alsflag	x,quadvel
	jmp		_padd1
;**********
.quadvecsOFF	PATHCMD
	s_clr_alsflag	x,quadvel
	jmp		_padd1

;**********
.hitflashoff	PATHCMD
	s_set_alsflag	x,nohitflash
	jmp		_padd1
;**********
.hitflashon	PATHCMD
	s_clr_alsflag	x,nohitflash
	jmp		_padd1

;**********
.setvel	PATHCMD
	getparam	1
	sta		al_vel,x
	s_jmp_alsflag	x,sflag2,_padd2	; always generating vecs
	s_jsr		.genvecs
	jmp		_padd2

.genvecs
;--;	s_jmp_alsflag	x,sflag3,.norotx
	s_jmp_alsflag	x,locked,.childrot
	s_jmp_alsflag	x,childobj,.childrot
.normvecs
	s_gen_3dvecs	x,al_roty,al_rotx,al_vel
	s_jmp_alsflag	x,quadvel,.quadvel
	s_rts
.childrot
	a16
	txa
	cmp	al_childrotobj,x
	a8
	beq	.normvecs
	s_gen_3dvecs	x,al_childroty,al_childrotx,al_vel
	s_jmp_alsflag	x,quadvel,.quadvel
	s_rts
.norotx
	s_jmp_alsflag	x,locked,.childrot2
	s_gen_vecs	x,al_roty,al_vel
	s_rts
.childrot2
	s_gen_vecs	x,al_childroty,al_vel
	s_jmp_alsflag	x,quadvel,.quadvel
	s_rts
.quadvel
	a16
	asl	al_vx,x
	asl	al_vx,x
	asl	al_vy,x
	asl	al_vy,x
	asl	al_vz,x
	asl	al_vz,x
	a8
	s_rts

;**********
.loop	PATHCMD
	getparam	1
	cmp		al_sbyte2,x
	beq		.finishedloop
	s_inc_alvar	B,x,al_sbyte2
	a16
	getparam	2
	sta		al_sword2,x
	a8
	jmp		.move

.finishedloop
	stz		al_sbyte2,x
	jmp		_padd4

;********** 
.addb	PATHCMD
	addalvaroffset	1
	getparam	2
	clc
	adc.w		0,y
	sta.w		0,y
	jmp		_padd3



;**********
.addrotx	PATHCMD
	getparam	1
	clc
	adc		al_rotx,x
	sta		al_rotx,x
	jmp		_padd2

;**********
.addroty	PATHCMD
	getparam	1
	clc
	adc		al_roty,x
	sta		al_roty,x
	jmp		_padd2

;**********
.addrotz	PATHCMD
	getparam	1
	clc
	adc		al_rotz,x
	sta		al_rotz,x
	jmp		_padd2

;**********
.addworldx	PATHCMD
	getparam	1
	a16
	sexa
	clc
	adc		al_worldx,x
	sta		al_worldx,x
	jmp		_padd2

;**********
.addworldy	PATHCMD
	getparam	1
	a16
	sexa
	clc
	adc		al_worldy,x
	sta		al_worldy,x
	jmp		_padd2

;**********
.addworldz	PATHCMD
	getparam	1
	a16
	sexa
	clc
	adc		al_worldz,x
	sta		al_worldz,x
	jmp		_padd2

;**********
.addws	PATHCMD
	addalvaroffset	1
	getparam	2
	a16
	sexa
	clc
	adc.w		0,y
	sta.w		0,y
	a8
	jmp		_padd3


;**********
.addw	PATHCMD
	addalvaroffset	1
	a16
	getparam	2
	clc
	adc.w		0,y
	sta.w		0,y
	a8
	jmp		_padd4


;**********
.incb	PATHCMD
	addalvaroffset	1
	lda.w	0,y
	inc	a
	sta.w	0,y
	jmp		_padd2

;**********
.incw	PATHCMD
	addalvaroffset	1
	a16
	lda.w	0,y
	inc	a
	sta.w	0,y
	a8
	jmp		_padd2


;**********
.decb	PATHCMD
	addalvaroffset	1
	lda.w	0,y
	dec	a
	sta.w	0,y
	jmp		_padd2

;**********
.decw	PATHCMD
	addalvaroffset	1
	a16
	lda.w	0,y
	dec	a
	sta.w	0,y
	a8
	jmp		_padd2

;**********
;.waitfaceplayer	PATHCMD
;	ldy			pathplayer&WM
;	s_obj2obj_3dangle	x,y,al_roty,al_rotx,3,.slradd1
;	jsr	.setlockrot
;	jmp			.move
;.slradd1
;	jsr	.setlockrot
;	jmp		_padd1

;**********
.faceplayerimmediate	PATHCMD
	ldy			pathplayer&WM
	s_obj2obj_3dangle	x,y,al_roty,al_rotx,0
	jsr	.setlockrot
	jmp			_padd1
;**********
.faceviewimmediate	PATHCMD
	ldy			pathplayer&WM
	cpy			playpt1
	bne			.nop1v
	ldy			#viewblk1
	bra			.nop2v
.nop1v	ldy			#viewblk2
.nop2v
	s_obj2obj_3dangle	x,y,al_roty,al_rotx,0
	jsr			.setlockrot
	jmp			_padd1
;**********
.faceplayery	PATHCMD
	ldy			pathplayer&WM
	s_obj2obj_angle		x,y,al_roty,2
	jsr	.setlockrot
	jmp			_padd1

.faceplayer	PATHCMD
	ldy			pathplayer&WM
	s_obj2obj_3dangle	x,y,al_roty,al_rotx,2
	jsr	.setlockrot
	jmp			_padd1

	SHORTA
.setlockrot
	s_jmp_NOTalsflag	x,locked,.noslr
	s_set_objtobealvar	y,x,al_childrotobj
	lda	al_roty,x
	sec
	sbc.w	al_roty,y
	sta	al_childroty,x
.noslr
	rts

	IFEQ	1
;**********
.firelasercanhit	PATHCMD
	s_jsr			.flaser
	jmp			_padd1
.firelaser
	s_jsr			.flaser
	s_set_colltype		y,ENEMY1
	jmp			_padd1

.flaser
	s_weapon_pos		#0,#0,#0
	s_weapon_rot		#0,#0
	s_fire_weapon		x,RELSLOWELASER
	s_rts

;**********
.firemissile	PATHCMD
	s_weapon_pos		#0,#0,#0
	s_weapon_rot		#0,#0
	s_fire_weapon		x,HMISSILE1
	phx
	ldx			pathplayer
	s_set_alvartobeobj	y,al_ptr,x
	plx
	jmp			_padd1

	ENDC

;**********
.setweapon	PATHCMD
	getparam	1
	sta		al_weapontype,x
	jmp		_padd2

;**********
.fire	PATHCMD
	jsr	.fireit
	s_set_colltype		y,ENEMY1
	jmp		_padd1

;**********
.firecanhit	PATHCMD
	jsr	.fireit
	jmp		_padd1


;**********
.fireatplayer	PATHCMD
	jsr	.fireitatplayer
	s_set_colltype		y,ENEMY1
	s_set_colltype		y,ENEMYWEAP
	jmp	_padd1
;**********
.fireatplayercanhit	PATHCMD
	jsr	.fireitatplayer
	jmp	_padd1
;**********
.fireitatplayer	PATHCMD
	jsr	.fireit
	phx
	ldx			pathplayer&WM
	s_set_alvartobeobj	y,al_ptr,x
	plx
	rts


;**********
.fireatshape	PATHCMD
	jsr	.fireitatshape
	s_set_colltype		y,ENEMY1
	s_set_colltype		y,ENEMYWEAP
	jmp	_padd1

;**********
.fireatshapecanhit	PATHCMD
	jsr	.fireitatshape
	jmp	_padd1

;**********
.fireitatshape	PATHCMD
	jsr	.fireit
	phx
	a16
	lda	al_ptr,x
	tax
	a8
	s_set_alvartobeobj	y,al_ptr,x
	plx
	rts

;**********
.fireit	PATHCMD
	pnastyoff
	s_weapon_pos	#0,#0,#0
	s_weapon_rot	#0,#0
	s_fire_weapon	x,CURRENT
	sty		becomelastobj&WM
	s_rts


;**********
.addvBW	PATHCMD
.addvBB	SHORTA
	phx
	jsr		.getxyalvars

	lda.w		0,x
	clc
	adc.w		0,y
	sta.w		0,y

	plx
	jmp		_padd3

;**********
.addvWW	PATHCMD
	phx
	jsr		.getxyalvars

	a16
	lda.w		0,x
	clc
	adc.w		0,y
	sta.w		0,y

	plx
	jmp		_padd3


;**********
.addvWB	PATHCMD
	phx
	jsr		.getxyalvars

	lda.w		0,x
	a16
	sexa
	clc
	adc.w		0,y
	sta.w		0,y

	plx
	jmp		_padd3


;**********
.setvBB	PATHCMD
	phx
	jsr		.getxyalvars

	lda.w		0,x
	sta.w		0,y

	plx
	jmp		_padd3

;**********
.setvWW	PATHCMD
	phx
	jsr		.getxyalvars

	a16
	lda.w		0,x
	sta.w		0,y

	plx
	jmp		_padd3

;**********
.setvBW	PATHCMD
	phx
	jsr		.getxyalvars

	a16
	lda.w		0,x
	a8
	sta.w		0,y

	plx
	jmp		_padd3

;**********
.setvWB	PATHCMD
	phx
	jsr		.getxyalvars

	a8
	lda.w		0,x
	a16
	sexa
	sta.w		0,y

	plx
	jmp		_padd3

;* * * * * *
.getxyalvars	LOCAL
	php
	a8
	addalvaroffset	2
	phy
	addalvaroffset	1
	plx
	plp
	rts



;**********
.setb	PATHCMD
	addalvaroffset	2
	a8
	getparam	1
	sta.w		0,y
	jmp		_padd3

;**********
.setw	PATHCMD
	addalvaroffset	3
	a16
	getparam	1
	sta.w		0,y
	a8
	jmp		_padd4

;**********
.set0b	PATHCMD
	addalvaroffset	1
	a8
	lda	#0
	sta.w	0,y
	jmp		_padd2

;**********
.set0w	PATHCMD
	addalvaroffset	1
	a16
	lda		#0
	sta.w		0,y
	a8
	jmp		_padd2

;**********
.findobj	PATHCMD
	a16
	getparam	1
	sta		pathx1
	a8
	ldy		allst
	s_set_find	y
	s_find_nearobj	y,x,pathx1,#0,#7000,.notfound
.found	sty		al_ptr,x
	jmp		_padd3
.notfound
	stz		al_ptr,x
	stz		al_ptr+1,x
	jmp		_padd3

;**********
.findnextobj	PATHCMD
	a16
	getparam	1
	sta		pathx1
	a8
	ldy		al_ptr,x
	s_beq		.fnotfound
	a16
	lda.w		_next,y
	tay
	a8
	beq		.fnotfound
	s_set_find	y
	s_find_nearobj	y,x,pathx1,#0,#7000,.fnotfound
.fnofound	sty		al_ptr,x
	jmp		_padd3
.fnotfound
	stz		al_ptr,x
	stz		al_ptr+1,x
	jmp		_padd3

;**********
.faceshape	PATHCMD
	s_set_objtobealvar	y,x,al_ptr
	s_beq			_padd1
	s_obj2obj_3dangle	x,y,al_roty,al_rotx,3,_padd1
	jmp			_padd1

;**********
.faceshapeimmediate	PATHCMD
	s_set_objtobealvar	y,x,al_ptr
	s_beq			_padd1
	s_obj2obj_3dangle	x,y,al_roty,al_rotx,0,_padd1
	jmp			_padd1

;**********
.removechild	PATHCMD
	getparam	1
	sta		pathx1
	phx
	s_jmp_alsflag	x,motherobj,.ok
	s_set_objtobemother	y,x
	tyx
.ok
	s_set_objtobechild	y,x,pathx1

	s_remove_obj		y

	plx
	jmp		_padd2


;**********
.remove	PATHCMD
	s_remove_obj	x
	jmp			.end

;**********
.explode	PATHCMD
	lda	al_sbyte4,x
	beq	.notfriend2
	a16
	and	#255
	tay
	a8
	lda	#0
	sta.w	friends_HP-1,y
.notfriend2
	s_jmp_NOTalsflag	x,motherobj,.normexplode

	ldy	al_sword1,x
.nxtobjtoremex
	cpy	#0
	beq	.normexplode
	a16
	lda.w	al_sword1,y
	pha
	a8
	s_kill_obj	y
	ply
	bra	.nxtobjtoremex
	
.normexplode
	s_kill_obj		x
	jmp			.end2



;**********
.gotopos	PATHCMD
	IFEQ	1
	a16
	getparam	1
	sta		pathx1
	getparam	3
	sta		pathy1
	getparam	5
	sta		pathz1

	getparam	7
	and		#255
	sta		pathz2

	a8

	ldy			pathplayer
	s_set_WP		x,y,1,pathx1,pathy1,pathz1

	jsr			reltoplayer

	s_goto_WP		x,x,1,pathz2,20,2,0,#300,#0,.continue
	jmp		.dontaddvecs
.continue
	ENDC
	jmp		_padd8


;**********
.gotoshapepos	PATHCMD
	IFEQ	1
	a16
	getparam	1
	sta		pathx1
	getparam	3
	sta		pathy1
	getparam	5
	sta		pathz1

	getparam	7
	and		#255
	sta		pathz2

	a8

	s_set_objtobealvar	y,x,al_ptr
	s_beq			.continue2
	s_set_WP		x,y,1,pathx1,pathy1,pathz1
	jsr			reltoplayer
	s_goto_WP		x,x,1,pathz2,1,2,0,#300,#0,.continue2
	jmp		.dontaddvecs
.continue2
	ENDC
	jmp		_padd8


;**********
.immune	PATHCMD
	ldy	pathplayer&WM
	s_make_immune

	jmp		_padd1


;**********
.distless	PATHCMD
	a16
	getparam	1
	sta		pathx1
	a8
	ldy		pathplayer&WM
.distmoreorless
	jsr	.getdistance

	lda	pifnot
	beq	.dlpos
	stz	pifnot

	a16
	lda	pathz1
	cmp	pathx1
	s_bcs	_pjump3
	jmp	_padd5
	
.dlpos
	a16
	lda	pathz1
	cmp	pathx1
	s_bcc	_pjump3
	jmp	_padd5

;�������������������������������������������������
; get distance of y from x => pathz1.16
;�������������������������������������������������
.getdistance	LOCAL

	IFNE	fastdistancecalc
	a16

	lda.w	al_worldx,y
	sec
	sbc	al_worldx,x
	bpl	.noneg
	nega
.noneg	sta	x1
	
	lda.w	al_worldz,y
	sec
	sbc	al_worldz,x
	bpl	.noneg2
	nega
.noneg2
	clc
	adc	x1
	lsr	a
	sta	pathz1

	a8


	ELSEIF
	a8
	poll_mario

	a16
	lda.w	al_worldx,y
	sec
	sbc	al_worldx,x
	sta.l	m_bigx

;	lda.w	al_worldy,y
;	sec
;	sbc	al_worldy,x
	lda	#0
	sta.l	m_bigy

	lda.w	al_worldz,y
	sec
	sbc	al_worldz,x
	sta.l	m_bigz

	a8
	phx
	call_mario	mveclen	; calculate length into m_z1
	plx

	a16
	lda.l	m_z1
	sta	pathz1
	a8

	unpoll_mario
	ENDC
	rts

;**********
.shapedistless	PATHCMD
	a16
	getparam	1
	sta		pathx1
	a8
	s_set_objtobealvar	y,x,al_ptr
	s_beq			_padd5
	brl			.distmoreorless

;**********
.goto	PATHCMD
	a16
	getparam	1
	sta		al_sword2,x
	a8
	jmp		.move


;**********
.accel	PATHCMD
	getparam	1
	sta		al_count,x
	getparam	2
	sta		al_count1,x
	jmp		_padd3

;**********
.hitground	PATHCMD
	a16
	getparam 1
	clc
	adc	al_worldy,x
	a8
	php
	lda	pifnot
	beq	.hgpos
	stz	pifnot
	plp
	s_bpl	_padd5
	jmp	_pjump3
.hgpos
	plp
	s_bmi	_padd5
	jmp	_pjump3


;**********
.hitwall	PATHCMD
	a16
	lda	maxpmoveX
	sec
	sbc	minpmoveX
	sta	x1
	lda	al_worldx,x
	sec
	sbc	minpmoveX
	cmp	x1
	s_bcs	_pjump1
	lda	maxpmoveY
	sec
	sbc	minpmoveY
	sta	x1
	lda	al_worldy,x
	sec
	sbc	minpmoveY
	cmp	x1
	s_bcs	_pjump1
	jmp	_padd3


;**********
.initanim	PATHCMD
	getparam	1
	sta		pathx1
	s_init_anim	x,pathx1
	jmp		_padd2

;**********
.addanim	PATHCMD
	getparam	1
	sta		pathx1
	getparam	2
	sta		pathx2
	s_add_anim	x,pathx1,pathx2
	jmp		_padd3

;**********
.initcolanim	PATHCMD
	getparam	1
	sta		pathx1
	s_init_colanim	x,pathx1
	jmp		_padd2

;**********
.addcolanim	PATHCMD
	getparam	1
	sta		pathx1
	getparam	2
	sta		pathx2
	s_add_colanim	x,pathx1,pathx2
	jmp		_padd3

;**********
.debris	PATHCMD
	a16
	getparam	1
	sta		pathx1

	a8

;	s_set_debrisdata	x,pathx1

	jmp		_padd3

;**********
.friend	PATHCMD
	IFEQ	1

	getparam	1
	cmp		#friend_anyone
	beq		.randomselect
	a16
	and		#255
	tay
	a8
	lda.w		friends_hp-1,y
	s_beq		.nonealive
	tya
	jmp		.okdok
.randomselect

	lda		cock
	beq		.5050bunnyfrog
	lda		frog
	beq		.4060cockbunny
	lda		bunny
	beq		.4060cockfrog
.404020frogbunnycock
	jsl		random_l	; 20% falco, 40% frog/bunny
	cmp		#50
	bcc		.cock
	cmp		#150
	bcc		.bunny
	bra		.frog
.4060cockbunny
	lda		bunny
	beq		.cock
	s_jmp_random	.cock,40
	bra		.bunny
.4060cockfrog
	s_jmp_random	.cock,40
	bra		.frog
.5050bunnyfrog
	lda		frog
	beq		.nooneleft
	lda		bunny
	beq		.frog
	s_jmp_random	.frog
	jmp		.bunny

.nooneleft
	lda		bunny
	beq		.nonealive
.bunny	lda		#friend_rabbit
	bra		.okdok
.frog	lda		#friend_frog
	bra		.okdok
.cock	lda		#friend_falcon
.okdok
	sta		al_sbyte4,x
	jmp		_padd2
.nonealive
	ENDC
	jmp		_padd2

;**********
.link	PATHCMD
	ldy	pathlink
	bne	.setshape
	stx	pathlink
	jmp	_padd1
.setshape
	sty	al_ptr,x
	stx	al_ptr,y
	stz	pathlink
	stz	pathlink+1
	jmp	_padd1

;**********
.shapedead	PATHCMD
	ldy	al_ptr,x
	s_beq	_pjump1
	jmp	_padd3

;**********
.iflevel	PATHCMD

	IFEQ	1

	lda	pifnot
	beq	.ilpos
	stz	pifnot
	getparam	1
	dec		a
	cmp		currentlevel
	s_beq		_padd4
	jmp		_pjump2
.ilpos
	getparam	1
	dec		a
	cmp		currentlevel
	s_bne		_padd4
	ENDC

	jmp		_pjump2

;**********
.leftofplayer	PATHCMD
	txy
	ldx	pathplayer&WM

	lda	#127
	sta	x1
	stz	y1
	stz	z1

	pnastyoff

	jsl	whichside2_l
	tyx
	bit	#128
	beq	.alljump
	jmp	_padd3

;**********
.rightofplayer	PATHCMD
	txy
	ldx			pathplayer&WM

	lda	#127
	sta	x1
	stz	y1
	stz	z1

	pnastyoff

	jsl	whichside2_l
	tyx
	bit	#128
	bne	.alljump
	jmp	_padd3

;**********
.behindplayer	PATHCMD

	pnastyoff
	phx
	txy
	ldx	pathplayer&WM
	jsl	whichside_l
	plx
	bit	#128
	bne	.alljump

	jmp	_padd3
;**********
.aboveplayer	PATHCMD
	ldy			pathplayer&WM

	a16
	lda.w	al_worldy,y
	cmp	al_worldy,x
	bpl	.alljump
	a8
	jmp	_padd3

;**********
.belowplayer	PATHCMD
	ldy			pathplayer&WM

	a16
	lda.w	al_worldy,y
	cmp	al_worldy,x
	bmi	.alljump
	a8
	jmp	_padd3

.alljump	jmp	_pjump1

;**********
.notfriend	PATHCMD
	lda	pifnot
	beq	.nfpos
	stz	pifnot
	getparam	1
	cmp		#friend_anyone
	bne		.daijobu2

	lda		al_sbyte4,x
	s_beq		_padd4
.daijobu2
	cmp		al_sbyte4,x
	s_beq		_pjump2
	jmp		_padd4
.nfpos
	getparam	1
	cmp		#friend_anyone
	bne		.daijobu

	lda		al_sbyte4,x
	beq		.jumpit2

.daijobu
	cmp		al_sbyte4,x
	s_beq		_padd4
.jumpit2	jmp		_pjump2

;**********
.msg	PATHCMD
	getparam	1
	phx
	sta	pathx1
	pnastyoff
	lda	pathx1
	jsl		FriendMessage_l
	plx
	jmp		_padd2

;**********
.msgwithmeter
	PATHCMD
	IFEQ	1
	lda	#-1
	sta	friends_meter
	getparam	1
	phx
;	jsl		send_message_l
	plx
	ENDC
	jmp		_padd2

;**********
.almostdead	PATHCMD
	lda		al_sbyte4,x
	beq		.nocando2
	a16
	and		#255
	tay
	a8
	lda.w		friends_hp-1,y
	cmp		#friendHP_unit+1
	bcs		.nocando2
	jmp		_pjump1
.nocando2
	jmp		_padd3

;**********
.damage	PATHCMD
	lda		al_sbyte4,x
	beq		.nocando
	a16
	and		#255
	tay
	a8
	lda.w		friends_hp-1,y
	sec
	sbc		#friendHP_unit
	bcs		.nozero
	lda		#0
.nozero
	sta.w		friends_hp-1,y

.nocando	jmp		_padd1


;**********
.poschildrenon	PATHCMD
	s_clr_alsflag	x,sflag6
	jmp		_padd1

;**********
.poschildrenoff	PATHCMD
	s_set_alsflag	x,sflag6
	jmp		_padd1


;**********
.theend	PATHCMD
	s_set_altype	x,zremove
	s_set_strat	x,.move
	jmp		.move

;**********
.randomgoto	PATHCMD
	s_jmp_random	.alljump
	jmp		_padd3

;**********
.ifzerob	PATHCMD
	addalvaroffset	1
	lda.w		0,y
	s_beq		_pjump2
	jmp		_padd4

;**********
.ifzerow	PATHCMD
	addalvaroffset	1
	a16
	lda.w		0,y
	s_beq		_pjump2
	jmp		_padd4

;**********
.ifnotzerob	PATHCMD
	addalvaroffset	1
	lda.w		0,y
	s_beq		_padd4
	jmp		_pjump2


;**********
.ifnotzerow	PATHCMD
	addalvaroffset	1
	a16
	lda.w		0,y
	s_beq		_padd4
	jmp		_pjump2

;**********
.ifsameb	PATHCMD
	addalvaroffset	1
	getparam	2
	cmp.w		0,y
	php
	lda		pifnot
	beq		.isbpos
	stz		pifnot	
	plp
	s_beq		_padd5
	jmp		_pjump3

.isbpos	plp
	s_bne		_padd5
	jmp		_pjump3

;**********
.ifsamew	PATHCMD
	addalvaroffset	1
	a16
	getparam	2
	cmp.w		0,y
	a8
	php
	lda		pifnot
	beq		.iswpos
	stz		pifnot	
	plp
	s_beq		_padd6
	jmp		_pjump4

.iswpos	plp
	s_bne		_padd6
	jmp		_pjump4


;**********
.ifbetweenb	PATHCMD
	addalvaroffset	1
	lda		pifnot
	beq		.ibbpos
	stz		pifnot	
	getparam	2
	cmp.w		0,y
	s_bpl		_pjump4
	getparam	3
	cmp.w		0,y
	s_bmi		_pjump4
	jmp		_padd6
.ibbpos
	getparam	2
	cmp.w		0,y
	s_bpl		_padd6
	getparam	3
	cmp.w		0,y
	s_bmi		_padd6
	jmp		_pjump4



;**********
.ifbetweenw	PATHCMD
	addalvaroffset	1
	lda		pifnot
	beq		.ibwpos
	stz		pifnot

	a16
	getparam	2
	cmp.w		0,y
	s_bpl		_pjump6
	getparam	4
	cmp.w		0,y
	s_bmi		_pjump6
	jmp		_padd8

.ibwpos
	a16
	getparam	2
	cmp.w		0,y
	s_bpl		_padd8
	getparam	4
	cmp.w		0,y
	s_bmi		_padd8
	jmp		_pjump6

;**********
.invincibleon	PATHCMD
	s_set_alsflag	x,nohitaffect
	jmp		_padd1

;**********
.invincibleoff	PATHCMD
	s_clr_alsflag	x,nohitaffect
	jmp		_padd1
	

;**********
.playerdead	PATHCMD

	test_playerdead	1
	rlbne	_pjump1
	jmp	_padd3

;	s_test_var	B,pshipflags2,#psf2_playerHP0
;	s_bne		.alljump
;	s_test_var	B,gameflags,#gf_playerdying
;	s_beq		_padd3
;
;	jmp		.alljump

;**********
.spawnchild	PATHCMD
.spawnchildrot0
; shape:
	lda		pathparam
	sta		pathz2
	a16
	getparam	1
	sta		pathx2

	lda		pathz2
	cmp		#p_spawnchild
	beq		.normalspawn
; otherwise rotation x,y,z are set to zero

; rot x,y,z:
	stz		pathx3
	stz		pathy3
	stz		pathz3

; x,y,z:
	a16
	getparam	7
	sta		pathx1
	getparam	9
	sta		pathy1
	getparam	11
	sta		pathz1
	a8

; childnum:
	getparam	13
	sta		pathy2
	bra		.contwithspawn

.normalspawn
; rot x,y,z:
	a8
	getparam	5
	sta		pathx3
	getparam	6
	sta		pathy3
	getparam	7
	sta		pathz3
; x,y,z:
	a16
	getparam	10
	sta		pathx1
	getparam	12
	sta		pathy1
	getparam	14
	sta		pathz1
	a8
; childnum:
	getparam	16
	sta		pathy2

.contwithspawn
	s_push_var	W,allst
	stx		allst

	phx
; if the original object is already a child then create a 'brother'
	s_jmp_NOTalsflag	x,childobj,.ok53
	s_set_objtobemother	y,x
	tyx
.ok53
	s_make_childobjrotpos	pathx2,pathy2,pathx1,pathy1,pathz1,pathx3,pathy3,pathz3,path_istrat,ENEMY1
	sty		becomelastobj&WM

	plx
; tell it which object to rotate around
	a16
	txa
	sta.w		al_childrotobj,y
	a8

	s_pull_var	W,allst

	a8
; hp,ap:
	lda		pathz2	; command id
	cmp		#p_spawnchild
	beq		.normalspawn2

	getparam	5
	sta.w		al_hp,y
	getparam	6
	sta.w		al_ap,y
	bra		.contwithspawn2

.normalspawn2
	getparam	8
	sta.w		al_hp,y
	getparam	9
	sta.w		al_ap,y
.contwithspawn2

	s_jmp_NOTalsflag	x,sflag10,.dontset
	s_set_alsflag		y,sflag10
.dontset

	lda		al_area,x
	sta.w		al_area,y

; path map:
	a16
	getparam	3
	sta.w		al_sword2,y

	lda	pathz2
	cmp	#p_spawnchild
	lbeq	_padd17
	jmp	_padd14

;**********
.spawnlink	PATHCMD
	s_jsr		.makeit
	sty	al_ptr,x
	cpy	#0
	s_beq	_padd17
	stx	al_ptr,y	; link the shapes together
	jmp		_padd17


;**********
.qspawn	PATHCMD
	a16
	getparam	1
	sta	pathx1
	getparam	3
	sta	pathx2
	a8
	s_push_var	W,allst
	stx		allst
	s_make_obj	pathx1,.cantdo2

	sty		becomelastobj&WM

	s_pull_var	W,allst

	s_set_strat	y,path_istrat
	s_set_alvar	W,y,al_sword2,pathx2

	s_copy_pos	y,x
	s_copy_rots	y,x

	getparam	5
	sta.w	al_hp,y
	getparam	6
	sta.w	al_ap,y

	s_jmp_NOTalsflag	x,sflag10,.dontset2
	s_set_alsflag		y,sflag10
.dontset2

	lda	al_area,x
	sta.w	al_area,y

	jmp	_padd7

.cantdo2	s_pull_var	W,allst
	jmp	_padd7

;**********
.spawn	PATHCMD
	s_jsr		.makeit
	jmp		_padd16

.makeit
	a16
	getparam	1
	sta		pathx1
	getparam	3
	sta		pathy2
	a8
	s_push_var	W,allst
	stx		allst
	s_make_obj	pathx1,.cantdo
	sty		becomelastobj&WM
	s_pull_var	W,allst
	s_set_strat	y,path_istrat
	s_set_alvar	W,y,al_sword2,pathy2
	getparam	5
	clc
	adc		al_rotx,x
	sta.w		al_rotx,y
	getparam	6
	clc
	adc		al_roty,x
	sta.w		al_roty,y
	getparam	7
	clc
	adc		al_rotz,x
	sta.w		al_rotz,y
	getparam	8
	sta.w		al_hp,y
	getparam	9
	sta.w		al_ap,y

	lda		al_area,x
	sta.w		al_area,y	; inherit mother's area

	a16
	getparam	10
	sta		pathx1
	getparam	12
	sta		pathy1
	getparam	14
	sta		pathz1
	a8

	s_add_Roffs2pos	B,y,x,x,pathx1,pathy1,pathz1,1,1,1,2,2,2

	rts
.cantdo	s_pull_var	W,allst
	ldy	#0
	rts


;**********
.debug	PATHCMD
	pnastyoff
	blink
;**********
.zremoveon	PATHCMD
	s_set_altype	x,zremove
	jmp		_padd1

;**********
.zremoveoff	PATHCMD
	s_clr_altype	x,zremove
	jmp		_padd1


;**********
.childdead	PATHCMD
	getparam	1
	sta		pathx1
	phx
	s_jmp_alsflag	x,motherobj,.okmother	; am I mother?

	s_set_objtobemother	y,x		; if child
	tyx					; set x to be mother
	s_beq		.cannaedojim2
.okmother
	s_jmp_childrendead	x,pathx1,.cdjump2
.cannaedojim2
	plx
	jmp	_padd4
.cdjump2	plx
	jmp	_pjump2

;**********
.linkchild	PATHCMD
	getparam	1
	sta		pathx1

	s_set_objtobechild	y,x,pathx1

	cpy	#0
	s_beq	_padd2

	a16
	tya
	cmp	al_ptr,x
	a8
	s_beq	_padd2

	a16
	lda.w	al_ptr,y
	sta	pathx1
	lda	al_ptr,x
	sty	al_ptr,x	; link it in
	sta.w	al_ptr,y
	a8

	phx
	tyx
	jsl	find_alptr_l	; get one in list behind
	ldx	pathx1
	stx	al_ptr,y
	plx

;**********
.flagchild	PATHCMD
	getparam	1
	sta		pathx1

	phx
	s_jmp_alsflag	x,motherobj,.fcmother
	s_set_objtobemother	y,x
	tyx
	cpy	#0
	beq		.cannaedojim
.fcmother

	s_set_objtobechild	y,x,pathx1
.cannaedojim
	plx
	cpy	#0
	s_beq	_padd2

	s_set_alsflag	y,sflag8	; flag it
	jmp		_padd2


;**********
.unlinkself	PATHCMD
	s_jmp_NOTalsflag	x,childobj,_padd1
	s_set_objtobemother	y,x
	s_remove_child	x,y
	jmp		_padd1
;**********
.unlinkchild	PATHCMD
	getparam	1
	sta		pathx1

	phx
	s_jmp_alsflag	x,motherobj,.ulcmother
	s_set_objtobemother	y,x
	tyx
	cpy	#0
	beq		.ulccannaedojim
.ulcmother

	s_set_objtobechild	y,x,pathx1
.ulccannaedojim
	plx
	cpy	#0
	s_beq	_padd2

	phx
	s_set_objtobemother	x,y
	s_remove_child		y,x
	plx

	jmp		_padd2


;**********
.flagmother	PATHCMD

	s_set_objtobemother	y,x
	cpy	#0
	s_beq		_padd1
	s_set_alsflag	y,sflag8	; flag it
	jmp		_padd1

;**********
.flagshape	PATHCMD

	s_set_objtobealvar	y,x,al_ptr
	cpy	#0
	s_beq		_padd1
	s_set_alsflag	y,sflag8	; flag it
	jmp		_padd1

;**********
.ifflag	PATHCMD
	s_jmp_NOTalsflag	x,sflag8,_padd3
	s_clr_alsflag	x,sflag8
	jmp		_pjump1


;**********
.text	PATHCMD
	a16
	getparam	1
	sta	pathx1
	a8
	getparam	3
	sta	pathy1
	getparam	4
	sta	pathz1

	s_text_obj	x,pathx1,pathy1,pathz1

	jmp	_padd5


;**********
.trail	PATHCMD
	getparam	1
	sta		al_ty,x
	jmp		_padd2

;**********
.gosubalvar	PATHCMD
	inc	pathgosubcount

	addalvaroffset	1
	s_dec_alvar	W,x,al_sword2
	s_mpush		W,x,x,al_sword2
	a16
	lda.w		0,y
	sta.w		al_sword2,x
	a8
	jmp		.strat

;**********
.gosub	PATHCMD
	inc	pathgosubcount
	s_mpush		W,x,x,al_sword2
	jmp		_pjump1
;**********
.return	PATHCMD
	ldy		pathptr
	beq		.nottrigger
	dec		pathgosubcount
	s_beq		.finishedtrigger
.nottrigger
	s_mpull		W,x,x,al_sword2
	jmp		_padd3

;**********
.doalvarb	PATHCMD
	a16
	lda	al_sword2,x
	inc	a
	inc	a
	a8
	s_mpush		W,x,A

	addalvaroffset	1

	a16
	lda.w		0,y
	and		#255
	a8
	s_mpush		W,x,A

	jmp		_padd2

;**********
.doalvarw	PATHCMD
	a16
	lda	al_sword2,x
	inc	a
	inc	a
	a8
	
	s_mpush		W,x,A

	addalvaroffset	1

	a16
	lda.w		0,y
	a8
	s_mpush		W,x,A

	jmp		_padd2
	

;**********
.doq	PATHCMD
	a16
	lda		al_sword2,x
	inc		a
	inc		a
	a8
	s_mpush		W,x,A
	a16
	getparam	1
	and	#255
	a8

	s_mpush		W,x,A

	jmp		_padd2

;**********
.do	PATHCMD
	a16
	lda		al_sword2,x
	clc
	adc		#3
	a8
	s_mpush		W,x,A
	a16
	getparam	1
	a8

	s_mpush		W,x,A

	jmp		_padd3

;**********
.next	PATHCMD
; get the topmost entry from the stack:
	a16
	ldy	al_stackptr,x
	lda.w	heap,y
	and	#255
	dec	a
	asl	a
	asl	a
	sty	pathx1
	sec
	adc	pathx1
	tay
	lda	heap,y
	dec	a
	beq	.endnext
	sta	heap,y

	dey
	dey
	dey
	dey

	lda	heap,y
	sta	al_sword2,x

	a8
	jmp	.move

; old method: (slow)
;	s_mpull		W,x,pathx1
;	a16
;	dec	pathx1
;	a8
;	beq	.endnext
;	s_mpull	W,x,x,al_sword2
;	s_mpush	W,x,x,al_sword2	; push it back on for next time
;
;	s_mpush	W,x,pathx1
;
;	jmp	.move

.endnext	a8
	s_mpull	W,x,pathx1
	s_mpull	W,x,pathx1	; remove the two entries on the stack
	jmp		_padd1

;**********
.inext	PATHCMD
;	s_mpull		W,x,pathx1
; get the topmost entry from the stack:
	a16
	ldy	al_stackptr,x
	lda.w	heap,y
	and	#255
	dec	a
	asl	a
	asl	a
	sty	pathx1
	sec
	adc	pathx1
	tay
	lda	heap,y
	dec	a
	beq	.endnext
	sta	heap,y

	dey
	dey
	dey
	dey

	lda	heap,y
	sta	al_sword2,x

;	s_mpull	W,x,x,al_sword2
;	s_mpush	W,x,x,al_sword2	; push it back on for next time

;	s_mpush	W,x,pathx1
	a8
	jmp	.strat


;**********
.break	PATHCMD
	s_mpull		W,x,pathx1
	s_mpull		W,x,pathx1	; restore stack
	jmp		_pjump1


;**********
.breakc	PATHCMD
	s_mpull		W,x,pathx1
	s_mpull		W,x,pathx1	; restore stack
	jmp	_padd1

;**********
.invisibleon	PATHCMD
	s_set_alsflag	x,invisible
	s_set_alsflag	x,colldisable
	jmp	_padd1

;**********
.invisibleoff	PATHCMD
	s_clr_alsflag	x,invisible
	s_clr_alsflag	x,colldisable
	jmp	_padd1


;**********
.trigalways	PATHCMD
	stz	pathx3
	lda	#trigger_always
	sta	pathy3
	jsr	.always_in
	brl	_padd3
;**********
.alwayscnt
	PATHCMD
	getparam	3
	sta	pathy3
	getparam	4
	inc	a
	sta	pathx3
	jsr	.always_in
	brl	_padd5
;**********
.always_r	PATHCMD
	stz	pathx3
	getparam	2
	sta	pathy3
	getparam	1
	a16
	and	#255
	clc
	adc	al_sword2,x
	jsr	.always_in2
	brl	_padd3
;**********
.always	PATHCMD
	stz	pathx3
	getparam	3
	sta	pathy3
	jsr	.always_in
	brl	_padd4
;- - - - - -
.always_in
	a16
	getparam	1
.always_in2
	sta	pathz3
	a8
	s_jmp_alvarNOTZERO	W,x,al_stratmem,.freeit
	s_alloc			x,y,#5
	lda	#1
	sta	heap,y		; one routine stored
	a16
	lda	pathz3
;;;;	getparam	1
	sta	heap+1,y	; store the address
	a8
	lda	pathy3
	sta	heap+3,y	; store trigger
	lda	pathx3
	sta	heap+4,y	; store the count
	a16
	tya
	sta			al_stratmem,x
	a8
	rts
; already some routines running so free up the space and allocate a larger area
.freeit
	ldy	al_stratmem,x
	lda	heap,y
	inc	a		; allow one more entry
;;	sta	pathz1
	asl	a		; *4
	asl	a		; *4
;;	clc
;;	adc	pathz1
	inc	a		; allow count byte
	sta	pathx1
	stz	pathx1+1

	a16
	lda	al_stratmem,x
	eor	#-1
	inc	a
	clc
	adc	triggerloopptr
	sta	triggerloopptr	; preserve trigger loop
	
	s_alloc	x,y,pathx1	; allocate new buffer

	phx
	sty	pathx2		; pathx2 = new list
	ldy	al_stratmem,x	; pointer to old list
	ldx	pathx2		; x = new list

	lda	heap,y		; get count (count from old list)
	sta	pathx1		; store it in temporary
	inc	a		; inc it
	sta	heap,x		; and store it in new list
	iny
	inx			; skip first byte (ie. count)
.nxtcopy
	lda	heap,y
	sta	heap,x
	lda	heap+1,y
	sta	heap+1,x	; copy address
	lda	heap+2,y
	sta	heap+2,x	; and trigger flag
	lda	heap+3,y
	sta	heap+3,x	; and count value
	inx
	inx
	inx
	inx
	iny
	iny
	iny
	iny
	dec	pathx1
	bne	.nxtcopy

	stx	pathy1	; points to last entry
	plx

	ldy	al_stratmem,x
	s_free	x,y

	a16
	lda	pathx2	; points to beginning
	sta	al_stratmem,x
	clc
	adc	triggerloopptr
	sta	triggerloopptr	; adjust the trigger loop's pointer
	a8

	a16
	lda	pathz3
;;;;	getparam	1
	ldy	pathy1
	sta	heap,y
	a8
	lda	pathy3
	sta	heap+2,y	; store the trigger
	lda	pathx3
	sta	heap+3,y	; clear the count
	rts

;**********
.alwaysoff_all	PATHCMD
	ldy	al_stratmem,x
	s_free	x,y
	stz	al_stratmem,x
	stz	al_stratmem+1,x

	lda	#1
	sta	triggerloopcnt
	jmp	_padd1
;**********
.alwaysoff	PATHCMD
	a16
	getparam	1
	sta		pathx3
	stz		pathy3
	a8

	jsr		.remove_always
	jmp		_padd3

; - - - - - - -
.remove_always	LOCAL
	PATHCMD
	ldy	al_stratmem,x
	beq	.ret123
	lda	heap,y
	cmp	#1
	bne	.carryon

	a16
	lda	pathx3
	cmp	heap+1,y
	beq	.noret123
.ret123
	rts
.noret123			; if the only trigger left isn't
			; the same as the one specified with P_TRIGGER OFF
			; then don't delete it
			; this is for path programmers who forget
			; what trigger's they've turned off
			; not mentioning anyone inparticular...
	s_free	x,y
	stz	al_stratmem,x
	stz	al_stratmem+1,x
	rts
.carryon
	sta	pathx1
	stz	pathx1+1
	a16
	lda	pathy3
	beq	.findit
	tay
	bra	.foundit
.findit
	lda	pathx3	; the trigger we're looking to remove

	iny
.findroutine
	cmp	heap,y
	beq	.foundit
	iny
	iny
	iny
	iny
	dec	pathx1
	bne	.findroutine
; cant find the routine so return
	rts
.foundit
	sty	pathy1	; store pointer to routine to be removed
	tya
; now here comes the hack to allow triggers to be removed from within
; other trigger routines (including itself)
	dec	a
	cmp	triggerloopptr
	bcs	.deccnt
	dec	triggerloopptr
	dec	triggerloopptr
	dec	triggerloopptr
	dec	triggerloopptr
	cmp	triggerloopptr
	bcc	.nochg
.deccnt
	a8
	dec	triggerloopcnt
	bne	.nochg
	inc	triggerloopcnt
	
.nochg	a16

	ldy	al_stratmem,x	; y = beginning of list

	lda	heap,y
	and	#255	; get count
	dec	a
	a8
	sta	heap,y	; store the count
	a16
;	sta	pathx1	; store the count again
	asl	a
	asl	a
;	clc
;	adc	pathx1	; multiply it by 4
	clc
	adc	al_stratmem,x	; add the base address
	inc	a		; allow for count
	sta	pathy2
	ldy	pathy1	; restore pointer to routine to be removed
	a8
	bra	.jumpin
.shiftthemdown
	lda	heap+4,y
	sta	heap,y
	iny
.jumpin
	cpy	pathy2
	bne	.shiftthemdown
	rts


;**********
.force	PATHCMD
	ldy	pathptr
	s_beq	_padd3	; not within trigger routine

	lda	#1
	sta	pathforced

	lda	#0
	sta	al_sbyte3,x	; clear P_WAIT variable
	sta	al_sbyte2,x	; clear P_LOOP variable

	s_set_strat	x,pm.strat

	a16
	getparam	1
	sta	pathptr
	jmp	_padd3


;**********
.sprite	PATHCMD
	getparam	1
	sta		pathx1
	getparam	2
	sta		pathy1
	s_sprite_obj	x,pathx1,pathy1
	jmp		_padd3

;**********
.setstrat	PATHCMD
	a16
	getparam	1
	sta	al_stratptr,x
	a8
	getparam	3
	sta	al_stratptr+2,x
	s_mode_change	x,#0
	s_set_alvar	W,x,al_sword2,#0
	jmp	.move

;**********
.negB	PATHCMD
	addalvaroffset	1
	lda.w	0,y
	eor	#-1
	inc	a
	sta.w	0,y
	jmp	_padd2

;**********
.negW	PATHCMD
	addalvaroffset	1
	a16
	lda.w	0,y
	eor	#-1
	inc	a
	sta.w	0,y
	jmp	_padd2

;**********
.setrandomB	PATHCMD
	getparam	2
	sta	pathz1	; store the mask

	addalvaroffset	1
	jsl	random_l
	and	pathz1
	sta.w	0,y
	
	jmp	_padd3

;**********
.setrandomW	PATHCMD
	a16
	getparam	2
	sta	pathz1	; store the mask
	a8
	addalvaroffset	1
	jsl	random_l
	xba
	jsl	random_l
	a16
	and	pathz1
	sta.w	0,y
	
	jmp	_padd4
	

;**********
.ifhitflag	PATHCMD
	getparam	3
	sta		pathx1

	s_test_hitflags	x,pathx1
	s_beq		_padd4		; none hit

	s_clr_hitflags	x,pathx1	; clear them

	jmp	_pjump1

;**********
.collisionson PATHCMD
	s_clr_alsflag	x,colldisable
	jmp	_padd1

;**********
.collisionsoff PATHCMD
	s_set_alsflag	x,colldisable
	jmp	_padd1


	


;--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
;--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
;--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
;--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
;--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

; path routines continued after the break

;--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
;--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
;--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
;--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

;--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

.triggers	LOCAL
	SHORTA
	a8
	lda	pathptr
	ora	pathptr+1
	beq	.daijobu34
	blink	3	; whoops who's causing a frame wait within a trigger?
.daijobu34
	ldy	al_sword2,x
	sty	pathptr

	ldy	al_stratmem,x
	s_beq	.nothingdoing
	lda	heap,y
	s_beq	.nothingdoing
	iny

.nxttrig	sta	triggerloopcnt
	sty	triggerloopptr

	pnastyon

	lda	heap+3,y	; check the count
	beq	.nocnt
	dec	a
	sta	heap+3,y	; dec and store
	sta	triggercount
	bne	.nocnt		; no need to remove yet

	a16
	lda	heap,y
	sta	pathx3
	sty	pathy3
	a8
	jsr	pm.remove_always
	brl	.nxtone	

.nocnt

	phx
	lda	heap+2,y
	a16
	and	#255
	asl	a
	tax
	a8
	jmp	(.tab&WM,x)
.tab	dw	.gosubit&WM
	dw	.2&WM
	dw	.4&WM
	dw	.8&WM
	dw	.16&WM
	dw	.32&WM
	dw	.64&WM
	dw	.128&WM
	dw	.hit&WM
	dw	.playerhit&WM
	dw	.flagged&WM
	dw	.whenshapedead&WM
	dw	.whendead&WM
	dw	.whenthrough&WM
	dw	.whensteppedon&WM
	dw	.belowsea&WM
	dw	.abovesea&WM
	dw	.timer&WM

;---------
.timer
	plx
	phx
	lda	triggercount
	dec	a
	lbne	.dontgosubit
	jmp	.gosubit
;---------
.belowsea
	plx
	phx
	phy
	ldy	pathplayer&WM
	sp_ifinseatrig	y,.gosubitply
	ply
	jmp	.dontgosubit
;---------
.abovesea
	plx
	phx
	phy
	ldy	pathplayer&WM
	sp_ifoutseatrig	y,.gosubitply
	ply
	jmp	.dontgosubit
;---------
.whensteppedon
	plx
	phx
	phy
	ldy	playpt1
	beq	.nop1
	sp_jmp_playertype	y,robot,.okcheck
	bra	.nop1
.okcheck
	a16
	txa
	cmp	al_slopeptr,y
	a8
	bne	.nop1
	lda	al_slopenum,x
	cmp	al_slopenum,y
	lbne	.nop1
	s_jmp_alsflag	y,ontheground,.sp1
.nop1

	ldy	playpt2
	beq	.nop2
	sp_jmp_playertype	y,robot,.okcheck2
	bra	.nop2
.okcheck2
	a16
	txa
	cmp	al_slopeptr,y
	a8
	bne	.nop2
	lda	al_slopenum,x
	cmp	al_slopenum,y
	lbne	.sp2
	s_jmp_alsflag	y,ontheground,.sp1

.nop2
	
	ply
	brl	.dontgosubit
;---------
.whenthrough
	plx
	phx
	phy

	POLL_MARIO

	s_jmp_alsflag	x,sflag9,.noinit
; first time, so initialise...
	s_set_alsflag	x,sflag9


	ldy	playpt1
	beq	.oneway1
	jsl	whichside_l
	bit	#128
	beq	.clrflag1
	s_set_alsflag	x,whichside_player1
	bra		.oneway1
.clrflag1
	s_clr_alsflag	x,whichside_player1
.oneway1

	ldy	playpt2
	beq	.oneway2
	jsl	whichside_l
	bit	#128
	beq	.clrflag2
	s_set_alsflag	x,whichside_player2
	bra		.oneway2
.clrflag2
	s_clr_alsflag	x,whichside_player2
.oneway2

.noinit
;-----------------------------------------------------------
; check if the player has swapped side
	ldy	playpt1
	beq	.okway1
	jsl	whichside_l
	bit	#128
	beq	.clrway1
	s_jmp_alsflag	x,whichside_player1,.okway1
	jmp	.setp1
.clrway1	s_jmp_alsflag x,whichside_player1,.setp1
.okway1

;------------- and of course player 2

	ldy	playpt2
	beq	.okway2
	jsl	whichside_l
	bit	#128
	beq	.clrway2
	s_jmp_alsflag	x,whichside_player2,.okway2
	jmp	.setp2
.clrway2	s_jmp_alsflag x,whichside_player2,.setp2
.okway2

	UNPOLL_MARIO

	ply
	brl	.dontgosubit
.setp1
	s_clr_alsflag	x,sflag9
	UNPOLL_MARIO
.sp1	ldy	playpt1
	sty	pathplayer&WM
	s_clr_alsflag	x,sflag10
	ply
	brl	.gosubit
.setp2	s_clr_alsflag	x,sflag9
	UNPOLL_MARIO
.sp2	ldy	playpt2
	sty	pathplayer&WM
	s_set_alsflag	x,sflag10
.gosubitply	ply
	brl	.gosubit
;---------
.whendead
	plx
	phx
	s_jmp_alvarZERO		B,x,al_hp,.gosubit
	brl			.dontgosubit
;---------
.whenshapedead
	plx
	phx
	s_jmp_alvarNOTZERO	W,x,al_ptr,.dontgosubit
	s_jmp			.gosubit
;---------
.flagged
	plx
	phx
	s_jmp_NOTalsflag	x,sflag8,.dontgosubit
	s_clr_alsflag		x,sflag8
	bra			.gosubit
;---------
.playerhit
	plx
	phx
	phy
	s_jmp_alsflag		x,hitbyplayer1,.sp1
	s_jmp_alsflag		x,hitbyplayer2,.sp2
	ply
	bra			.dontgosubit
;---------
.hit
	plx
	phx
	s_jmp_NOTalsflag	x,sflag7,.dontgosubit
	bra	.gosubit
;---------
.2	lda	#1
	bra	.framestuff
;---------
.4	lda	#3
	bra	.framestuff
;---------
.8	lda	#7
	bra	.framestuff
;---------
.16	lda	#15
	bra	.framestuff
;---------
.32	lda	#31
	bra	.framestuff
;---------
.64	lda	#63
	bra	.framestuff
;---------
.128	lda	#127
	bra	.framestuff

.framestuff
	and	gameframe
	beq	.gosubit
	bra	.dontgosubit
.gosubit
	plx
	phx

	pnastyon

	stz	pathforced
	lda	#1
	sta	pathgosubcount

;	a16
;	lda		#-1
;	s_mpush		W,x,A	; store return address
	a16
	lda		heap,y	; get gosub routine's addr
	sta		al_sword2,x
	a8
	jmp	pm.strat		; do it!
;	s_mpull		W,x,pathx1
.finishedtrigger
.dontgosubit
	plx
.nxtone
	ldy	triggerloopptr
	iny
	iny
	iny
	iny
	a8
	lda	triggerloopcnt
	dec	a
	s_bne	.nxttrig

	lda	pathforced
	beq	.noclr
	cmp	#1
	beq	.clrit

; if not 1 then this must be a FORCEGOSUB
	a16
	dec	pathptr
	dec	pathptr
	dec	pathptr
	a8
	s_mpush	W,x,pathptr	; push the return address
	a8
	ldy	pathgosubptr	; set the new execution address
	sty	al_sword2,x
	bra	.okset

.clrit
	jsr	p._clearstack
.noclr
	ldy	pathptr
	sty	al_sword2,x
.okset
.nothingdoing
	stz	pathptr
	stz	pathptr+1
	rts

;--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
	SHORTA
.move	LOCAL
	pnastyon

	s_jmp_alvarZERO		B,x,al_count1,.noaccel

	lda		al_vel,x
	cmp		al_count,x
	bmi		.incit
	sec
	sbc		al_count1,x
	cmp		al_count,x
	bpl		.finish
	lda		al_count,x
	bra		.finish2
.incit	clc
	adc		al_count1,x
	cmp		al_count,x
	bmi		.finish
	lda		al_count,x
.finish2	sta		al_vel,x
	stz		al_count1,x
	bra		.finish3
.finish	sta		al_vel,x
.finish3

	s_jmp_alsflag	x,sflag2,.noaccel
	s_jsr		.genvecs
.noaccel

	s_jmp_NOTalsflag	x,sflag4,.norely

	lda	al_rotz,x
	adiv2
	adiv2
	clc
	adc	al_roty,x
	sta	al_roty,x

.norely

;--;	s_jmp_NOTalsflag	x,sflag3,.norelvel
;--;
;--;	lda	al_rotx,x
;--;	sta	al_vel,x
;--;
;--;	s_jmp_alsflag	x,sflag2,.norelvel
;--;	s_jsr		.genvecs
;--;
.norelvel
	jsr	reltoplayer
	s_jmp_NOTalsflag	x,sflag2,.dontalwaysgenvecs
	s_jsr			.genvecs
.dontalwaysgenvecs
	s_jmp_alsflag		x,childobj,.dontaddvecs
	s_jmp_alsflag		x,locked,.dontaddvecs
	s_add_vecs2pos		x
.dontaddvecs

	s_jmp_NOTalsflag	x,sflag6,.nosmoke
;;	s_make_smoke		2,.nosmoke
.nosmoke
;;	s_jmp_NOTalsflag	x,textobj,.notrail
;;	s_jmp_alvarZERO		B,x,al_ty,.notrail

;;	s_make_obj		#nullshape,.notrail
;;	s_copy_rots		y,x
;;	s_copy_pos		y,x
;;	s_copy_alvar2alvar	W,y,al_coltab,x,al_coltab ; text string
;;	s_copy_alvar2alvar	B,y,al_tx,x,al_tx	; text size
;;	s_copy_alvar2alvar	B,y,al_depthoffset,x,al_ty ; colour
;;	s_set_alsflag		y,textobj
;;	s_set_alsflag		y,colldisable
;;	s_set_strat		y,trail_istrat
.notrail
.end2
	jsr			.triggers

	s_jmp_alsflag		x,sflag6,.notmother	; don't rotate
	s_jmp_NOTalsflag	x,motherobj,.notmother
	s_rotpos_allchildren	x
.notmother
	s_jmp_alsflag		x,childobj,.childvecs
	s_jmp_NOTalsflag	x,locked,.notlocked
.childvecs
	s_add_alvars		W,x,al_childx,x,al_vx
	s_add_alvars		W,x,al_childy,x,al_vy
	s_add_alvars		W,x,al_childz,x,al_vz

;;	s_track_obj		x,4
.notlocked

	s_jmpNOT_alsflag	x,sflag3,.notmoveplayer

	ldy	pathplayer&WM

	s_jmpNOT_alsflag	y,ontheground,.m_nomove
	a16
	txa
	cmp	al_slopeptr,y
	a8
	beq	.m_mp
.m_nomove
	lda	#0
	sta	al_mx,x		; clear the 'init' flag
	bra	.notmoveplayer
.m_mp
	lda	al_mx,x		; do we need to initialize?
	beq	.initonly
	jsr	p.moveplayer
.initonly
	jsr	p.moveplayerinit
.notmoveplayer

.end	s_clr_alsflag		x,sflag7
	s_clr_alsflag		x,sflag5
	s_clr_alsflag		x,hitbyplayer1
	s_clr_alsflag		x,hitbyplayer2
;;	pnastyoff
	s_end_strat


;--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

reltoplayer	SHORTA
	LONGI

	s_jmp_NOTalsflag	x,sflag1,.noplayerpathz2

	ldy	pathplayer&WM
	pl_jmpnot_ifturn	y,.nodox

	a16

	lda	player1_vx
	clc
	adc	al_worldx,x
	sta	al_worldx,x

.nodox	a16

;	lda.w	al_vy,y
;	clc
;	adc	al_worldy,x
;	sta	al_worldy,x

	lda	player1_vz
	clc
	adc	al_worldz,x
	sta	al_worldz,x
	a8
.noplayerpathz2
	rts


;--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
;--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
;--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
;--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
;--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
;
;  Path routines - service resumed.
;
; set parent label

p


;**********
.importb	LOCAL
	PATHCMD
	jsr	.import
	lda		pathx2
	sta.w		0,y
	jmp		_padd4

;**********
.importbq	LOCAL
	PATHCMD
	jsr	.importq
	lda		pathx2
	sta.w		0,y
	jmp		_padd3

;**********
.importw	LOCAL
	PATHCMD
	jsr	.import
	a16
	lda		pathx2
	sta.w		0,y
	jmp		_padd4

;**********
.importwq	LOCAL
	PATHCMD
	jsr	.importq
	a16
	lda		pathx2
	sta.w		0,y
	jmp		_padd3

;**********
.exportb	LOCAL
	PATHCMD
	jsr	.export
	a8
	lda	pathx2
	sta.w	0,y
	jmp	_padd4

;**********
.exportw	LOCAL
	PATHCMD
	jsr	.export
	LONGA
	lda	pathx2
	sta.w	0,y
	jmp	_padd4

;**********
.exportbq	LOCAL
	PATHCMD
	jsr	.export
	LONGA
	and	#255
	tay
	a8
	lda	pathx2
	sta.w	path_zero_page,y
	jmp	_padd3

;**********
.exportwq	LOCAL
	PATHCMD
	jsr	.export
	LONGA
	and	#255
	tay
	lda	pathx2
	sta.w	path_zero_page,y
	jmp	_padd3

; * * * * *
.export	LOCAL
	SHORTA
	addalvaroffset	1
	a16
	lda.w		0,y
	sta		pathx2
	getparam	2
	tay
	rts


;* * * * * *
.import	LOCAL
	a16
	getparam	2
	tay
	lda.w		0,y
	sta		pathx2

	a8
	addalvaroffset	1
	rts

;* * * * * *
.importq	LOCAL
	getparam	2
	a16
	and	#255
	tay
	lda.w		path_zero_page,y
	sta		pathx2

	a8
	addalvaroffset	1
	rts


;**********
.achaseB	LOCAL
	PATHCMD
	getparam	1
	sta		pathy1

	addalvaroffset	2

	lda.w		0,y
	sta		pathx1

	s_achase_var	B,pathx1,pathy1,3

	lda		pathx1
	sta.w		0,y
	jmp		_padd3

;**********
.achaseW	LOCAL
	PATHCMD
	a16
	getparam	1
	sta		pathy1

	a8
	addalvaroffset	3
	a16

	lda.w		0,y
	sta		pathx1

	a8
	s_achase_var	W,pathx1,pathy1,3
	a16
	lda		pathx1
	sta.w		0,y
	a8
	jmp		_padd4


;**********
.waitachaseB	LOCAL
	PATHCMD
	getparam	1
	sta		pathy1

	addalvaroffset	2

	lda.w		0,y
	sta		pathx1

	s_achase_var	B,pathx1,pathy1,3,.wacbfin

	lda		pathx1
	sta.w		0,y
	jmp		pm.move
.wacbfin

	lda		pathx1
	sta.w		0,y
	jmp		_padd3

;**********
.waitachaseW	LOCAL
	PATHCMD
	a16
	getparam	1
	sta		pathy1

	a8
	addalvaroffset	3
	a16
	lda.w		0,y
	sta		pathx1

	a8
	s_achase_var	W,pathx1,pathy1,3,.wacwfin
	a16
	lda		pathx1
	sta.w		0,y
	a8
	jmp		pm.move
.wacwfin
	a16
	lda		pathx1
	sta.w		0,y
	a8
	jmp		_padd4


;**********
.chasevBW	LOCAL
	PATHCMD
.chasevBB	LOCAL
	SHORTA
	phx
	jsr		pm.getxyalvars

	lda.w		0,y
	sta		pathx1

	lda.w		0,x
	sta		pathy1

	s_achase_var	B,pathx1,pathy1,3
	lda.w		pathx1
	sta.w		0,y

	plx
	jmp		_padd3

;**********
.chasevWW	LOCAL
	PATHCMD
	phx
	jsr		pm.getxyalvars

	a16
	lda.w		0,y
	sta		pathx1

	lda.w		0,x
	sta		pathy1

	a8
	s_achase_var	W,pathx1,pathy1,3
	a16
	lda.w		pathx1
	sta.w		0,y

	plx
	jmp		_padd3


;**********
.chasevWB	LOCAL
	PATHCMD
	pnastyoff
	phx
	jsr		pm.getxyalvars

	lda.w		0,x
	a16
	sexa
	sta		pathy1
	lda.w		0,y
	sta		pathx1
	a8
	s_achase_var	W,pathx1,pathy1,3
	a16
	lda.w		pathx1
	sta.w		0,y

	plx
	jmp		_padd3


;**********
.start65816	LOCAL
	PATHCMD
	phx
	phb
	php

; push return address
	lda	#.ret>>16
	pha
	pea	.ret&WM-1

; push 65816 code address
	lda	#pathbank
	pha

	a16
	lda	al_sword2,x
	pha
	a8

	lda	#$7e
	pha
	plb

	pnastyoff
	rtl
.ret
	plp
	plb
	plx
	a16
	sta	al_sword2,x
	a8
	jmp	pm.strat

;**********
.ifnot	LOCAL
	PATHCMD
	s_set_var	B,pifnot,#1
	jmp	_padd1

;**********
.particle	LOCAL
	PATHCMD
	s_make_obj	#nullshape,.couldnt
	s_set_alsflag		y,active
	s_set_alsflag		y,notslope
	s_set_alsflag		y,noviewcheck
	s_set_alsflag		y,partobj
	getparam	1
	sta.w		al_sbyte3,y
	getparam	2
	sta.w		al_sbyte1,y
	s_set_alvar	B,x,al_sbyte2,#60
	getparam	3
	sta.w		al_count1,y
	s_set_alsflag		y,colldisable
	s_set_strat		y,explode_strat
	s_copy_pos		y,x
.couldnt	jmp	_padd4

;**********
.shadowon	LOCAL
	PATHCMD
	s_set_alsflag	x,shadow
	jmp		_padd1

;**********
.shadowoff	LOCAL
	PATHCMD
	s_clr_alsflag	x,shadow
	jmp		_padd1


;**********************************************************************************
;======================================================================
;kawaguchi path macro start
;'95/1/25
.fadein	LOCAL
	shorta
	longi
	km_setval	stayblack,1
	km_setval	fadedir,2
	km_setval	fade,6
	jmp	_padd1

;**********
;'95/1/25
.fadeout	LOCAL
	shorta
	longi
	km_qfadestepdown
	jmp	_padd1

;**********
..demo_sound	LOCAL
	shorta
	longi
	phy
	sta	kmwork
	stz	kmwork+1
	ldy	playpt1
	jsr	.sound_sub
	ply
	rts
;**********
visangle equ	$20

.behindkplayer	LOCAL
	PATHCMD
;;;;	pnastyoff	;ROM Access OK

	ldy	pathplayer&WM
	jsr	.calcangle

;;;	lda.w	al_roty,y	;* debug *
;;;	sta.w	kw_swork+0

;;;;	lda.l	m_cnt+1
	xba
;;;	sta.w	kw_swork+1	;* debug *
	clc
	adc.w	al_roty,y	;player camera angle

;;;	sta.w	kw_swork+2	;* debug *
	cmp	#visangle	;22.5 do
	bcc	..visible_bp
	cmp	#-visangle+1	; do
	bcs	..visible_bp
..behind_bp
	jmp	_pjump1
..visible_bp
	jmp	_padd3
;===============
.calcangle
; Xreg :Enemy  alloc pointer
; Yreg :Player alloc pointer
	php
	a16
	longi
	lda.w	al_worldx,x	;enemy  postion X
	sec
	sbc.w	al_worldx,y	;player postion X
	sta	x1

	lda.w	al_worldz,x	;enemy  postion Z
	sec
	sbc.w	al_worldz,y	;player postion Z
	sta	y1
	jsl	arctan16_l
	plp
	rts
;---------------------------------------------
;*	Set Player View Pointer		*
;---------------------------------------------
.set_viewptr
;** player 1 **
	shorta
	longi
	ldy	pathplayer&WM
	s_jmp_alsflag	y,player2,..player2
..player1
	ldy	#viewblk1	;player 1 camera angle
	bra	..skipaaa
..player2
	ldy	#viewblk2	;player 2 camera angle
..skipaaa
	rts
;**********
.sound	LOCAL	;[sound label]
	PATHCMD
;NOTE :<shitei shita sound label no oto wo narasu>
      ;<tadashi angle wa Center de kyori wa Near>
;  kmwork :sound number

	getparam	1
	sta	kmwork
	stz	kmwork+1
;;;;	pnastyoff	;ROM Access OK
;* player 1 *
;;;	ldy	playpt1
	ldy	pathplayer&WM
	jsr	.sound_sub

	ifeq	1
	km_bitcheckgameflag	battle
	beq	..notbattle
;* player 2 *
	ldy	playpt2
	jsr	.sound_sub
..notbattle
	endc

	jmp	_padd2
;**********
.sounddirect	LOCAL		;[sound label,LCR&dist flag]
;NOTE :<shitei shita sound label no oto wo narasu>
;      :<distance & Angle wo tyokusetu shitei dekiru>
	PATHCMD
	getparam	1
	sta	kmwork
	getparam	2
	sta	kmwork+1
;;;;	pnastyoff	;ROM Access OK
;* player 1 *
;;;	ldy	playpt1
	ldy	pathplayer&WM	;playpt1
	jsr	.sound_sub

	ifeq	1
	km_bitcheckgameflag	battle
	beq	..dir_notbattle
;* player 2 *
	ldy	playpt2
	jsr	.sound_sub
..dir_notbattle
	endc

	jmp	_padd3
;===========
.sound_sub
;  kmwork   :sound number
	a16
	longi
	lda	kmwork
.setport3_path
;in : Acc :Sound Number & Flag
	longa
	longi

	phx
	ldx	sdspt3
	cpy	playpt1		;player1 pointer
	beq	..player1_path
	cpy	#viewblk1	;camera (pl1) pointer
	beq	..player1_path
	ora	#ksf_plmode<<8	;player2 flag on
..player1_path
	sta	sdport3,x
	a8
	lda	sdspt3
	inc	a
	inc	a
	and	#$1f
	sta	sdspt3
	plx
	rts

;**********
.soundnear	LOCAL	;[sound label]
	PATHCMD
;NOTE :<sound near dist>
;      :<Near Distance ni itara CenterNear no otowo rarasu>
;  kmwork   :sound base number
;  kmwork+2 :sound number
;  kmwork+3 :sound flag
;  kmwork+4 :sound dist flag	= 0  (dist near check only)
;  kmwork+6 :enemy alloc pointer

	getparam	1
	sta	kmwork
	stz	kmwork+4	;set sound dist near flag

;;;;	pnastyoff	;ROM Access OK
;* player 1 *
;;;	ldy	playpt1
	ldy	pathplayer&WM
	jsr	.sounddist_sub

	ifeq	1
	km_bitcheckgameflag	battle
	beq	..notbattle_near
;* player 2 *
	ldy	playpt2
	jsr	.sounddist_sub
..notbattle_near
	endc
	jmp	_padd2

;**********
.sounddist	LOCAL
;NOTE :<View no nakani itara CenterNear,CenterMiddle,Far>
;      :<no dorekano otowo narasu>

	PATHCMD
;  kmwork   :sound base number
;  kmwork+2 :sound number
;  kmwork+3 :sound flag
;  kmwork+4 :sound dist flag	= 1  (dist:near,middle,far)
;  kmwork+6 :enemy alloc pointer

	getparam	1
	sta	kmwork
	lda	#1
	sta	kmwork+4	;set sound dist flag

;;;;	pnastyoff
;** player 1 **
	jsr	.set_viewptr
	jsr	.sounddist_sub

	ifeq	1
	km_bitcheckgameflag	battle
	beq	..nobattle_dist
;** player 2 **
	ldy	#viewblk2	;player 2 camera angle
	jsr	.sounddist_sub
..nobattle_dist
	endc
	jmp	_padd2

;**********
.sounddistpos	LOCAL
;NOTE :<View naini itara narasu
;     :<LN,CN,RN,LM,CM,RN,F no izureka wo narasu>
	PATHCMD
;  kmwork   :sound base number
;  kmwork+2 :sound number
;  kmwork+3 :sound flag
;  kmwork+4 :sound dist flag	=2  (dist:near,middle,far & postion)
;  kmwork+6 :enemy alloc pointer

	getparam	1
	sta	kmwork
	lda	#2
	sta	kmwork+4	;set sound dist pos flag

;;;	pnastyoff
;** player 1 **
	jsr	.set_viewptr
;;;	ldy	#viewblk1	;player 1 camera angle
	jsr	.sounddist_sub

	ifeq	1
	km_bitcheckgameflag	battle
	beq	..nobattle_distpos
;** player 2 **
	ldy	#viewblk2	;player 2 camera angle
	jsr	.sounddist_sub
..nobattle_distpos
	endc
	jmp	_padd2

;**********
.soundvis	LOCAL
	PATHCMD
;NOTE :0~180 do no otodake LN,CN,RN wo check  shite narasu (VIEW yori maedake)

;  kmwork   :sound base number
;  kmwork+2 :sound number
;  kmwork+3 :sound flag
;  kmwork+4 :sound dist flag	=3  (visible)
;  kmwork+6 :enemy alloc pointer
	getparam	1
	sta	kmwork

	lda	#3
	sta	kmwork+4	;set sound dist pos flag

;;;	pnastyoff
;** player 1 **
	jsr	.set_viewptr
;;;;	ldy	#viewblk1	;player 1 camera angle
	jsr	.sounddist_sub

	ifeq	1
	km_bitcheckgameflag	battle
	beq	..nobattle_vis
;** player 2 **
	ldy	#viewblk2	;player 2 camera angle
	jsr	.sounddist_sub
..nobattle_vis
	endc
	jmp	_padd2

;==============
.sounddist_sub
;* init:Xreg     :arien pointer
;      :Yreg     :player pointer
;      :kmwork   :sound base number
;      :kmwork+2 :sound number
;      :kmwork+3 :sound flags
;      :kmwork+4 :sound dist flag	:(0/1/2 :normal /pos /near)
;      :kmwork+6 :enemy alloc pointer

	shorta
	longi
	php
	phx

	lda	kmwork
	sta	kmwork+2	;sound number copy
	stz	kmwork+3	;sound flag 0 clear
	stx	kmwork+6	;enemy alloc pointer

;** visible check **
;EXIT :pathz1 MAX DIST = ddb2 (56754) {(x,y,z)=(7fff,7fff,7fff)}
	jsr	pm.getdistance
	a16
	lda	pathz1
;;;;	lda.l	m_z1
	tax			;Xreg <--- DISTANCE
;;;;	sta	kw_swork+4	;DEBUG :DISTANCE
;	cmp	#snddist_view	;viewradius
	a8
;	bcc	..visible_dist
;	brl	..end_dist

..visible_dist

;** player 1 or 2 check **
	IFEQ	1
	lda	#0
	cpy	#viewblk1	;playpt1	
	beq	..player1_dist
..player2_dist
	ora	#ksf_plmode
..player1_dist
	sta	kmwork+3	;player 2 flag on
	ENDC

;** dist check **
	shorta
	lda	kmwork+4	;0/1/2/3 ... near dist /dist /dist&pos/vis
	beq	..sndneardist	;kmwork+4 = 0
	bra	..snddist	;kmwork+4 = 1,2,3

;-- near dist only ---
..sndneardist
	cpx	#snddist_near
	bcc	..sndtrigset	;length < 600
	bra	..end_dist

;-- distance (near,middle,far) --
..snddist
	lda	kmwork+3
	cpx	#snddist_near	;length =  600
	bcc	..near_dist
	cpx	#snddist_far	;length = 1200
	bcc	..mid_dist
..long_dist
	ora	#ksf_far
	sta	kmwork+3
	bra	..sndtrigset
..mid_dist
	ora	#ksf_midC
..near_dist
	sta	kmwork+3

	lda	kmwork+4	;1/2/3 ... near dist /dist /dist&pos/visible
	dec	a
	beq	..sndtrigset	;if kmwork+4 = 1 then ..sndtrigset

;-- distance & postion --
..snddistpos
	shorta
	ldx	kmwork+6	;Xreg <--- enemy pointer
	jsr	.anglecheck

;** sound trigger set **
..sndtrigset
	a16
	lda	kmwork+2
	cmp	#$ffff
	beq	..end_dist	;moshi kmwork_2,3 = -1 dattra
;	sta.w	kw_swork+6	;Debug :Sound Number & Flag

	jsr	.setport3_path
..end_dist
	plx
	plp
	rts

;**********
.soundpos	LOCAL
	PATHCMD
;NOTE :<VIEW no nakani iru otowo LN,CN,RN ni wakete Narasu.>
;    kmwork    :sound base number
;    kmwork+2  :sound number
;    kmwork+4  :pos flag
;    kmwork+6  :dist length

	PHY
	ldy	#5120		;snddist_view	;viewradius	;visible range
	bra	.check_soundpos
;**********
.soundnearpos	LOCAL
;NOTE :< Near distance no nakani iru oto wo LN,CN,RN no izurekade narasu>
	PATHCMD
;    kmwork    :sound base number
;    kmwork+2  :sound number
;    kmwork+4  :pos flag
;    kmwork+6  :dist length

	PHY
	ldy	#snddist_near
;----------------
;* common routine
;----------------
.check_soundpos
	getparam	1
	sta	kmwork	 ;sound number get
;;;;	pnastyoff	 ;ROM Access OK

	stz	kmwork+4 ;sound pos check (normal)
	sty	kmwork+6 ;CHECK DISTANCE
;* player 1 *
	jsr	.set_viewptr
;;;;	ldy	#viewblk1	;playpt1
	jsr	.soundpos_sub
	ifeq	1
	km_bitcheckgameflag	battle
	beq	..nobattle
;* player 2 *
	ldy	#viewblk2	;playpt2
	jsr	.soundpos_sub
..nobattle
	endc
	PLY
	jmp	_padd2

;=================
.soundpos_sub
;* init:Yreg        :player camera pointer
;      :Xreg        :arien pointer
;      :kmwork   (W):sound base number
;      :kmwork+2 (W):sound number& flags
;      :kmwork+4 (W):sound pos (angle) flag
;      :kmwork+6 (W):sound dist
	shorta
	longi

	php
	lda	kmwork
	sta	kmwork+2	;sound number copy
	stz	kmwork+3	;sound flag
;** distance check **
	jsr	pm.getdistance
	a16
;;;	lda.l	m_z1
	lda	pathz1
;	sta	kw_swork+4	;DEBUG :DISTANCE
	cmp	kmwork+6
	bpl	..end		;visible check
..visible
	a8

	IFEQ	1
;** player check **
	lda	#0
	cpy	#viewblk1	;playpt1	
	beq	..player1
..player2
	ora	#ksf_plmode
..player1
	sta	kmwork+3	;player 2 flag on
	ENDC

;** angle check **
	jsr	.anglecheck

;** set sound trigger **
	a16
	lda	kmwork+2
;;;	sta.w	kw_swork+2	;sound number
	jsr	.setport3_path
..end
	plp
	rts
;===================
.anglecheck
	php
	a16
	lda.w	al_worldx,x	;enemy postion X
	sec
	sbc.w	al_worldx,y	;player camera postion X
	sta	x1

	lda.w	al_worldz,x
	sec
	sbc.w	al_worldz,y	;player camera postion X
	sta	y1
	jsl	arctan16_l

	a8
	xba
;;;	lda.l	m_cnt+1
	sec
	sbc.w	al_roty+1,y	;player camera angle
;	sta	kw_swork+0	;debug : camera angle

;* Memo :angle wo kaeruni wa ushirono $10 no bubun wo kaeru *
	cmp	#$00+$10	;22 do
	bcc	..center
	cmp	#$00-$10
	bcs	..center
	pha
	lda	kmwork+4
	cmp	#3
	beq	..vischeck	;(view yori maedake narasu)
..normalcheck
	pla
	cmp	#$80-$10
	bcc	..right
	cmp	#$80+$10
	bcc	..center
	bra	..left
..vischeck
	pla
	cmp	#$40		;90 do
	bcc	..right
	cmp	#$c0		;270 do
	bcs	..left
..unvisible
	a16
	lda	#-1
	sta	kmwork+2
	a8
	bra	..center
..right
	km_addstaval	kmwork+3,ksf_nearR
	bra	..center
..left
	km_addstaval	kmwork+3,ksf_nearL
..center
	plp
	rts

;**********
.sound2	LOCAL
	PATHCMD
	getparam	1
	sta.w	alx_snd2,x

;;;;	sta	pathx1
;;;;	pnastyoff
;;;;	set_sound2	x,pathx1
	jmp	_padd2



	IFEQ	1
;=============================================================
;*		Sound Port 2 Data Set			*
;* Xreg :alien  pointer					*
;* Yreg :player pointer					*
;* kmwork :sound number					*
;=============================================================
.setport2_path
	shorta
	longi
	php

;* distance *
	jsr	.getdistance_easy
	a16
	lda	pathz1
	s_set_resource	W,x,snddist,A

	phx
	ldx	#0
	cmp	#800
	bmi	..set_distflag
	inx
	cmp	#1300
	bmi	..set_distflag
	inx
	cmp	#1800
	bmi	..set_distflag
	inx
..set_distflag
	a8
	lda.l	..snd2disttbl,x
	ora	kmwork
	sta	kmwork
	plx
;* angle *
	jsr	.getangle_easy
	shorta
	phx
	ldx	pathz1
	lda.l	..snd2angtbl,x
	plx
	ora	kmwork
	sta.w	alx_snd2,x
	plp
	rts

;=====================================================================
;*		Sound Port2 Distance Table			*
;=====================================================================
..snd2disttbl
	db	sport2_sonear
	db	sport2_near
	db	sport2_far
	db	sport2_sofar
;=====================================================================
;*		Sound Port2 Angle Table				*
;=====================================================================
..snd2angtbl
	db	sport2_left
	db	sport2_center
	db	sport2_right

	IFEQ	1
	jsr	.getdistance_easy
	a16
	lda	pathz1
	cmp	sddist2
	km_bcs	..end_snd2
;compare data set
	sta	sddist2		;distance
	a8
	lda	kmwork+0
	sta	sdchkno2	;sound No
	stx	sdchkptr2	;alien pointer
	beq	..set_port2
;* distance *
	shorta
	jsr	pm.getdistance
	a16
	sta	kw_swork+4
	phx
	ldx	#0
	cmp	#800
	bmi	..set_distflag
	inx
	cmp	#1300
	bmi	..set_distflag
	inx
	cmp	#1800
	bmi	..set_distflag
	inx
..set_distflag
	a8
	lda.l	..snd2disttbl,x
	ora	kmwork
	sta	kmwork
	plx
;* angle *
	phx
	jsr	.calcangle
	xba
	sec
	sbc.w	al_roty+1,y	;player camera angle
	sta	kw_swork+0
	cmp	#$1a		;36 do
	bcc	..snd2center
	cmp	#$e6		;323 do
	bcs	..snd2center
	cmp	#$66		;143 do
	bcc	..snd2right
	cmp	#$9a		;216 do
	bcc	..snd2center

..snd2left
	ldx	#0
	bra	..set_angflag
..snd2center
	ldx	#1
	bra	..set_angflag
..snd2right
	ldx	#2
..set_angflag
	lda.l	..snd2angtbl,x
	plx
	ora	kmwork
..set_port2
	sta	sdport2
..end_snd2
	plp
	rts
	ENDC

;=====================================================================
;*		Calculate Distance (Easy Version)		*
;* Xreg :alien pointer						*
;* Yreg :player pointer						*
;* Out  :pathz1 :from enemy to player distance			*
;*      :kz_x1  :from enemy to player zahyou X			*
;*      :kz_z1  :from enemy to player zahyou Z			*
;*      :kz_tpx  :from enemy to player distance � X �		*
;*      :kz_tpy  :from enemy to player distance � Z �		*
;=====================================================================
.getdistance_easy
	php
	a16
	longi
;* zahyou/2 *
	lda.w	al_worldx,x
	asr	a
	sta.w	al_worldx,x
	lda.w	al_worldz,x
	asr	a
	sta.w	al_worldz,x
	lda.w	al_worldx,y
	asr	a
	sta.w	al_worldx,y
	lda.w	al_worldz,y
	asr	a
	sta.w	al_worldz,y
;---------------------------
;* relative x zahyou *
	lda.w	al_worldx,x
	sec
	sbc.w	al_worldx,y
	sta	kz_x1
	bpl	..plasx
	km_nega
..plasx
	sta	kz_tpx
;---------------------------
;* relative z zahyou *
	lda.w	al_worldz,x
	sec
	sbc.w	al_worldz,y
	sta	kz_z1
	bpl	..plasz
	km_nega
..plasz
	sta	kz_tpy
;---------------------------
	km_addstavar	pathz1,kz_tpx,kz_tpy
	plp
	rts

;=====================================================================
;*		Calculate Angle (Easy Version)			*
;* Xreg :alien pointer						*
;* Yreg :player pointer						*
;* Init :kz_x1,kz_z1 :from enemy to player zahyou (X,Y)		*
;* Out  :pathz1 :from enemy to player angle				*
;=====================================================================
.getangle_easy
	php
	a16
;* init *
	stz	pathz1
	km_negstavar	kz_x2,kz_x1
;* check *
	lda	kz_z1
	cmp	kz_x1
	bmi	..minus1
..plas1
	cmp	kz_x2
	bpl	..center_easy
	bra	..left_easy
..minus1
	cmp	kz_x2
	bmi	..center_easy
..right_easy
	inc	pathz1
..center_easy
	inc	pathz1
..left_easy
	plp
	rts

	ENDC

;=============================================================
;95/1/25
;kawaguchi path macro end
;=============================================================

;**********
.div2b	LOCAL
	PATHCMD
	addalvaroffset	1
	lda.w	0,y
	bpl	.normsh
	inc	a
.normsh	asra
	sta.w	0,y
	jmp	_padd2

;**********
.div2w	LOCAL
	PATHCMD
	addalvaroffset	1
	a16
	lda.w	0,y
	bpl	.normsh2
	inc	a
.normsh2	asra
	sta.w	0,y
	jmp	_padd2

;**********
.shiftrb	LOCAL
	PATHCMD
	addalvaroffset	1
	lda.w	0,y
	lsr	a
	sta.w	0,y
	jmp	_padd2

;**********
.shiftrw	LOCAL
	PATHCMD
	addalvaroffset	1
	a16
	lda.w	0,y
	lsr	a
	sta.w	0,y
	jmp	_padd2

;**********
.indexb	LOCAL
	PATHCMD
	jsr	.index
	LONGA
	lda	pathx2
	clc
	adc	tempaddrl
	sta	tempaddrl	; 24 bit address set up in tempaddrl
	a8
	pnastyoff
	lda	[tempaddrl]
	sta.w	0,y

	jmp	_padd6

;**********
.indexw	LOCAL
	PATHCMD
	jsr	.index
	LONGA
	lda	pathx2
	asl	a
	clc
	adc	tempaddrl
	sta	tempaddrl	; 24 bit address set up in tempaddrl
	a8
	pnastyoff
	a16
	lda	[tempaddrl]
	sta.w	0,y

	jmp	_padd6


;**********
.indexbw	LOCAL
	PATHCMD
	jsr	.index_w
	LONGA
	lda	pathx2
	clc
	adc	tempaddrl
	sta	tempaddrl	; 24 bit address set up in tempaddrl
	a8
	pnastyoff
	lda	[tempaddrl]
	sta.w	0,y

	jmp	_padd6

;**********
.indexww	LOCAL
	PATHCMD
	jsr	.index_w
	LONGA
	lda	pathx2
	asl	a
	clc
	adc	tempaddrl
	sta	tempaddrl	; 24 bit address set up in tempaddrl
	a8
	pnastyoff
	a16
	lda	[tempaddrl]
	sta.w	0,y

	jmp	_padd6

;**********
.autoindexbb	LOCAL
	PATHCMD
	jsr	.index
	LONGA
	lda	pathx2
	clc
	adc	tempaddrl
	sta	tempaddrl	; 24 bit address set up in tempaddrl
	a8
	pnastyoff
	lda	[tempaddrl]
	clc
	adc.w	0,y
	sta.w	0,y

.autoindex_end
	a8
	ldy	pathy1
	lda.w	0,y
	inc	a
	sta.w	0,y

	getparam	6
	dec	a
	cmp.w	0,y
	bcs	.noset
	lda	#0
	sta.w	0,y
.noset

	jmp	_padd7

;**********
.autoindexbw	LOCAL
	PATHCMD
	jsr	.index
	LONGA
	lda	pathx2
	clc
	adc	tempaddrl
	sta	tempaddrl	; 24 bit address set up in tempaddrl
	a8
	pnastyoff
	lda	[tempaddrl]
	a16
	sexa
	clc
	adc.w	0,y
	sta.w	0,y

	jmp	.autoindex_end

;* * * * * *
.index
	SHORTA
	
	
	getparam	3
	sta		tempaddrl+2
	a16
	getparam	1
	sta		tempaddrl

	a8
	addalvaroffset	4
	lda.w		0,y	; index from alien var
	sty		pathy1
	sta		pathx2
	stz		pathx2+1

	addalvaroffset	5
	a16
	rts

;* * * * * *
.index_w
	SHORTA
	
	
	getparam	3
	sta		tempaddrl+2
	a16
	getparam	1
	sta		tempaddrl

	a8
	addalvaroffset	4
	a16
	lda.w		0,y	; index from alien var
	sty		pathy1
	sta		pathx2

	a8
	addalvaroffset	5
	a16
	rts

;**********
.pushb	LOCAL
	PATHCMD
	addalvaroffset	1
	a8
	s_mpush		B,x,y,0
	jmp		_padd2

;**********
.pushw	LOCAL
	PATHCMD
	addalvaroffset	1
	a8
	s_mpush		W,x,y,0
	jmp		_padd2

;**********
.pullb	LOCAL
	PATHCMD
	addalvaroffset	1
	a8
	s_mpull		B,x,y,0
	jmp		_padd2
;**********
.pullw	LOCAL
	PATHCMD
	addalvaroffset	1
	a8
	s_mpull		W,x,y,0
	jmp		_padd2
	
;**********
.withinrange	LOCAL
	PATHCMD
	a16
	getparam	1
	sta	pathx1
	a8
	pnastyoff
	ldy			pathplayer&WM
	s_jmp_zdistmore		x,y,pathx1,_padd5
	s_jmp_outxydistrng	x,y,#0,pathx1,_padd5
	jmp	_pjump3

;**********
.shapeinrange	LOCAL
	PATHCMD
	a16
	getparam	1
	sta	pathx1
	a8
	pnastyoff
	s_set_objtobealvar	y,x,al_ptr
	s_jmp_zdistmore		x,y,pathx1,_padd5
	s_jmp_outxydistrng	x,y,#0,pathx1,_padd5
	jmp	_pjump3

;**********
.becomemother	LOCAL
	PATHCMD
	s_set_vartobeobj	becomeobj&WM,x
	s_push_alvar		W,x,al_sword2

	s_set_objtobemother	y,x
	s_copy_alvar2var	W,y,becomepath&WM,al_sword2
	tyx
	s_pull_alvar		W,x,al_sword2
	jmp	_padd1


;**********
.becomeshape	LOCAL
	PATHCMD
	s_jmp_alvarZERO		W,x,al_ptr,_pjump1

	s_set_vartobeobj	becomeobj&WM,x
	s_push_alvar		W,x,al_sword2

	s_set_objtobealvar	y,x,al_ptr
	s_copy_alvar2var	W,y,becomepath&WM,al_sword2
	tyx
	s_pull_alvar		W,x,al_sword2
	jmp	_padd3

;**********
.becomechildb	LOCAL
	PATHCMD
	addalvaroffset	1
	lda.w	0,y
	sta	pathx1

	s_set_vartobeobj	becomeobj&WM,x
	s_push_alvar		W,x,al_sword2

	s_jmp_alsflag	x,motherobj,.okmotherbcb	; am I mother?

	s_set_objtobemother	y,x		; if child
	tyx					; set x to be mother
.okmotherbcb
	s_set_objtobechild	y,x,pathx1
	cpy	#0
	bne	.ok2bcb

	s_set_objtobevar	x,becomeobj&WM
	s_pull_alvar		W,x,al_sword2
	brl	_pjump2
.ok2bcb
	s_copy_alvar2var	W,y,becomepath&WM,al_sword2
	tyx

	s_pull_alvar		W,x,al_sword2

	jmp	_padd4

;**********
.becomechild	LOCAL
	PATHCMD
	getparam	1
	sta		pathx1

	s_set_vartobeobj	becomeobj&WM,x
	s_push_alvar		W,x,al_sword2

	s_jmp_alsflag	x,motherobj,.okmotherbc	; am I mother?

	s_set_objtobemother	y,x		; if child
	tyx					; set x to be mother
.okmotherbc
	s_set_objtobechild	y,x,pathx1
	cpy	#0
	bne	.okbcb

	s_set_objtobevar	x,becomeobj&WM
	s_pull_alvar		W,x,al_sword2
	brl	_pjump2
.okbcb

	s_copy_alvar2var	W,y,becomepath&WM,al_sword2
	tyx

	s_pull_alvar		W,x,al_sword2

	jmp	_padd4



;**********
.unbecome	LOCAL
	PATHCMD
	s_push_alvar	W,x,al_sword2
	s_set_alvar	W,x,al_sword2,becomepath&WM
	s_set_objtobevar	x,becomeobj&WM
	s_pull_alvar	W,x,al_sword2
	jmp		_padd1

;**********
.become	LOCAL
	PATHCMD
	s_set_vartobeobj	becomeobj&WM,x
	s_push_alvar		W,x,al_sword2

	s_set_objtobevar	y,becomelastobj&WM
	s_copy_alvar2var	W,y,becomepath&WM,al_sword2
	tyx
	s_pull_alvar		W,x,al_sword2
	jmp	_padd1

;**********
.scoreb	LOCAL
	PATHCMD
	addalvaroffset	1
	lda.w	0,y

	pha
	ldy	pathplayer&WM
	km_plheapptrSD	y,y
	pla
	a16
	and	#255
	clc
	adc	kscore,y
	bcc	..normalB
	lda	#$ffff
..normalB
	sta	kscore,y
	a8

	jmp	_padd2

;**********
.scorew	LOCAL
	PATHCMD
	addalvaroffset	1
	a16
	lda.w	0,y

	pha
	a8
	ldy	pathplayer&WM
	km_plheapptrSD	y,y
	a16
	pla
	clc
	adc	kscore,y
	bcc	..normalW
	lda	#$ffff
..normalW
	sta	kscore,y
	a8

	jmp	_padd2


;**********
.score	LOCAL
	PATHCMD
	IFEQ	1
	a16
	getparam	1
	clc
	adc.l	playerscore
	sta.l	playerscore
	ENDC

	phy
	ldy	pathplayer&WM
	km_plheapptrSD	y,y
	a16
	getparam	1
	clc
	adc	kscore,y
	bcc	..normal
	lda	#$ffff
..normal
	sta	kscore,y
	ply
	a8
	jmp	_padd3

;**********
.player1	LOCAL
	PATHCMD
	ldy	playpt1
	sty	pathplayer&WM
	s_clr_alsflag	x,sflag10
	jmp	_padd1

;**********
.player2	LOCAL
	PATHCMD
	ldy	playpt2
	sty	pathplayer&WM
	s_set_alsflag	x,sflag10
	jmp	_padd1

;**********
.ifplayer	LOCAL
	PATHCMD
	getparam	1

	ldy	pathplayer&WM
	cmp	#1
	beq	.checkp1
	cpy	playpt2
	bra	.checko
.checkp1	cpy	playpt1
.checko	s_beq	_pjump2
	jmp	_padd4

;**********
.swapplayer	LOCAL
	PATHCMD
	s_jmp_alsflag	x,sflag10,.player1
	jmp		.player2

;**********
.lockplayeron	LOCAL
	PATHCMD
	pnastyoff
	ldy	pathplayer&WM
	s_lock_obj	x,y

	jmp		_padd1

;**********
.lockplayeroff	LOCAL
	PATHCMD
	pnastyoff
	s_clr_alsflag	x,locked

	jmp		_padd1

;**********
.playerincone	LOCAL
	PATHCMD

; get the relative position of the player to the current shape
	ldy	pathplayer&WM
	a16
	lda.w	al_worldx,y
	sec
	sbc	al_worldx,x
	sta	x1
	lda.w	al_worldz,y
	sec
	sbc	al_worldz,x
	sta	y1
	a8
	jsl	arctan16_l
	xba
	sta	x1
	getparam	1
	sta	z1	; get the range
	asl	z1	; multiply it by 2

	clc
	adc	al_roty,x	; add y rotation
	clc
	adc	x1		; sub angle returned by arctan
	cmp	z1	; double the range and compare (+- range)
	s_bcc	_pjump2
	jmp	_padd4

;**********
.inplayerscone	LOCAL
	PATHCMD

	getparam	1
	sta	pathy1
	getparam	2
	sec
	sbc	pathy1
	sta	pathz1

; get the relative position of the player to the current shape
	pnastyoff
	ldy	pathplayer&WM
	a16
	lda	al_worldx,x
	sec
	sbc.w	al_worldx,y
	sta	x1
	lda	al_worldz,x
	sec
	sbc.w	al_worldz,y
	sta	y1
	a8
	jsl	arctan16_l
	xba
	clc
	adc.w	al_roty,y
	sec
	sbc	pathy1
	cmp	pathz1
	s_bcs	_padd5

	jmp	_pjump3

;*********
.circleB	LOCAL
	PATHCMD
	addalvaroffset	1
	lda.w	0,y
	sta	x2+1
	stz	x2
	bra	.circleit
;*********
.circleW	LOCAL
	PATHCMD
	addalvaroffset	1
	a16
	lda.w	0,y
	sta	x2
	a8
	bra	.circleit
;*********
.circle	LOCAL
	PATHCMD

	getparam	1
	sta		x2+1
	stz		x2

.circleit
; circle the mother object, be it the player in tracking mode or a real mother

	a16
	lda	al_childx,x
	sta	x1
;	lda	al_childy,x
;	sta	y1
	lda	al_childz,x
	sta	z1
	stz	matxw
	stz	matzw

	lda	x2
	sta	matyw		; store angle to rotate by as high byte of angle
	a8

	s_rotate_16bit

	a16
	lda	bigx
	sta	al_childx,x
;	lda	bigy
;	sta	al_childy,x
	lda	bigz
	sta	al_childz,x

	jmp	_padd2


;*********
.circleshape	LOCAL
	PATHCMD
	getparam	1
	sta	x2+1
	stz	x2
	ldy	al_ptr,x
	bra	.circle_in
;*********
.circleshapeB	LOCAL
	PATHCMD
	addalvaroffset	1
	lda.w	0,y
	sta	x2+1
	stz	x2
	ldy	al_ptr,x
	bra	.circleplayer_in
;*********
.circleshapeW	LOCAL
	PATHCMD
	addalvaroffset	1
	a16
	lda.w	0,y
	sta	x2
	a8
	ldy	al_ptr,x
	bra	.circleplayer_in
;*********
.circleplayerB	LOCAL
	PATHCMD
	addalvaroffset	1
	lda.w	0,y
	sta	x2+1
	stz	x2
	bra	.circleplayer_in
;*********
.circleplayerW	LOCAL
	PATHCMD
	addalvaroffset	1
	a16
	lda.w	0,y
	sta	x2
	a8
	bra	.circleplayer_in
;*********
.circleplayer	LOCAL
	PATHCMD

	getparam	1
	sta		x2+1
	stz		x2

.circleplayer_in
; circle the mother object, be it the player in tracking mode or a real mother

	ldy	pathplayer&WM
.circle_in
	phy
	a16
	lda	al_worldx,x
	sec
	sbc.w	al_worldx,y
	sta	x1
;	lda	al_worldy,x
;	sec
;	sbc.w	al_worldy,y
;	sta	y1
	lda	al_worldz,x
	sec
	sbc.w	al_worldz,y
	sta	z1
	stz	matxw
	stz	matzw

	lda	x2
	sta	matyw		; store angle to rotate by as high byte of angle
	a8

	s_rotate_16bit

	a16
	ply
	lda	bigx
	clc
	adc.w	al_worldx,y
	sta	al_worldx,x
;	lda	bigy
;	clc
;	adc.w	al_worldy,y
;	sta	al_worldy,x
	lda	bigz
	clc
	adc.w	al_worldz,y
	sta	al_worldz,x

	jmp	_padd2


;*********
.moveinonplayerW	LOCAL
	PATHCMD
	addalvaroffset	1
	a16
	lda.w	0,y
	sta	x1
	bra	.moveinonplayer_in2

;*********
.moveinonplayerB	LOCAL
	PATHCMD
	addalvaroffset	1
	lda.w	0,y
	bra	.moveinonplayer_in


;*********
.moveinonshapeW	LOCAL
	PATHCMD
	addalvaroffset	1
	a16
	lda.w	0,y
	sta	x1
	ldy	al_ptr,x
	bra	.movein_in3
;*********
.moveinonshapeB	LOCAL
	PATHCMD
	addalvaroffset	1
	a16
	lda.w	0,y
	sexa
	sta	x1
	ldy	al_ptr,x
	bra	.movein_in3
;*********
.moveinonshape	LOCAL
	PATHCMD
	getparam	1
	a16
	sexa
	sta	x1
	ldy	al_ptr,x
	bra	.movein_in3

;*********
.moveinonplayer	LOCAL
	PATHCMD
	getparam	1
.moveinonplayer_in
	a16
	sexa
	sta		x1

.moveinonplayer_in2
	ldy	pathplayer&WM	; get player's pointer
.movein_in3
	a8
	poll_mario

	phy

	a16
	lda	al_worldx,x	; get position relative to the player
	sec
	sbc.w	al_worldx,y
	sta.l	m_bigx
	lda	al_worldy,x
	sec
	sbc.w	al_worldy,y
	sta.l	m_bigy
	lda	al_worldz,x
	sec
	sbc.w	al_worldz,y
	sta.l	m_bigz

	phx
	call_mario	mveclen

	lda.l	m_z1	; result = length (distance of object from centre)
	sec
	sbc	x1	; x1 holds the change in distance required
	sta.l	m_x1	; resize parameter for mdividevecs

	call_mario	mdividevecs

	plx
	ply

	lda.l	m_bigx
	clc
	adc.w	al_worldx,y
	sta	al_worldx,x
	lda.l	m_bigy
	clc
	adc.w	al_worldy,y
	sta	al_worldy,x
	lda.l	m_bigz
	clc
	adc.w	al_worldz,y
	sta	al_worldz,x

	a8
	unpoll_mario

	jmp	_padd2
	

;*********
.moveinW	LOCAL
	PATHCMD
	addalvaroffset	1
	a16
	lda.w	0,y
	sta	x1
	bra	.moveitin

;*********
.moveinB	LOCAL
	PATHCMD
	addalvaroffset	1
	lda.w	0,y
	bra	.moveitin2
	
;*********
.movein	LOCAL
	PATHCMD
	getparam	1
.moveitin2
	a16
	sexa
	sta		x1

.moveitin	a8
	poll_mario
	a16

	lda	al_childx,x
	sta.l	m_bigx
	lda	al_childy,x
	sta.l	m_bigy
	lda	al_childz,x
	sta.l	m_bigz

	phx
	call_mario	mveclen

	lda.l	m_z1	; result = length (distance of object from centre)
	sec
	sbc	x1	; x1 holds the change in distance required
	sta.l	m_x1	; resize parameter for mdividevecs

	call_mario	mdividevecs

	plx
	lda.l	m_bigx
	sta	al_childx,x
	lda.l	m_bigy
	sta	al_childy,x
	lda.l	m_bigz
	sta	al_childz,x

	a8
	unpoll_mario

	jmp	_padd2



;**********
.becomeinert	LOCAL
	PATHCMD
; we need to make this alien an inert object..
	phx
	a16
	ldx	inertlistptr
	l_add.w	inertlistptr,inertfree,.binorem
	txy
	plx

	lda	al_worldx,x
	sta.w	i_worldx,y
	lda	al_worldy,x
	sta.w	i_worldy,y
	lda	al_worldz,x
	sta.w	i_worldz,y
	lda	al_shape,x
	sta.w	i_shape,y

; exchange each other's pointers
	txa
	sta.w	i_alienptr,y
	tya
	sta	al_inertptr,x

	phy
	s_get_resource	W,x,a,pathstart,.normsword2
	bra	.oksetit
.normsword2
	lda	al_sword2,x
	inc	a
.oksetit
	ply
	sta.w	i_strat,y
	a8
	lda	#if_pathobj!if_exists
	sta.w	i_flags,y

	lda	al_rotx,x
	sta.w	i_rotx,y
	lda	al_roty,x
	sta.w	i_roty,y
	lda	al_rotz,x
	sta.w	i_rotz,y

	jmp	_padd1
.binorem
	a8
	plx
	jmp		_padd1


;**********
.relativeon	LOCAL
	PATHCMD
	a16
	lda	#0
	sta	al_childrotobj,x
	jmp		_padd1

;**********
.relativeoff	LOCAL
	PATHCMD
	a16
	txa
	sta	al_childrotobj,x
	lda	#0
	sta	al_childx,x
	sta	al_childy,x
	sta	al_childz,x
	a8
	sta	al_childrotx,x
	sta	al_childroty,x
	sta	al_childrotz,x
	jmp		_padd1


;*********
.stampstart	LOCAL
	PATHCMD

	ldy	al_inertptr,x
	beq	.notinert

	a16
	lda	al_sword2,x
	sta.w	i_strat,y

	jmp	_padd1
.notinert

	a16
	lda	al_sword2,x
	s_set_resource	W,x,pathstart,a

	jmp	_padd1

;**********
.clearstack	LOCAL
	PATHCMD
	jsr	._clearstack
	jmp	_padd1
._clearstack	LOCAL
	rts
;	pnastyoff

	ldy	al_stackptr,x
	beq	.cs_fin

	a16
	tya
	jsl	sfree_l

	a16
	lda	#0
	sta	al_stackptr,x
	a8

;	lda	heap,y
;	beq	.cs_fin

;	jsl	debugprint2
;	a16
;	tya
;	jsl	smpull_l
;	sta	al_stackptr,x
;	a8
;	bra	._clearstack
.cs_fin
	rts

;*********
.forcejump	LOCAL
	PATHCMD
	getparam	1
	sta		x1
	ldy		pathplayer&WM
	rb_plash	y,x1

	jmp	_padd2

;*********
.transrobot	LOCAL

	PATHCMD

	ldy		pathplayer&WM
	sp_trans_do	y,robot

	jmp	_padd1


;*********
.transufo	LOCAL

	PATHCMD

	ldy		pathplayer&WM
	sp_trans_do	y,armer

	jmp	_padd1


;*********
.transgdarwing	LOCAL

	PATHCMD

	ldy		pathplayer&WM
	sp_trans_do	y,of_arwing

	jmp	_padd1

;*********
.transsparwing	LOCAL

	PATHCMD

	ldy		pathplayer&WM
	sp_trans_do	y,cs_arwing

	jmp	_padd1

;*********
.translock	LOCAL

	PATHCMD

	ldy		pathplayer&WM
	sp_trans_lock	y

	jmp	_padd1

;*********
.translockoff	LOCAL

	PATHCMD

	ldy		pathplayer&WM
	sp_trans_lockoff	y

	jmp	_padd1



;*********
.incspweap	LOCAL

	PATHCMD
	ldy		pathplayer&WM
	getparam	1
	sta		x2
	pnastyoff

	lda	#0
	sta	y1		; flag


	lda	al_pbyte2,x
	s_exg_objs
	phy
	ldy	al_sword2,x
	cmp	exal_spweap_TYPE,y
	bne	.ispset
	inc	y1		; flag on
.ispset	sta	exal_spweap_TYPE,y

	ply
	s_exg_objs

	wm_addspweapnum	y,x2,.ispmax	; max ?

.ispexit	jmp	_padd4

.ispmax	lda	y1
	beq	.ispexit
	jmp	_pjump2


;*********
.setspweap	LOCAL

	PATHCMD

	getparam	1
	sta		al_pbyte2,x

	jmp	_padd2

;*********
.plrshield	LOCAL

	PATHCMD

	getparam	1
	sta		x1

	s_push_obj	x
	ldx		pathplayer&WM
	toheap		y,x

	pl_shield	x,x1,y

	s_pull_obj	x

	jmp	_padd2

;*********
.camrbyofs	LOCAL

	PATHCMD

	a16
	getparam	1
	sta		x1
	a8

	ldy		pathplayer&WM
	toheap		y,y
	s_set_alvar	W,y,exal_camlookYofs_ext,x1
	s_or_alvar	B,y,exal_VIEWflag3,#exal_VIEWflag3_forcelookyofs

	jmp	_padd3


;*********
.ifplrrobot	LOCAL

	PATHCMD

	ldy			pathplayer&WM
	sp_jmp_playertype	y,robot,.pisrobot
	jmp	_padd3
.pisrobot	jmp	_pjump1


;*********
.ifplrarwing	LOCAL

	PATHCMD

	ldy			pathplayer&WM
	sp_jmp_playertype	y,arwing,.pisarwing

	jmp	_padd3
.pisarwing	jmp	_pjump1



;*********
.ifplrufo	LOCAL

	PATHCMD

	ldy			pathplayer&WM
	sp_jmp_playertype	y,ufo,.pisufo
	jmp	_padd3
.pisufo	jmp	_pjump1


;*********
.shockcam1	LOCAL

	PATHCMD

	ldy		playpt1

	getparam	1
	sta		x1+0
	getparam	2
	sta		x1+1

	c_shock_cam	y,x1

	jmp	_padd3

;*********
.shockcam2	LOCAL

	PATHCMD

	ldy		playpt2

	getparam	1
	sta		x1+0
	getparam	2
	sta		x1+1

	c_shock_cam	y,x1
	jmp	_padd3

;*********
.hitflashtrig	LOCAL
	PATHCMD

	s_set_alsflag	x,hitflash

	jmp	_padd1

;*********
.setmarker1	LOCAL

	PATHCMD

	pnastyoff
	setenemymark	x,1

	jsr	.setinertmark

	jmp	_padd1

;*********
.setmarker2	LOCAL

	PATHCMD

	pnastyoff
	setenemymark	x,2

	jmp	_padd1

;- - - - - -
.setinertmark
	SHORTA
	LONGI

	ldy	al_inertptr,x
	beq	.nothing231

	lda.w	i_flags,y
	ora	#if_target
	sta.w	i_flags,y

.nothing231
	rts


;*********
.setmarker	LOCAL

	PATHCMD

	pnastyoff
	setenemymark	x,2

	jsr	.setinertmark

	jmp	_padd1


;*********
.begindemo	LOCAL
	PATHCMD

	km_setgameflag	freeze
	s_set_alsflag	x,active

	pnastyoff
	jsl	removeweapons_l


	s_alloc	x,y,#al_size


	phx

	a16
	tya
	clc
	adc	#heap
	tay
	a8

	ldx	#viewblk1
	jsr	.viewcopy
	plx

	a16
	tya
	sec
	sbc	#heap
	tay
	a8

	s_set_resource	W,x,viewpos,Y
	
;***** kawaguchi path start ******	
	lda	#sport3_demo_on
	jsr	..demo_sound
;***** kawaguchi path end *********
	jmp	_padd1
;- - - - - -
; this copies from X to Y a length of al_size
.viewcopy	SHORTA
	phx
	phy
	lda	#al_size
	sta	pathx1
.copyit
	lda.w	0,x
	sta.w	0,y
	inx
	iny
	dec	pathx1
	bne	.copyit
	ply
	plx
	rts

;*********
.activeon	LOCAL
	PATHCMD

	s_set_alsflag	x,active

	jmp	_padd1

;*********
.activeoff	LOCAL
	PATHCMD

	s_clr_alsflag	x,active

	jmp	_padd1

;*********
.enddemo	LOCAL
	PATHCMD

	km_clrgameflag	freeze
	s_clr_alsflag	x,active

	s_get_resource	W,x,y,viewpos,.nores


	a16
	tya
	clc
	adc	#heap
	tay
	a8

	phx
	tyx
	ldy	#viewblk1
	jsr	.viewcopy

	txy

	a16
	tya
	sec
	sbc	#heap
	tay
	a8

	plx
	s_free	x,y

.nores
;***** kawaguchi path start ******	
	lda	#sport3_demo_off
	jsr	..demo_sound
;***** kawaguchi path end *********
	jmp	_padd1


;*********
.setcamera	LOCAL
	PATHCMD

	ldy	#viewblk1

	s_achase_alvar2alvar	W,y,al_worldx,x,al_worldx,3
	s_achase_alvar2alvar	W,y,al_worldy,x,al_worldy,3
	s_achase_alvar2alvar	W,y,al_worldz,x,al_worldz,3
	s_achase_alvar2alvar	W,y,al_worldz,x,al_worldz,3
	s_achase_alvar		W,y,al_sword1,#0,3

	a16
	lda	al_rotx,x
	and	#255
	xba
	nega
	sta	pathx1

	lda	al_roty,x
	and	#255
	xba
	nega
	sta	pathy1

	lda	al_rotz,x
	and	#255
	xba
	nega
	sta	pathz1
	a8

	s_achase_alvar	W,y,al_rotx,pathx1,3
	s_achase_alvar	W,y,al_roty,pathy1,3
	s_achase_alvar	W,y,al_rotz,pathz1,3

	jmp	_padd1

;*********
.setcameraimmed	LOCAL
	PATHCMD

	ldy	#viewblk1

	s_copy_alvar2alvar	W,y,al_worldx,x,al_worldx
	s_copy_alvar2alvar	W,y,al_worldy,x,al_worldy
	s_copy_alvar2alvar	W,y,al_worldz,x,al_worldz
	s_copy_alvar2alvar	W,y,al_worldz,x,al_worldz
	s_set_alvar		W,y,al_sword1,#0

	a16
	lda	al_rotx,x
	and	#255
	xba
	nega
	sta	pathx1

	lda	al_roty,x
	and	#255
	xba
	nega
	sta	pathy1

	lda	al_rotz,x
	and	#255
	xba
	nega
	sta	pathz1
	a8

	s_set_alvar	W,y,al_rotx,pathx1
	s_set_alvar	W,y,al_roty,pathy1
	s_set_alvar	W,y,al_rotz,pathz1

	jmp	_padd1

;*********
.ifplrfullhp	LOCAL

	PATHCMD

	ldy			pathplayer&WM
	sp_jmp_playerfullHP	y,.fullhp
	jmp	_padd3
.fullhp	jmp	_pjump1


;*********
.clippingon	LOCAL
	PATHCMD

	lda	#1
	sta	al_clip,x

	jmp	_padd1

;*********
.rangecheckon	LOCAL
	PATHCMD
	s_clr_alsflag	x,noviewcheck
	jmp	_padd1

;*********
.rangecheckoff	LOCAL
	PATHCMD
	s_set_alsflag	x,noviewcheck
	jmp	_padd1

;*********
.rangecheckonmap	LOCAL
	PATHCMD
	ldy	al_inertptr,x
	beq	.rcom_invalid
	lda.w	i_flags,y
	and	#~if_norangecheck
	sta.w	i_flags,y
.rcom_invalid
	jmp	_padd1

;*********
.rangecheckoffmap	LOCAL
	PATHCMD
	ldy	al_inertptr,x
	beq	.rcom_invalid2
	lda.w	i_flags,y
	ora	#if_norangecheck
	sta.w	i_flags,y
.rcom_invalid2
	jmp	_padd1

;*********
.clippingoff	LOCAL
	PATHCMD

	lda	#0
	sta	al_clip,x

	jmp	_padd1

;*********
.pool	LOCAL
	PATHCMD
	phx

	getparam	1
	a16
	sexa
	sta	pathx1

	a8
	promnastyoff
	a16

	ldy	al_shape,x
	tyx
	lda.l	sh_shift,x
	and	#255
	beq	.noscale

.scaleit
	asl	pathx1
	dec	a
	bne	.scaleit
.noscale
	plx

	lda	pathx1
	sta	al_pword1,x

	jmp	_padd2

;*********
.plrtunnelon	LOCAL

	PATHCMD

	ldy		pathplayer&WM
	sp_hitwall	y,on
	jmp	_padd1


;*********
.plrtunneloff	LOCAL

	PATHCMD

	ldy		pathplayer&WM
	sp_hitwall	y,off
	jmp	_padd1

;*********
.ifpilot	LOCAL

	PATHCMD

	ldy		pathplayer&WM

	getparam	1
	sta		x1

	sp_jmp_PILOT	y,x1,.ifplt

	jmp	_padd4
.ifplt	jmp	_pjump2

;*********
.notpilot	LOCAL
    
	PATHCMD

	ldy		pathplayer&WM

	getparam	1
	sta		x1

	sp_jmpnot_PILOT	y,x1,.ntplt

	jmp	_padd4
.ntplt	jmp	_pjump2


    
;*********
.switchtable
	dw	SWITCH_1
	dw	SWITCH_2
	dw	SWITCH_3
	dw	SWITCH_4
	dw	SWITCH_5
	dw	SWITCH_6
	dw	SWITCH_7
	dw	SWITCH_8
	dw	SWITCH_9
	dw	SWITCH_10
	dw	SWITCH_11
	dw	SWITCH_12
	dw	SWITCH_13
	dw	SWITCH_14
	dw	SWITCH_15
	dw	SWITCH_16

;*********
.getswitchmaskv	PATHCMD
	addalvaroffset	2
	phy
	jsr	.getswitchmask
	ply
	rts
.getswitchmask	PATHCMD
	addalvaroffset	1
	lda.w	0,y
	dec	a
	asl	a
	a16
	and	#255
	stx	pathx1
	tax
	lda.l	.switchtable,x

	ldx	pathx1
	rts
;*********
.setswitch	LOCAL
	PATHCMD
	jsr	.getswitchmask
	LONGA
	tsb	switchflags

	jmp	_padd2

;*********
.clrswitch	LOCAL
	PATHCMD
	jsr	.getswitchmask
	LONGA
	trb	switchflags

	jmp	_padd2


;*********
.ifswitch	LOCAL
	PATHCMD
	jsr	.getswitchmask
	LONGA

	bit	switchflags
	lbne	_pjump2

	jmp	_padd4


;*********
.setswitchv	LOCAL
	PATHCMD
	jsr	.getswitchmaskv
	LONGA
	ora.w	0,y
	sta.w	0,y

	jmp	_padd3

;*********
.clrswitchv	LOCAL
	PATHCMD
	jsr	.getswitchmaskv
	LONGA
	eor	#-1
	and.w	0,y
	sta.w	0,y	

	jmp	_padd3


;*********
.ifswitchv	LOCAL
	PATHCMD
	jsr	.getswitchmaskv
	LONGA

	and.w	0,y
	lbne	_pjump3

	jmp	_padd5

;*********
.plrturnon	LOCAL

	PATHCMD

	ldy		pathplayer&WM

	pl_turn		y,on

	jmp	_padd1

;*********
.plrturnoff	LOCAL

	PATHCMD

	ldy		pathplayer&WM

	pl_turn		y,off

	jmp	_padd1
;*********
.plrforceturn	LOCAL

	PATHCMD

	ldy		pathplayer&WM

	getparam	1
	sta		y1

	a16
	lda		al_worldx,x
	sta		x1
	lda		al_worldy,x
	sta		y1
	lda		al_worldz,x
	sta		z1
	getparam	2
	sta		x2
	lda		#7fffh
	sta		y2
	a8

	pl_forceturn	y,y1,x1,y1,z1,x2,y2

	jmp	_padd6


;*********
.plrforceway	LOCAL

; in
; x2	: width
; y2	: height
; y3	: roty

	PATHCMD

	ldy	pathplayer&WM

	pnastyoff

	jsl	P_PLRFORCEWAY_srou_l

	jmp	_padd1


;*********
.ifplrturnon	LOCAL

	PATHCMD

	ldy		pathplayer&WM
	pl_jmp_ifturn	y,.ipto

	jmp	_padd3
.ipto	jmp	_pjump1

;*********
.ifplrturnoff	LOCAL

	PATHCMD

	ldy		pathplayer&WM
	pl_jmpNOT_ifturn	y,.iptoff

	jmp	_padd3
.iptoff	jmp	_pjump1

;**********

.ifareaout	LOCAL

	PATHCMD

	ldy	pathplayer&WM

	pl_jmp_ifblockoff	y,_padd3

	pnastyoff
	s_jmp_ifsolid	x,_pjump1

	jmp	_padd3

;*********
.plrcontroloff	LOCAL

	PATHCMD

	ldy		pathplayer&WM
	pl_control	y,off

	jmp	_padd1

;*********
.plrcontrolon	LOCAL

	PATHCMD

	ldy		pathplayer&WM
	pl_control	y,on

	jmp	_padd1


;**********
.msgalvar	LOCAL
	PATHCMD
	addalvaroffset	1
	phx
	pnastyoff
	lda.w		0,y
	jsl		FriendMessage_l
	plx
	jmp		_padd2


;**********
.setbossflagon	LOCAL
	PATHCMD

	a16
	getparam	1
	tsb	bossflags

	jmp	_padd3

;**********
.setbossflagoff	LOCAL
	PATHCMD

	a16
	getparam	1
	trb	bossflags

	jmp	_padd3

;**********
.ifbossflagon	LOCAL
	PATHCMD

	a16
	getparam	1
	bit	bossflags
	lbne	_pjump3

	jmp	_padd5

;**********
.ifbossflagoff	LOCAL
	PATHCMD

	a16
	getparam	1
	bit	bossflags
	lbeq	_pjump3

	jmp	_padd5

;**********
.clrbossflag	LOCAL
	PATHCMD

	stz	bossflags
	stz	bossflags+1
	jmp	_padd1


;**********
.gincb	LOCAL
	PATHCMD
	a16
	getparam	1
	tay
	a8
	lda.w	0,y
	inc	a
	sta.w	0,y
	jmp		_padd3

;**********
.gincw	LOCAL
	PATHCMD
	a16
	getparam	1
	tay
	lda.w	0,y
	inc	a
	sta.w	0,y
	jmp		_padd3

;**********
.gdecb	LOCAL
	PATHCMD
	a16
	getparam	1
	tay
	a8
	lda.w	0,y
	dec	a
	sta.w	0,y
	jmp		_padd3

;**********
.gdecw	LOCAL
	PATHCMD
	a16
	getparam	1
	tay
	lda.w	0,y
	dec	a
	sta.w	0,y
	jmp		_padd3

;**********
.addbg	LOCAL
	PATHCMD
	a16
	getparam	2
	tay
	a8
	lda.w	0,y
	sta	pathx2
	addalvaroffset	1
	lda.w	0,y
	clc
	adc	pathx2
	sta.w	0,y
	jmp	_padd4

;**********
.addwg	LOCAL
	PATHCMD
	a16
	getparam	2
	tay
	lda.w	0,y
	sta	pathx2
	a8
	addalvaroffset	1
	a16
	lda.w	0,y
	clc
	adc	pathx2
	sta.w	0,y
	jmp	_padd4

;**********
.addgb	LOCAL
	PATHCMD
	addalvaroffset	3
	lda.w	0,y
	sta	pathx2
	a16
	getparam	1
	tay
	a8
	lda.w	0,y
	clc
	adc	pathx2
	sta.w	0,y
	jmp	_padd4

;**********
.addgw	LOCAL
	PATHCMD
	addalvaroffset	3
	a16
	lda.w	0,y
	sta	pathx2
	getparam	1
	tay
	lda.w	0,y
	clc
	adc	pathx2
	sta.w	0,y
	jmp	_padd4

;**********
.copyplayerpos	LOCAL
		PATHCMD
	ldy	pathplayer&WM

	a16
	lda.w	al_worldx,y
	sta	al_worldx,x
	lda.w	al_worldy,y
	sta	al_worldy,x
	lda.w	al_worldz,y
	sta	al_worldz,x

	jmp	_padd1


;**********
.iflargerb	LOCAL
	PATHCMD

	addalvaroffset	1
	lda.w	0,y
	sta	pathx2
	addalvaroffset	2
	lda.w	0,y
	cmp	pathx2
	lbmi	_pjump3

	jmp	_padd5

;**********
.iflargerw	LOCAL
	PATHCMD

	addalvaroffset	1
	a16
	lda.w	0,y
	sta	pathx2
	a8
	addalvaroffset	2
	a16
	lda.w	0,y
	cmp	pathx2
	lbmi	_pjump3

	jmp	_padd5

;**********
.ifsamebb	LOCAL
	PATHCMD

	addalvaroffset	1
	lda.w	0,y
	sta	pathx2
	addalvaroffset	2
	lda	pifnot
	beq	.isbb_same
	stz	pifnot
	lda.w	0,y
	cmp	pathx2
	lbeq	_padd5
	jmp	_pjump3
.isbb_same
	lda.w	0,y
	cmp	pathx2
	lbeq	_pjump3
	jmp	_padd5

;**********
.ifsameww	LOCAL
	PATHCMD

	addalvaroffset	1
	a16
	lda.w	0,y
	sta	pathx2
	a8
	addalvaroffset	2
	lda	pifnot
	beq	.isww_same
	stz	pifnot
	a16
	lda.w	0,y
	cmp	pathx2
	lbeq	_padd5
	jmp	_pjump3
.isww_same
	a16
	lda.w	0,y
	cmp	pathx2
	lbeq	_pjump3
	jmp	_padd5


;*********
.ifplrboost	LOCAL

	PATHCMD

	ldy			pathplayer&WM

	pl_jmp_ifboost		y,.ipboost
	jmp	_padd3

.ipboost	jmp	_pjump1

;*********
.ifplrbrake	LOCAL

	PATHCMD
	ldy			pathplayer&WM

	sp_jmp_ifcockpit	y,.ipbk
	pl_jmp_ifbrake		y,.ipbrake
.ipbk	jmp	_padd3

.ipbrake	jmp	_pjump1


;**********
.objincone	LOCAL

	PATHCMD

; get the relative position of the "AL_PTR" to the current shape

	ldy	al_ptr,x
	a16
	lda.w	al_worldx,y
	sec
	sbc	al_worldx,x
	sta	x1
	lda.w	al_worldz,y
	sec
	sbc	al_worldz,x
	sta	y1
	a8
	pnastyoff
	jsl	arctan16_l
	xba
	sta	x1
	getparam	1
	sta	z1	; get the range
	asl	z1	; multiply it by 2

	clc
	adc	al_roty,x	; add y rotation
	clc
	adc	x1		; sub angle returned by arctan
	cmp	z1	; double the range and compare (+- range)
	s_bcc	_pjump2
	jmp	_padd4
;**********
.findenemyobj	LOCAL

	PATHCMD

	ldy		allst
	s_set_find	y

	a16
	getparam	1
	sta		tpx
	a8
	getparam	3
	sta		z1

;	wm_find_enemynearobj	y,x,#0,#7000,#30H,.fnotfound
	wm_find_enemynearobj	y,x,#0,tpx,z1,#63,.fnotfound

.fnofound	sty		al_ptr,x

	jmp		_padd6

.fnotfound

	stz		al_ptr,x
	stz		al_ptr+1,x
	jmp		_pjump4


;*********
.plrweaplevelup	LOCAL

	PATHCMD
	ldy		pathplayer&WM

	wm_weaplevelup	y

	jmp	_padd1

;**********
.clearsequence	LOCAL
	PATHCMD

	pnastyoff

	pl_set_BOSSdead

;	s_push_obj	x
;	ldx	playpt1
;	jsl	setclearseq_l	; mission mode
;	s_pull_obj	x

	jmp	_padd1

;**********
;.objdead	LOCAL
;
;	PATHCMD
;
;jmp addr if "al_ptr" is dead.
;
;	ldy	al_ptr,x
;	lda.w	al_HP,y
;	s_beq	_pjump1
;	jmp	_padd3
;
;**********
;.notobjdead	LOCAL
;
;	PATHCMD
;
;jmp addr if "al_ptr" is dead.
;
;	ldy	al_ptr,x
;	lda.w	al_HP,y
;	s_bne	_pjump1
;	jmp	_padd3
;
;**********
.plrburn	LOCAL

	PATHCMD

	ldy			pathplayer&WM

	toheap		y,y

	getparam	1
	ora		exal_dmgeffect,y
	sta		exal_dmgeffect,y

	jmp	_padd2


;**********
.moveplayeron	LOCAL
	PATHCMD
	s_set_alsflag	x,sflag3
	s_set_alvar	W,x,al_mx,#0
	jmp	_padd1

;**********
.adjustrot	LOCAL
	PATHCMD

	ldy	al_ptr,x	; pointer to mother object
	beq	.ar_nocando

	lda	al_rotx,x
	sec
	sbc.w	al_rotx,y
	sta	al_childrotx,x

	lda	al_roty,x
	sec
	sbc.w	al_roty,y
	sta	al_childroty,x

	lda	al_rotz,x
	sec
	sbc.w	al_rotz,y
	sta	al_childrotz,x

.ar_nocando
	jmp	_padd1

;**********
.moveplayerOFF	LOCAL
	PATHCMD

	s_clr_alsflag	x,sflag3
	jmp	_padd1


;- - - - - - - - - -
.moveplayerinit	LOCAL
	PATHCMD
	ldy	pathplayer&WM
	toheap	y,y

	a16
;-- store world x,y,z for next check..
	lda	al_worldx,x
	sta	al_ox,x
	lda	al_worldy,x
	sta	al_oy,x
	lda	al_worldz,x
	sta	al_oz,x

	lda	#1
	sta	al_mx,x		; we have initialised...

	a8
	lda.w	al_roty,x
	sta	al_my,x

	rts

;- - - - - - - - - -
.moveplayer		LOCAL
	PATHCMD
	ldy	pathplayer&WM

	POLL_MARIO

	a16
;-- get the distance between the player's position and the old position

	toheap	y,y

	lda	exal_worldx,y
	sec
	sbc	al_ox,x
	asl	a
	asl	a
	asl	a
	asl	a
	sta	x1
	sta	bigx

	lda	exal_worldy,y
	sec
	sbc	al_oy,x
	sta	y1
	sta	bigy

	lda	exal_worldz,y
	sec
	sbc	al_oz,x
	asl	a
	asl	a
	asl	a
	asl	a
	sta	z1
	sta	bigz

	lda	al_roty,x
	sec
	sbc	al_my,x
	and	#255
	beq	.norotate11
	xba
	sta	matyw

	lda	al_roty,x
	sec
	sbc	al_my,x
	and	#255
	xba
	clc
	adc	exal_roty,y
	sta	exal_roty,y

	stz	matxw
	stz	matzw

	s_rotate_16bit

.norotate11
	a16
	ldy	pathplayer&WM


	toheap	y,y

	lda	bigx
	adiv2
	adiv2
	adiv2
	adiv2
	clc
	adc	al_worldx,x
	sta	exal_worldx,y

	lda	y1
	clc
	adc	al_worldy,x
	sta	exal_worldy,y

	lda	bigz
	adiv2
	adiv2
	adiv2
	adiv2
	clc
	adc	al_worldz,x
	sta	exal_worldz,y

;	phx
;	ldx	pathplayer&WM
;	lda	exal_worldx,y
;	sta	al_worldx,x
;	lda	exal_worldy,y
;	sta	al_worldy,x
;	lda	exal_worldz,y
;	sta	al_worldz,x

;	a8
;	lda	exal_roty,y
;	sta	al_roty,x

;	plx

	a8
	UNPOLL_MARIO

	rts

;**********
.nextbossmode	LOCAL
	PATHCMD

	inc	bossmode
	inc	bossmode

	jmp	_padd1


;**********
.forcegosub	LOCAL
	PATHCMD
	ldy	pathptr
	s_beq	_padd3	; not within trigger routine

	lda	#2
	sta	pathforced

	s_set_strat	x,pm.strat

	a16
	getparam	1
	sta	pathgosubptr
	jmp	_padd3

;**********
.scenery	LOCAL
	PATHCMD
	s_set_alsflag	x,simpleobj
	jmp	pm.move

;**********
.zdistless	LOCAL
	PATHCMD

	a16
	getparam	1
	sta		pathx1
	a8
	ldy		pathplayer&WM
.zdistmoreorless
	a16
	toheap		y,y
	lda	exal_worldz,y
	sec
	sbc	al_worldz,x
	bpl	.zdnoneg
	nega
.zdnoneg	sta	pathz1

	a8

	lda		pifnot
	beq		.zdlpos
	stz		pifnot

	a16
	lda		pathz1
	cmp		pathx1
	s_bcs		_pjump3
	jmp		_padd5

.zdlpos	a16
	lda		pathz1
	cmp		pathx1
	s_bcc		_pjump3
	jmp		_padd5



;**********
.waitB	LOCAL
	PATHCMD
	addalvaroffset	1
	lda.w		0,y
	cmp		al_sbyte3,x
	s_beq		_pzadd2
	s_inc_alvar	B,x,al_sbyte3
	s_dec_alvar	W,x,al_sword2	; extended command...
	jmp		pm.move

;**********
.groundobjon	LOCAL
	PATHCMD
	s_set_altype	x,gnd
	jmp	_padd1

;**********
.groundobjoff	LOCAL
	PATHCMD
	s_clr_altype	x,gnd
	jmp	_padd1
;**********
.andframegoto	LOCAL

	PATHCMD

	getparam	1

	and	gameframe
	bne	.afg0
	jmp	_pjump2

.afg0	jmp	_padd4

;**********

.chainposalvar	LOCAL

	PATHCMD

	addalvaroffset	1

	lda.w		0,y

	bra		.chps

.chainpos	LOCAL

	PATHCMD

	getparam	1
.chps	sta		z1

	ldy		al_ptr,x
	s_obj2obj_3Dangle 	x,y,al_roty,al_rotx,0
	s_add_roffs2pos		B,x,y,y,#0,#0,z1,1,1,0,3,3,3

	jmp	_padd2


;**********
.pweapdeclmt	LOCAL

	PATHCMD

	ldy	al_ptr,x
	phx
	ldx	al_sword2,y
	txy
	plx

	s_beqdec_alvar	B,y,exal_laser_LMT,.nopwdec,#0

.nopwdec
	jmp	_padd1

;**********
.pweapinclmt	LOCAL

	PATHCMD

	ldy	al_ptr,x
	phx
	ldx	al_sword2,y
	txy
	plx
	s_inc_alvar	B,y,exal_laser_LMT

	jmp	_padd1
;**********
.pweaphit	LOCAL

	PATHCMD

	pnastyoff

	jsl	hitsomething_snd_srou_l
	bcc	.nohitslope


	dec	a
	bmi	.pwh0
	beq	.pwh1

.pwh2	jmp	_pjump5	; rebound
.pwh1	jmp	_pjump3	; damaged
.pwh0	jmp	_pjump1	; ground

.nohitslope	jmp	_padd7


;**********

.playershape	LOCAL

	PATHCMD

	pnastyoff

	lda	p1_PILOTNo
	jsl	setpilotshape_srou_l

	jmp	_padd1
;**********

.demoshape	LOCAL

	PATHCMD

	stx	demoshapeptr&WM

	jmp	_padd1

;**********

.campanplayerimmede	LOCAL

	PATHCMD

	ldy	pathplayer&WM

	bra	.cpsi0

;**********

.campandemoshapeimmede	LOCAL

	PATHCMD

	ldy	demoshapeptr&WM

	bra	.cpsi0
;**********

.campanshapeimmede	LOCAL

	PATHCMD

	ldy	al_ptr,x

.cpsi0	stz	smvar_byte1

	phx

	a16
	getparam	1
	tax
	getparam	3	; scale down
	and		#7
	sta		pathx1
	a8

	s_jsl	Xanglexy_l
	a16
	nega

.cpsi2	dec	pathx1
	bmi	.cpsi1
	asra
	bra	.cpsi2
.cpsi1	sta	al_rotx,x

	a8

	s_jsl	Yanglexy_l
	a16
	sta	al_roty,x
	a8

	s_achase_alvar	W,x,al_rotz,#0,2

	plx

	jmp	_padd4


;**********

.campandemoshape	LOCAL

	PATHCMD

	ldy	demoshapeptr&WM

	bra	.cps0

;**********

.campanplayer	LOCAL

	PATHCMD

	ldy	pathplayer&WM

	bra	.cps0

;**********

.campanshape		LOCAL


	PATHCMD

	ldy	al_ptr,x

.cps0
	stz	smvar_byte1

	phx

	a16
	getparam	1
	tax
	getparam	3	; scale down
	and		#7
	sta		pathx1
	a8

	s_jsl	Xanglexy_l
	a16
	nega

.cps2
	dec	pathx1
	bmi	.cps1
	asra
	bra	.cps2

.cps1
	sta	x1
	a8

	s_achase_alvar	W,x,al_rotx,x1,2

	s_jsl	Yanglexy_l
	a16
	sta	y1
	a8
	s_achase_alvar	W,x,al_roty,y1,2

	s_achase_alvar	W,x,al_rotz,#0,2

	plx

	jmp	_padd4


;**********

.setdemo		LOCAL

	PATHCMD

	getparam	1
	sta		demomode
	jmp	_padd2

;**********

.ifdemoend		LOCAL

	PATHCMD

	lda	demomode
	bne	._ifdemoend0
	jmp	_pjump1
._ifdemoend0
	jmp	_padd3

;**********

.ifnotdemo		LOCAL

	PATHCMD

	getparam	1
	cmp	demomode
	beq	._ifnotdemo0
	jmp	_pjump2

._ifnotdemo0

	jmp	_padd4

;**********

.ifsamedemo		LOCAL

	PATHCMD

	getparam	1
	cmp	demomode
	bne	._ifsamedemo0
	jmp	_pjump2

._ifsamedemo0

	jmp	_padd4

;**********

.demoend		LOCAL

	PATHCMD

	lda	#0
	sta	demomode

	jmp	_padd1

;**********
.demosetmap	LOCAL

	PATHCMD

	lda	demomapbank
	sta	mapbank
	phx
	ldx	demomapptr
	stx	mapptr
	plx

	jmp	_padd1

;**********

.copyplayerrot		LOCAL

	PATHCMD
	ldy	pathplayer&WM
	s_copy_rots	x,y

	jmp	_padd1


;**********

.ifplrweaplevel		LOCAL

	PATHCMD

	getparam	1

	cmp	p1_weap_level
	bne	.ifplrweaplevel0
	jmp	_pjump2

.ifplrweaplevel0

	jmp	_padd4


;**********

.setsndplace		LOCAL

	PATHCMD

	a16
	getparam	1
	sta		bgm_place

	jsl	setport3_l
	jmp	_padd3

;**********

.reboundlaser		LOCAL

	PATHCMD

	pnastyoff

	jsl	rebound_srou_l

	jmp	_padd1


;**********
.hitslope	LOCAL

	PATHCMD

	pnastyoff

	lda	al_slopenum,x
	pha

	jsl	getheight_l

	pla
	sta	al_slopenum,x

	a16
	lda	al_worldy,x
	sec
	sbc	y1
	bmi	.hs0
	jmp	_pjump1

.hs0	jmp	_padd3

;**********

.copypos2player		LOCAL

	PATHCMD

	ldy	pathplayer&WM
	s_copy_pos	y,x

	toheap	y,y

	a16
	lda	al_worldx,x
	sta	exal_worldx,y
	lda	al_worldy,x
	sta	exal_worldy,y
	lda	al_worldz,x
	sta	exal_worldz,y
	a8

	jmp	_padd1


;**********

;(change)

.copyrot2player		LOCAL

	PATHCMD
	ldy	pathplayer&WM
	s_copy_rots	y,x

	toheap	y,y

	a16
	lda	al_rotx-1,x
	and	#0ff00h
	sta	exal_rotx,y
	lda	al_roty-1,x
	and	#0ff00h
	sta	exal_roty,y

	lda	al_rotz,x
	and	#0ffh
	sta	exal_rotz,y

	jmp	_padd1

;**********

.copypos2viewimmede		LOCAL

	PATHCMD

	a16
	getparam	1
	tay
	a8
	s_copy_pos	y,x

	jmp	_padd3

;**********

.copyrot2viewimmede		LOCAL

	PATHCMD

	a16
	getparam	1
	tay
	lda	al_rotx-1,x
	and	#0ff00H
	sta.w	al_rotx,y
	lda	al_roty-1,x
	and	#0ff00H
	sta.w	al_roty,y
	lda	al_rotz-1,x
	and	#0ff00H
	sta.w	al_rotz,y
	a8

	jmp	_padd3

;**********

.copypos2view		LOCAL

	PATHCMD

	a16
	getparam	1
	tay
	a8
	s_achase_alvar2alvar	W,y,al_worldx,x,al_worldx,3
	s_achase_alvar2alvar	W,y,al_worldy,x,al_worldy,3
	s_achase_alvar2alvar	W,y,al_worldz,x,al_worldz,3

	jmp	_padd3

;**********

.copyrot2view		LOCAL

	PATHCMD

	a16
	getparam	1
	tay
	lda	al_rotx-1,x
	and	#0ff00H
	sta	x1
	lda	al_roty-1,x
	and	#0ff00H
	sta	y1
	lda	al_rotz-1,x
	and	#0ff00H
	sta	z1

	a8
	s_achase_alvar	W,y,al_rotx,x1,3
	s_achase_alvar	W,y,al_roty,y1,3
	s_achase_alvar	W,y,al_rotz,z1,3

	jmp	_padd3

;**********

.copyviewrots_demo		LOCAL

	PATHCMD

	ldy	#viewblk1	;pathplayer&WM

	lda.w	al_rotx+1,y
	sta	al_rotx,x
	lda.w	al_roty+1,y
	sta	al_roty,x
	lda.w	al_rotz+1,y
	sta	al_rotz,x

	jmp	_padd1

;**********

.copyviewpos_demo		LOCAL

	PATHCMD

	ldy	#viewblk1	;pathplayer&WM

	a16
	lda.w	al_worldx,y
	sta	al_worldx,x
	lda.w	al_worldy,y
	sta	al_worldy,x
	lda.w	al_worldz,y
	sta	al_worldz,x
	a8

	jmp	_padd1



;**********

;.nextTUTU	LOCAL
;
;	PATHCMD
;
;	pnastyoff
;	jsl	nextTUTU_path_srou_l	; tplayer.asm
;
;	jmp	_padd1


;**********

.copyviewrots		LOCAL

	PATHCMD

	ldy	pathplayer&WM

	toheap	y,y

	lda	exal_camrotx+1,y
	sta	al_rotx,x
	lda	exal_camroty+1,y
	sta	al_roty,x
	lda	exal_camrotz+1,y
	sta	al_rotz,x

	jmp	_padd1

;**********

.copyviewpos		LOCAL

	PATHCMD

	ldy	pathplayer&WM

	toheap	y,y

	a16
	lda	exal_camworldx,y
	sta	al_worldx,x
	lda	exal_camworldy,y
	sta	al_worldy,x
	lda	exal_camworldz,y
	sta	al_worldz,x
	a8

	jmp	_padd1


;**********

.setbg		LOCAL

	PATHCMD

	a16

;	lda	#bg_missionstage5-bglists

	getparam	1

	sta	currentbg
	lda	bgflags
	ora	#bgf_bg
	sta	bgflags
	a8

	jmp	_padd3
;**********

.circlewindow		LOCAL

	PATHCMD

	a16
	getparam	1
	sta		tpx
	a8
	pnastyoff
	jsl	circle_path_srou_l

	jmp	_padd3
;**********

.warpcirclewindow		LOCAL

	PATHCMD

	a16
	getparam	1
	sta		tpx
	a8
	pnastyoff
	jsl	warpcircle_path_srou_l

	jmp	_padd3
;**********

.bigcirclewindow		LOCAL

	PATHCMD

	a16
	getparam	1
	sta		tpx
	a8
	pnastyoff
	jsl	BIGcircle_path_srou_l

	jmp	_padd3
;**********

.circlewindowpos		LOCAL

	PATHCMD

	a8
	pnastyoff
	jsl	circle_objpos_srou_l

	jmp	_padd1


;**********

.scrflash		LOCAL

	PATHCMD

	pnastyoff
	jsl	addcol_path_srou_l

	jmp	_padd1

;**********

.nextmap		LOCAL

	PATHCMD

	lda	demoflag
	ora	#demoflag_nextmap
	sta	demoflag

	jmp	_padd1


;**********
.faceplayerofs	LOCAL

	PATHCMD

	s_push_obj		x
	ldx			pathplayer&WM
	ldy			dummyobj
	s_add_roffs2pos		B,y,x,x,pathx1,pathy1,pathz1,0,1,0,4,4,4
	s_pull_obj		x

	s_obj2obj_3Dangle 	x,y,al_roty,al_rotx,3

	jmp	_padd1

;**********

.clrdemoshape	LOCAL

	PATHCMD

	a16
	lda	al_worldx,x
	sta	clrdemoshape_x
	lda	al_worldy,x
	sta	clrdemoshape_y
	lda	al_worldz,x
	sta	clrdemoshape_z

	jmp	_padd1



;**********
.wobble	LOCAL
	PATHCMD

	txa
	clc
	adc	gameframe
	a16
	asl	a
	and	#62
	txy
	tax

	lda.l	.bigwobbletab,x
	clc
	adc.w	al_worldx,y
	sta.w	al_worldx,y

	lda.l	.bigwobbletab,x
	clc
	adc.w	al_worldz,y
	sta.w	al_worldz,y

	tya
	clc
	adc	gameframe
	clc
	adc	#7
	asl	a
	asl	a
	and	#62
	tax

	lda.l	.bigwobbletab,x
	clc
	adc.w	al_worldy,y
	sta.w	al_worldy,y

;	a8
;	tya
;	clc
;	adc	gameframe
;	clc
;	adc	#13
;	asl	a
;	a16
;	and	#62
;	tax
;	a8
;	lda.l	.bigwobbletab,x
;	asra
;	asra
;	asra
;	sta.w	al_rotz,y

	tyx
	jmp	_padd1

.bigwobbletab
	dw	8
	dw	6
	dw	4
	dw	3
	dw	2
	dw	1
	dw	1
	dw	0

	dw	0
	dw	-1
	dw	-1
	dw	-2
	dw	-3
	dw	-4
	dw	-6
	dw	-8

	dw	-8
	dw	-6
	dw	-4
	dw	-3
	dw	-2
	dw	-1
	dw	-1
	dw	0

	dw	0
	dw	1
	dw	1
	dw	2
	dw	3
	dw	4
	dw	6
	dw	8


.gsetb	LOCAL
	PATHCMD
	a16
	getparam	1
	tay
	a8
	getparam	3
	sta.w	0,y
	jmp		_padd4

;**********
.gsetw	LOCAL
	PATHCMD
	a16
	getparam	1
	tay
	getparam	3
	sta.w	0,y
	jmp		_padd5


;**********
.iflasttrig	LOCAL
	PATHCMD
	lda	triggercount
	dec	a
	lbne	_padd3
	jmp		_pjump1




;**********
.passsoundon	LOCAL

	PATHCMD

	s_set_alsflag	x,passsound
	jmp		_padd1


;**********
.passsoundoff	LOCAL

	PATHCMD

	s_clr_alsflag	x,passsound
	jmp		_padd1


;**********
.enemyrbdSE	LOCAL

	PATHCMD

	getparam	1
	s_set_resource	B,x,enemyRBDSEtype,A

	jmp		_padd2

;**********
.enemydmgSE	LOCAL

	PATHCMD

	getparam	1
	s_set_resource	B,x,enemySEtype,A

	jmp		_padd2


;**********
.radarobj	LOCAL
	PATHCMD
	getparam	1
	sta	al_radarobj,x
	jmp	_padd2

;**********
.clrtype	LOCAL
	PATHCMD
	getparam	1
	sta	pathx1
	lda	al_collflags,x
	and	pathx1
	sta	al_collflags,x
	jmp	_padd2

;**********
.settype	LOCAL
	PATHCMD
	getparam	1
	sta	pathx1
	lda	al_collflags,x
	ora	pathx1
	sta	al_collflags,x
	jmp	_padd2
	
;**********
.initanim0	LOCAL
	PATHCMD
	s_init_anim	x,#0
	jmp	_padd1

;**********
.fireobjon	LOCAL
	PATHCMD
	s_set_alsflag	x,fireobj
	jmp	_padd1

;**********
.fireobjoff	LOCAL
	PATHCMD
	s_clr_alsflag	x,fireobj
	jmp	_padd1

;**********
.addrandomB	LOCAL

	PATHCMD
	getparam	2
	sta	pathz1	; store the mask

	addalvaroffset	1
	jsl	random_l
	and	pathz1

	sta	tpx
	lda	pathz1
	lsr	a
	nega
	clc
	adc	tpx
	clc
	adc.w	0,y

	sta.w	0,y
	
	jmp	_padd3

;**********
.addrandomW	LOCAL
	PATHCMD
	a16
	getparam	2
	sta	pathz1	; store the mask
	a8
	addalvaroffset	1
	jsl	random_l
	xba
	jsl	random_l
	a16
	and	pathz1

	sta	tpx
	lda	pathz1
	lsr	a
	nega
	clc
	adc	tpx
	clc
	adc.w	0,y

	sta.w	0,y
	
	jmp	_padd4
	

;**********
.setbossmode	LOCAL
	PATHCMD
	getparam	1
	sta	bossmode
	jmp	_padd2

;**********
.swapvar	LOCAL
	PATHCMD
	addalvaroffset	1
	phy
	a16
	lda.w	0,y
	sta	pathy1
	a8
	addalvaroffset	2
	a16
	lda.w	0,y
	pha
	lda	pathy1
	sta.w	0,y
	pla
	ply
	sta.w	0,y

	jmp	_padd3

;**********
.tamehomon	LOCAL
	PATHCMD

	sp_tamehomon

	jmp	_padd1

;**********
.iftamehomon	LOCAL
	PATHCMD

	sp_jmp_iftamehomon	.itho

	jmp	_padd3

.itho	jmp	_pjump1


;---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---
;-*- -*- -*- -*- -*- -*- -*- -*- -*- -*- -*- -*- -*- -*- -*- -*- -*-
;---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---
	SHORTA
pathexplode_istrat
	s_start_strat
	s_set_resource	L,x,WhenDead,#.nothing
	brl	pm.strat
.nothing	jml	explode_istrat

;	jsr	pm.triggers
;	pnastyoff
;	jml	explode_istrat
;---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---
;-*- -*- -*- -*- -*- -*- -*- -*- -*- -*- -*- -*- -*- -*- -*- -*- -*-
;---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---
	SHORTA
pathhit_istrat
	s_start_strat
	s_set_alsflag	x,sflag7
	s_end_strat


;---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---
;-*- -*- -*- -*- -*- -*- -*- -*- -*- -*- -*- -*- -*- -*- -*- -*- -*-
;---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---

	IFEQ	1
trail_istrat
	s_start_strat
	s_set_aldata	x,#10,#hardAP
	s_set_strat		x,.strat
	s_set_alvar		B,x,al_sbyte1,#5
.strat	s_start_strat
	lda	al_sbyte1,x
	and	#1
	bne	.nodo
	s_cmp_alvar	B,x,al_depthoffset,#1
	s_beq		.nodo
	s_cmp_alvar	B,x,al_depthoffset,#5
	s_beq		.nodo
	s_cmp_alvar	B,x,al_depthoffset,#9
	s_beq		.nodo
	s_dec_alvar	B,x,al_depthoffset
.nodo
.move	s_add_playerz	x
	s_beqdec_alvar	B,x,al_sbyte1,.removeit
.end	s_end_strat
.removeit	s_remove_obj	x
	jmp		.end
	ENDC
;---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---
;-*- -*- -*- -*- -*- -*- -*- -*- -*- -*- -*- -*- -*- -*- -*- -*- -*-
;---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---

	getparam_codegen	1,8
	getparam_codegen	2,8
	getparam_codegen	3,8
	getparam_codegen	4,8
	getparam_codegen	5,8
	getparam_codegen	6,8
	getparam_codegen	7,8
	getparam_codegen	8,8
	getparam_codegen	9,8
	getparam_codegen	10,8
	getparam_codegen	11,8
	getparam_codegen	12,8
	getparam_codegen	13,8
	getparam_codegen	14,8
	getparam_codegen	15,8
	getparam_codegen	16,8
	getparam_codegen	17,8

	getparam_codegen	1,16
	getparam_codegen	2,16
	getparam_codegen	3,16
	getparam_codegen	4,16
	getparam_codegen	5,16
	getparam_codegen	6,16
	getparam_codegen	7,16
	getparam_codegen	8,16
	getparam_codegen	9,16
	getparam_codegen	10,16
	getparam_codegen	11,16
	getparam_codegen	12,16
	getparam_codegen	13,16
	getparam_codegen	14,16
	getparam_codegen	15,16
	getparam_codegen	16,16
	getparam_codegen	17,16




;---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---
;-*- -*- -*- -*- -*- -*- -*- -*- -*- -*- -*- -*- -*- -*- -*- -*- -*-
;---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---

;-------------------------------------------------------------------
;_pzadd17	s_set_alvar	B,x,al_sbyte3,#0
_padd17	a8
	s_add_alvar	W,x,al_sword2,#17
	jmp		pm.strat2
;-------------------------------------------------------------------
;_pzadd16	s_set_alvar	B,x,al_sbyte3,#0
_padd16	a8
	s_add_alvar	W,x,al_sword2,#16
	jmp		pm.strat2
;-------------------------------------------------------------------
;_pzadd14	s_set_alvar	B,x,al_sbyte3,#0
_padd14	a8
	s_add_alvar	W,x,al_sword2,#14
	jmp		pm.strat2
;-------------------------------------------------------------------
;_pzadd13	s_set_alvar	B,x,al_sbyte3,#0
_padd13	a8
	s_add_alvar	W,x,al_sword2,#13
	jmp		pm.strat2
;-------------------------------------------------------------------
;_pzadd9	s_set_alvar	B,x,al_sbyte3,#0
_padd9	a8
	s_add_alvar	W,x,al_sword2,#9
	jmp		pm.strat2
;-------------------------------------------------------------------
;_pzadd8	s_set_alvar	B,x,al_sbyte3,#0
_padd8	a8
	s_add_alvar	W,x,al_sword2,#8
	jmp		pm.strat2
;-------------------------------------------------------------------
;_pzadd7	s_set_alvar	B,x,al_sbyte3,#0
_padd7	a8
	s_add_alvar	W,x,al_sword2,#7
	jmp		pm.strat2
;-------------------------------------------------------------------
;_pzadd6	s_set_alvar	B,x,al_sbyte3,#0
_padd6	a8
	s_add_alvar	W,x,al_sword2,#6
	jmp		pm.strat2
;-------------------------------------------------------------------
;_pzadd5	s_set_alvar	B,x,al_sbyte3,#0
_padd5	a8
	s_add_alvar	W,x,al_sword2,#5
	jmp		pm.strat2
;-------------------------------------------------------------------
_pzadd4	s_set_alvar	B,x,al_sbyte3,#0
_padd4	a8
	s_add_alvar	W,x,al_sword2,#4
	jmp		pm.strat2
;-------------------------------------------------------------------
_pzadd3	s_set_alvar	B,x,al_sbyte3,#0
_padd3	a8
	s_add_alvar	W,x,al_sword2,#3
	jmp		pm.strat2
;-------------------------------------------------------------------
_pzadd2	s_set_alvar	B,x,al_sbyte3,#0
_padd2	a8
	s_add_alvar	W,x,al_sword2,#2
	jmp		pm.strat2
;-------------------------------------------------------------------
_pzadd1	s_set_alvar	B,x,al_sbyte3,#0
_padd1	a8
	s_inc_alvar	W,x,al_sword2
	jmp		pm.strat2
;-------------------------------------------------------------------
;-------------------------------------------------------------------
_pjump1	a16
	getparam	1
	sta		al_sword2,x
	a8
	jmp		pm.strat2

;-------------------------------------------------------------------
_pjump2	a16
	getparam	2
	sta		al_sword2,x
	a8
	jmp		pm.strat2
;-------------------------------------------------------------------
_pjump3	a16
	getparam	3
	sta		al_sword2,x
	a8
	jmp		pm.strat2
;-------------------------------------------------------------------
_pjump4	a16
	getparam	4
	sta		al_sword2,x
	a8
	jmp		pm.strat2
;-------------------------------------------------------------------
_pjump5	a16
	getparam	5
	sta		al_sword2,x
	a8
	jmp		pm.strat2
;-------------------------------------------------------------------
_pjump6	a16
	getparam	6
	sta		al_sword2,x
	a8
	jmp		pm.strat2
	
;-------------------------------------------------------------------
_pjump7	a16
	getparam	7
	sta		al_sword2,x
	a8
	jmp		pm.strat2
;-------------------------------------------------------------------

;--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
	SHORTA
_paddalvaroffset
	php
	a16
	stx	pathx1

	and	#255
	bit	#128
	beq	.simple
	clc
	adc	#(alx_start&WM)-128

.simple
	clc
	adc	pathx1
	tay
	plp
	rts

;---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---
;-*- -*- -*- -*- -*- -*- -*- -*- -*- -*- -*- -*- -*- -*- -*- -*- -*-
;---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---

;	printf	"Paths.asm = ",*-pathkern_start


	IFGT	(*-pathkern_start)-rampathsize
	run	" error <Paths too large by ",(*-pathkern_start)-rampathsize," bytes, increase rampathsize>"
	ENDC


;���������������������������������������������������������������������������
; Relocate us back into rom

rampathend	equ	rampathstart+(*-rampatharea)
	org	rampathend,$8000*(rampathend>>16)+(rampathend&$7fff)

;	printf	:$*," ",:$rampathend," ",:$$8000*(rampathend>>16)+(rampathend&$7fff),"%n"
;���������������������������������������������������������������������������


debugprint	a16
	printh	Forcing
	rtl

debugprint2	a8
	printd	Forcing2
	rtl




