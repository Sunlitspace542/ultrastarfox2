 
	zalc	mariocodebank,1

rampathsize	equ	19*k+512
	xxalc	rampatharea,rampathsize

	alc	CurrentArea,1
	alc	SecondaryArea,1
	alc	NumAreas,1

	xalc	pathgosubcount,1
	alc	pathparam,2
	alc	pollstack,1
	alc	screenheight,2
	alc	screenvheight,2
	alc	screenwidth,2
	alc	screen3dxpos_1,2
	alc	screen3dxpos_2,2
	alc	screen3dypos_1,2
	alc	screen3dypos_2,2
	alc	screen3dpalette_1,2
	alc	screen3dpalette_2,2
	alc	blankpalette,2
	alc	blankchar,2

	alc	tempchildnum,1
	alc	singlestep,1
	alc	blinkcol,2
	alc	mapbank,1
	alc	maprestartbank,1
	alc	maprestartbanktemp,1
	alc	newmap,3

	alc	viewblock,2

	xalc	maprestartjsrptr,2
	xalc	maprestartnumjsr,2
	xalc	maprestartjsrstk,3*15
	xalc	maprestartaddrs,2*4
	xalc	maprestartloops,2*4
	xalc	maprestartnumloops,2

heapsize	equ	18*k
	xalc	xheap,heapsize
heap	equ	xheap&WM

	xalc	xfmtemp1,2
	xalc	xfmtemp2,2
	xalc	xfmtemp3,2
	xalc	xfreespare,2

fmtemp1	equ	xfmtemp1&WM
fmtemp2	equ	xfmtemp2&WM
fmtemp3	equ	xfmtemp3&WM
freespare	equ	xfreespare&WM

	xalc	xstackdata,4

stackdata	equ	xstackdata&WM

	xalc	xpathptr,2
	xalc	xpathgosubptr,2
pathgosubptr	equ	xpathgosubptr&WM

pathptr	equ	xpathptr&WM

	xalc	xpathforced,1

pathforced	equ	xpathforced&WM

	xalc	xpifnot,1
pifnot	=	xpifnot&WM



	xalc	ramdrawlist,dl_sizeof*numals


	alc	ptrig,2
	alc	pcont,2

	alc	player1vscroll,2
	alc	player1hscroll,2
	alc	player2vscroll,2
	alc	player2hscroll,2

	alc	dostrats_alptr,2

	xalc	v_shadowheight,2
	xalc	v_viewposy,2
	xalc	v_numshapes,2
	alc	v_whichview,1

	alc	screenoffirq,2
	alc	trans_flag2,2
	alc	currentslope,2
	alc	lastslope,2
	alc	lastslopenum,2
	alc	oldworldx,2
	alc	oldworldy,2
	alc	oldworldz,2
	alc	dynamflag,2
	alc	closestslopepoly,2
	alc	currentslopepoly,2
	alc	closestslopescale,2
	alc	closestslopeheight,2
	alc	closestslope,2
	alc	closestslopenum,2
	alc	tmp_spra,2
	alc	tmp_sprb,2
	alc	tmp_sprc,2
	alc	tmp_sprd,2
	alc	tmp_rotx,2
	alc	tmp_rotz,2
	xalc	pathplayer,2

	alc	hvofs_buf1,128
	alc	hvofs_buf2,128

	alc	v1x,2
	alc	v1z,2
	alc	v2x,2
	alc	v2z,2

	alc	scalevar1,2
	alc	scalevar2,2
	alc	scalevar3,2
	alc	scalevar4,2

	alc	viewrange,2
	alc	viewrange2,2
	alc	maprange,2
	alc	maprange2,2

	alc	cockpit_transferred,1

	alc	bg2charsize,1
	alc	bg3charsize,1
	alc	bg3screensize,1

	alc	currentslopetype,2
	alc	closestslopetype,2

	alc	currentslopex1,2
	alc	currentslopex2,2
	alc	currentslopez1,2
	alc	currentslopez2,2

	alc	closestslopex1,2
	alc	closestslopex2,2
	alc	closestslopez1,2
	alc	closestslopez2,2

	xxalc	cockpitcgx_buf,cockpit_cgx_len

	alc	cockpitscrptr,3
	alc	cockpitcgxptr,3

	alc	screentype,1

	alc	screenmode,2

	alc	tempview,30

	alc	olspositions_addr,3
	alc	olspositions_num,1
	alc	olsobjs_num,2
	alc	olsobj_dead,2

	alc	olslinks,(2+3)*ols_maxlinks
	alc	olslptr,2

	xalc	oldpx1,2
	xalc	oldpz1,2
	xalc	oldpx2,2
	xalc	oldpz2,2

	xalc	restemp,2
	xalc	smtemp1,2

	xalc	hit_hlptr,2
	xalc	hit_ap,1
	xalc	hit_framecount,1

	xalc	MessageNumber,1
	xalc	MessageCount,1

	alc	vram_bg1_cgx1,2
	alc	vram_bg1_cgx2,2
	alc	vram_bg1_scr,2
	alc	vram_bg2_cgx,2
	alc	vram_bg2_scr,2
	alc	vram_bg3_cgx,2
	alc	vram_bg3_scr,2
	alc	vram_obj_cgx,2
	alc	vram_hvofs_base1,2
	alc	vram_hvofs_base2,2

	defflaglist	sm	; current screen mode/vram lay out
	defflag		twoscreen
	defflag		onescreen
	defflag		cockpit
	defflag		noplayer
	defflag		vertconnect
	defflag		3dglasses
	defflag		novofs
	defflag		nosprites
	defflag		midscreenirq
	defflag		training
	defflag		noborder
	defflag		swapbg1bg2
	defflag		noscreen
	defflag		blankborder
	defflag		creditsirq


	xalc		switchflags,2
	defflaglist	switch
	defflag		1
	defflag		2
	defflag		3
	defflag		4
	defflag		5
	defflag		6
	defflag		7
	defflag		8
	defflag		9
	defflag		10
	defflag		11
	defflag		12
	defflag		13
	defflag		14
	defflag		15
	defflag		16


	xalc		inertrescan,1

	xalc		solidblockmap,(blockmap_numblocks/8)*blockmap_numblocks

	zalc		path_pcptr,3

	xalc		slopetemp,2


; m_dustflags flag definitions:

	defflaglist	df
	defflag		ground	; clamp newly created dust to ground (0)
	defflag		sprites	; draw sprites, not dots
	defflag		belt	; asteroid belt (clamp Y to 0->256)
	defflag		raining	; it's raining...
	defflag		moving	; katte ni ugoiteiru.
	defflag		bubbles	; bubbles are a blowing upwards
	defflag		coloured; colour the dots?
	defflag		mixed	; mix dots with sprites
;	defflag		zsort	; zsort the dot list (chotto jikan kakaru)

df_animremove	equ	df_sprites!df_coloured	; animate and remove on frame 0



	xalc	slopepoll,1

	alc	whichsound,1

	alc	stardustkazu,2

	xalc	maxmaprangestore,2

	xalc	pathcommandcount,2

	xalc	tempinertflags,2

	xalc	bclipflag,1
	xalc	triggerloopptr,2
	xalc	triggerloopcnt,1
	xalc	triggercount,1

	xalc	friendmsg_y,2

	xalc	hit_noaffect_chk,1

	xalc	credits_count1,2
	xalc	credits_count2,2
	xalc	credits_count3,2
	xalc	credits_count4,2
	xalc	credits_count5,2
	xalc	credits_count6,2
	xalc	credits_count7,2
	xalc	credits_count8,2

	xalc	credits_on,1
	xalc	credits_fade,1

	alc	screenon_position,2

	xalc	message_lastpos,1
	xalc	cs_shapename,2

;----------
;----------
;----------
	xalc	path_zero_page,0

;---------- dylan

	xalc	bbyte1,1
	xalc	bbyte2,1
	xalc	bbyte3,1
	xalc	bbyte4,1
	xalc	bword1,2
	xalc	bword2,2

	xalc	gbyte1,1
	xalc	gbyte2,1
	xalc	gbyte3,1
	xalc	gword1,2
	xalc	gword2,2
	xalc	gword3,2

	xalc	becomeobj,2
	xalc	becomepath,2
	xalc	becomelastobj,2

	xalc	bossHP,2
	xalc	bossmaxHP,2

	xalc	bossname,4

	xalc	andorf_core_hp,1
	xalc	andorf_core_onetime,1

	xalc		bossflags,2
	xalc		bossmode,2
	xalc		bossmodestore,2

	xalc	cseq_ptr,2
	xalc	cseq_flag,1

;---------- eguchi

	xalc	ebyte1,1
	xalc	ebyte2,1
	xalc	ebyte3,1
	xalc	ebyte4,1
	xalc	ebyte5,1
	xalc	ebyte6,1
	xalc	ebyte7,1
	xalc	ebyte8,1

	xalc	eword1,2
	xalc	eword2,2
	xalc	eword3,2

	xalc	EEnemyNumPlanet1,1
	xalc	EEnemyNumPlanet2,1
	xalc	EEnemyNumPlanet3,1
	xalc	EEnemyNumPlanet4,1
	xalc	EEnemyNumPlanet5,1
	xalc	EEnemyNumPlanet6,1

	xalc	eaction1,1
	xalc	eaction2,1
	xalc	eftame,1

	xalc	RannyuModeSwitch,2

	xalc	CurrentSwitch,2
	xalc	CurrentEEnemyNumber,1

	xalc	SebangoSwitch_0,2
	xalc	SebangoSwitch_1,2
	xalc	SebangoSwitch_2,2
	xalc	SebangoSwitch_3,2
	xalc	SebangoSwitch_4,2
	xalc	SebangoSwitch_5,2
	xalc	SebangoSwitch_6,2
	xalc	SebangoSwitch_7,2
	xalc	SebangoSwitch_8,2
	xalc	SebangoSwitch_9,2
	xalc	SebangoSwitch_a,2
	xalc	SebangoSwitch_b,2
	xalc	SebangoSwitch_c,2
	xalc	SebangoSwitch_d,2
	xalc	SebangoSwitch_e,2
	xalc	SebangoSwitch_f,2

	xalc	EEnemyNumber_0,1
	xalc	EEnemyNumber_1,1
	xalc	EEnemyNumber_2,1
	xalc	EEnemyNumber_3,1
	xalc	EEnemyNumber_4,1
	xalc	EEnemyNumber_5,1
	xalc	EEnemyNumber_6,1
	xalc	EEnemyNumber_7,1
	xalc	EEnemyNumber_8,1
	xalc	EEnemyNumber_9,1
	xalc	EEnemyNumber_a,1
	xalc	EEnemyNumber_b,1
	xalc	EEnemyNumber_c,1
	xalc	EEnemyNumber_d,1
	xalc	EEnemyNumber_e,1
	xalc	EEnemyNumber_f,1

	xalc	etemp,1
	xalc	ehight,2
	xalc	etrigger,1

	xalc	especialhp1,1
	xalc	especialhp2,1

	xalc	eandorf_mode,1

	xalc	emedal_1,2
	xalc	emedal_2,2
	xalc	emedal_3,2
	xalc	emedal_4,2

	xalc	emedaleasy,1
	xalc	emedalnormal,1
	xalc	emedalhard,1

	xalc	ecountmissile,2
	xalc	ecountfighter,2

	xalc	ehp_algy,1
	xalc	ehp_leon,1
	xalc	ehp_pigma,1

	xalc	emeteohit,1
;---------- kawagoe

	xalc	player1_worldx,2
	xalc	player1_worldy,2
	xalc	player1_worldz,2
	alc	planet_mode,1

;---------- kawaguchi
	xalc	Kdifficulty,2		;easy/normal/hard
	xalc	KEnemyNumber,2		;teki no kazu (sprites)
	xalc	PlanetSwitch,2		;Planet no Clear State Switch
