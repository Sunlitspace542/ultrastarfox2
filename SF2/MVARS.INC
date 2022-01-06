
mpolylist	equ	1


; Mario zero page vars

	zmalc	m_bnorms,16
	zmalc	m_mariomode,2

	zmalc	m_sp,2		; sp temp
	zmalc	m_drawmap,2	; bitmap to draw to

; shape vars
	zmalc	m_pntptr,2	; shape ROM points data ptr
	zmalc	m_faceptr,2	; shape ROM faces data ptr
	zmalc	m_shapeptr,2	; shape ROM data ptr
	zmalc	m_shapebank,2	; shape ROM data bank
	zmalc	m_rotptr,2	; shape rotated points ptr
	zmalc	m_rotx,2	; shape angles
	zmalc	m_roty,2
	zmalc	m_rotz,2
	zmalc	m_bigx,2	; shape rotated relative pos
	zmalc	m_bigy,2
	zmalc	m_bigz,2
;	zmalc	m_x1,2		; shape relative pos
	zmalc	m_y1,2
	zmalc	m_z1,2
	zmalc	m_scale,2	; shape scale	(eg. 4)
	zmalc	m_shift,2	; shape shift	(eg. 2)
	zmalc	m_vanishx,2
	zmalc	m_vanishy,2
	zmalc	m_xleft,2
	zmalc	m_xright,2
	zmalc	m_ytop,2
	zmalc	m_ybot,2
	zmalc	m_cnt,2
	zmalc	m_texturemap,2	; texture mapping off/on (0/1)
	zmalc	m_framenum,2
	zmalc	m_colframe,2
	zmalc	m_expcnt,2
	zmalc	m_colourptr,2
	zmalc	m_shadestab,2
	zmalc	m_depthstab,2
	zmalc	m_depthtable,2
	zmalc	m_depthsptr,2
	zmalc	m_objflags,2
	zmalc	m_bspptr,2


	zmalc	m_tcmodecol,2
	zmalc	m_polybufptr,2
	zmalc	m_polylistptr,2
	zmalc	m_polyrsp,2


; scan converter vars

	zmalc	m_tr1,2		; tracer 1
	zmalc	m_tr2,2		; tracer 2

	zmalc	m_dy1,2		;
	zmalc	m_dy2,2		;

	zmalc	m_x1,2		;
	zmalc	m_x2,2		;
	zmalc	m_x1inc,2	;
	zmalc	m_x2inc,2	;

	zmalc	m_xp1,2		;
	zmalc	m_xp2,2		;
	zmalc	m_dxp1,2	;
	zmalc	m_dxp2,2	;
	zmalc	m_xp1inc,2	;
	zmalc	m_xp2inc,2	;

	zmalc	m_yp1,2		;
	zmalc	m_yp2,2		;
	zmalc	m_dyp1,2	;
	zmalc	m_dyp2,2	;
	zmalc	m_yp1inc,2	;
	zmalc	m_yp2inc,2	;

	zmalc	m_texptr,2	;

; clip vars	texture map Z clipper nicks these (CARL WOZ HERE!)
;m_cu1	=	m_yp1
;m_cu2	=	m_yp2
;m_cv1	=	m_dyp1
;m_cv2	=	m_dyp2

	zmalc	m_cu1,2
	zmalc	m_cu2,2
	zmalc	m_cv1,2
	zmalc	m_cv2,2
	zmalc	m_xtclip,2
	zmalc	m_ytclip,2
; clip vars

	zmalc	m_clipdx,2	;
	zmalc	m_clippnts,2	;
	zmalc	m_clipx,2	;
	zmalc	m_clipy,2	;
	zmalc	m_clipz,2	;
	zmalc	m_clip2drsp,2	; used in clp_poly to store rsp
;	zmalc	m_x2,2		;
	zmalc	m_y2,2		;
	zmalc	m_z2,2		;


; sprite vars
	zmalc	m_sprbank,2	; sprite data bank
	zmalc	m_sprdata,2	; sprite data addr
	zmalc	m_spra,2	; sprite matrix a
	zmalc	m_sprb,2	; sprite matrix b
	zmalc	m_sprc,2	; sprite matrix c
	zmalc	m_sprd,2	; sprite matrix d
	zmalc	m_sprxmin,2	; sprite x min
	zmalc	m_sprxmax,2	; sprite x max
	zmalc	m_sprymin,2	; sprite y min
	zmalc	m_sprymax,2	; sprite y max
	zmalc	m_sprx,2	; sprite x
	zmalc	m_spry,2	; sprite y
	zmalc	m_sprz,2	; sprite z
	zmalc	m_sprxscroll,2	; sprite x scroll
	zmalc	m_spryscroll,2	; sprite y scroll
	zmalc	m_sprx0,2	; sprite x0
	zmalc	m_spry0,2	; sprite y0
	zmalc	m_sprsize,2	; sprite size
	zmalc	m_sprwidth,2	; sprite height
	zmalc	m_sprheight,2	; sprite width
	zmalc	m_sprxscale,2	; sprite xscale
	zmalc	m_spryscale,2	; sprite yscale
	zmalc	m_sprangle,2	; sprite angle
	zmalc	m_sprmask,2	; sprite mask
	zmalc	m_spr0,2	; sprite temp



msprite		equ	m_spra
mspr_pal	equ	m_sprb
m_clipleft	equ	m_sprxmin
m_clipright	equ	m_sprxmax




;	?m_shapeptr

; view vars
     	zmalc	m_viewposx,2	; world pos
	zmalc	m_viewposy,2
	zmalc	m_viewposz,2
	zmalc	m_viewrotx,2	; world angles
	zmalc	m_viewroty,2
	zmalc	m_viewrotz,2
	zmalc	m_wmat11,2	; world matrix, 16 bit
	zmalc	m_wmat12,2
	zmalc	m_wmat13,2
	zmalc	m_wmat21,2
	zmalc	m_wmat22,2
	zmalc	m_wmat23,2
	zmalc	m_wmat31,2
	zmalc	m_wmat32,2
	zmalc	m_wmat33,2
	zmalc	m_wmat1211,2	; world matrix
	zmalc	m_wmat2113,2
	zmalc	m_wmat2322,2
	zmalc	m_wmat3231,2
	zmalc	m_wmat0033,2
	zmalc	m_lightx,2	; world light source vector
	zmalc	m_lighty,2
	zmalc	m_lightz,2
	zmalc	m_rotlightx,2	; rotated light source vector
	zmalc	m_rotlighty,2
	zmalc	m_rotlightz,2


; current shape vars
	zmalc	m_rmat1211,2	; shapes own matrix
	zmalc	m_rmat2113,2
	zmalc	m_rmat2322,2
	zmalc	m_rmat3231,2
	zmalc	m_rmat0033,2
	zmalc	m_rmat11,2	; shapes own matrix, 16 bit
	zmalc	m_rmat12,2
	zmalc	m_rmat13,2
	zmalc	m_rmat21,2
	zmalc	m_rmat22,2
	zmalc	m_rmat23,2
	zmalc	m_rmat31,2
	zmalc	m_rmat32,2
	zmalc	m_rmat33,2
	zmalc	m_mat1211,2	; shape matrix
	zmalc	m_mat2113,2
	zmalc	m_mat2322,2
	zmalc	m_mat3231,2
	zmalc	m_mat0033,2
	zmalc	m_mat11,2	; shape matrix, 16 bit
	zmalc	m_mat12,2
	zmalc	m_mat13,2
	zmalc	m_mat21,2
	zmalc	m_mat22,2
	zmalc	m_mat23,2
	zmalc	m_mat31,2
	zmalc	m_mat32,2
	zmalc	m_mat33,2
	zmalc	m_numpnts,2
	zmalc	m_fnumpnts,2
;	zmalc	m_numfaces,2
	zmalc	m_numgroups,2

	zmalc	m_or_of_outcodes,2
	zmalc	m_inpoints,2
	zmalc	m_groupnum,2
	zmalc	m_grouptab,2
	zmalc	m_rand,2


; ground dots vars
	zmalc	m_pxx,2
	zmalc	m_pxy,2
	zmalc	m_pxz,2
	zmalc	m_pzx,2
	zmalc	m_pzy,2
	zmalc	m_pzz,2
	zmalc	m_gridzsize,2
	zmalc	m_gridx,2
	zmalc	m_gridz,2

; texture map vars

	zmalc	m_fx0,2
	zmalc	m_fy0,2
	zmalc	m_fz0,2

	zmalc	m_fsx,2
	zmalc	m_fsy,2
	zmalc	m_fsz,2
	zmalc	m_ftx,2
	zmalc	m_fty,2
	zmalc	m_ftz,2
	zmalc	m_fpa,2
	zmalc	m_fpb,2
	zmalc	m_fpc,2

	zmalc	m_fpdlo,2
	zmalc	m_fpdhi,2
	zmalc	m_paxlo,2
	zmalc	m_paxhi,2
	zmalc	m_palo,2
	zmalc	m_pahi,2
	zmalc	m_pblo,2
	zmalc	m_pbhi,2
	zmalc	m_pclo,2
	zmalc	m_pchi,2
	zmalc	m_uax,2
	zmalc	m_ua,2
	zmalc	m_ub,2
	zmalc	m_uc,2
	zmalc	m_ud,2
	zmalc	m_vax,2
	zmalc	m_va,2
	zmalc	m_vb,2
	zmalc	m_vc,2
	zmalc	m_vd,2
	zmalc	m_vx,2
	zmalc	m_vy,2
	zmalc	m_xlen,2

	zmalc	m_bossmaxHP,2
	zmalc	m_bossHP,2
	zmalc	m_dotsorstars,2
	zmalc	m_pfm,2
	zmalc	m_shadowpass,2
	zmalc	m_depthoffset,2


; mhofs 
;	zmalc	testk,2
;	zmalc	testk2,2
;	zmalc	testk3,2
;	zmalc	testk4,2
	zmalc	m_sineoffset,2
	zmalc	m_scrollxoff,2
;


; Mario RAM vars

;	malc	py1n,1
;	malc	py2n,1
;	malc	x_data_blk,0


	malc	m_count,2
	malc	m_charset,2	; char set ptr
	malc	m_textpos,0	; text x,y pos
	malc	m_textposx,1
	malc	m_textposy,1
	malc	m_textcolour,0	; text colours c1,c2
;	malc	m_textc1,1
;	malc	m_textc2,1
;	malc	m_textr0,2	; text reg save area
;	malc	m_textr1,2
;	malc	m_textr2,2
;	malc	m_textr3,2
;	malc	m_textr4,2
;	malc	m_textr5,2
;	malc	m_textr11,2
;	malc	m_textr12,2
;	malc	m_textr13,2
;	malc	m_textr14,2

	include	myvars.inc	; yajima
	include	mtvars.inc	; kawagoe
	include	mkvars.inc	; kawaguchi

	malc	bg_scrollbuffer,0 ;224*3


mmaxxpos	=	224
mmaxypos	=	192

mmaxpnts	=	155
mmaxpolysize	=	155
mmaxgroups	=	16
mmaxstack	=	256
mmaxbsp	=	64
mmaxdust	=	128
mdustsizeof	=	6+6+2
mmaxdrawlist	=	dl_sizeof*number_al
mmaxvistab	=	155


	malc	m_meters,2
	malc	m_dlptr,2
	malc	m_shadowheight,2
	malc	m_stack,mmaxstack
	malc	m_zlist,0
	malc	m_rotpnts,6*mmaxpnts
	malc	m_projpnts,6*mmaxpnts
	malc	m_uvlist,0

;	malc	m_clippolybuf,mmaxpolysize
	malc	m_clippolybuf,0
	malc	m_cpolybuf,mmaxpolysize
	malc	m_bsplist,mmaxbsp
	malc	m_zbuf,mmaxgroups
	malc	m_uvlist2,0
; IFNE msmooth_shading
;	malc	m_intpnts,mmaxpnts
	malc	m_intpnts,0
; ENDC
	malc	m_vistab,mmaxvistab
	malc	m_drawlist,mmaxdrawlist



	malc	m_dustpnts1,mdustsizeof*mmaxdust
	malc	m_dustpnts2,mdustsizeof*mmaxdust
	malc	m_dustptr,2

	zmalc	m_dustflags,2	; flag defs in dalcs.inc
	zmalc	m_realdustflags,2

;	malc	m_scuptab,mmaxypos*2
;	malc	m_scdwntab,mmaxypos*2
	malc	m_scuptab,0
	malc	m_scdwntab,0


	malc	m_planetstars,2
	malc	m_particlesON,2
	malc	m_defaultID,2

;	malc	m_debugchars,8*16	; always last!

	malc	m_playerHP,2

;	malc	m_e_altmeter_x,2
;	malc	m_e_altmeter_y,2

	malc	m_screenvheight,2
	malc	m_screenheight,2
	malc	m_screenwidth,2
	malc	m_screenmode,2
	malc	m_screen3dxpos_1,2
	malc	m_screen3dxpos_2,2
	malc	m_screen3dypos_1,2
	malc	m_screen3dypos_2,2
	malc	m_screen3dpalette_1,2
	malc	m_screen3dpalette_2,2
	malc	m_blankpalette,2
	malc	m_blankchar,2

	malc	m_mariopoll,2
	malc	m_stackptr_bak,2

	malc	m_clipplanes,2

	malc	m_poolclip1,2
	malc	m_poolclip2,2

	malc	m_debugchars,0 8*16	; always last!

; 0000 vars	    512		4
; 0200 stack	    256		2
; 0280 rotpnts	    768		6
; 0280 projpnts    768		6
; 0280 vistab	    128		1
; 0280 zbuf	    128		1
; 0280 bsplist	    128		1
; 0280 polybuf	    128		1
; 0280 clippolybuf 128		1
; 0280 cpolybuf    128		1
; 0280 drawlist    512		4
; 0280 dustpnts    256		2
; 0280 free	    256		2
; 


  IFEQ	mpolylist

;mmaxxpos	=	gamenum_col*8	; 224
;mmaxypos	=	gamenum_row*8	; 192
;
;mmaxpnts	=	70	; was 80
;mmaxpolysize	=	128
;mmaxgroups	=	16
;mmaxstack	=	256
;mmaxbsp		=	40	; was 64
;mmaxdust	=	1			120
;mmaxvistab	=	100	; was 128
;mmaxdrawlist	=	dl_sizeof*number_drawal

	malc	m_polybuf,mmaxpolysize


 ENDC
 IFNE	mpolylist

;mmaxxpos	=	gamenum_col*8	; 224
;mmaxypos	=	gamenum_row*8	; 192

;mmaxpnts	=	70		; was 80
;mmaxpolysize	=	128
;mmaxgroups	=	16
;mmaxstack	=	256
;mmaxbsp	=	40		; was 64
;mmaxdust	=	1		; was 120
;mmaxvistab	=	100		; was 128
;mmaxdrawlist	=	dl_sizeof*number_drawal
mmaxpolylist	=	512


	malc	m_polybuf,mmaxpolysize
	malc	m_polylist,mmaxpolylist ; NB this uses upto 128 bytes BEFORE!!!
	malc	m_polylistend,0

 ENDC

;-- Plane clipping vars -- carl 6/4/94

* Set up a plane equation as part of a shape definition
* or routine called in draw list.
* The plane can then be used for clipping later objects

MAXPLANES	equ	8

	malc	m_cl_plane,0
	malc	m_cl_p1x,2	; x
	malc	m_cl_p1y,2	; y
	malc	m_cl_p1z,2	; z
	malc	m_cl_p2x,2
	malc	m_cl_p2y,2
	malc	m_cl_p2z,2
	malc	m_cl_pd,2	; d
	malc	m_cl_face,2
	malc	m_cl_tmp,2
	malc	m_xyz_avail,2	;- xyz version of poly exists

	malc	m_vert_d,mmaxpnts*2	;- Vert dist from plane 

	malc	m_cl_pls,8*MAXPLANES	;- Buffer for clip planes
	malc	m_cl_pn,2		;- Plane number

	malc	m_debugcount,2

;--
	malc	m_dustsprite,2
	malc	m_dustsize,2
	malc	m_dustframe,2

	malc	m_groundlevel,2		; ground level

	malc	m_bossname,4



; mplanet.mc variables

	IFEQ	0

	malc	m_smat11,0	
	malc	m_sex,2		
	malc	m_sey,2
	malc	m_sez,2
	malc	m_spx,2		
	malc	m_spy,2
	malc	m_spz,2
	malc	m_spex,2	
	malc	m_spey,2
	malc	m_spez,2
	malc	m_lx,2		
	malc	m_ly,2
	malc	m_lz,2
	ENDC
	zmalc	m_lxpos,2 	
	zmalc	m_lypos,2
	zmalc	m_lzpos,2
	zmalc	m_xspx,2	
	zmalc	m_xsex,2
	zmalc	m_xspex,2
	zmalc	m_xlx,2
	zmalc	m_yspy,2	
	zmalc	m_ysey,2
	zmalc	m_yspey,2
	zmalc	m_yly,2
	zmalc	m_xlen2,2
	zmalc	m_r11tmp1,2
	zmalc	m_r11tmp2,2
	zmalc	m_radius,2
	zmalc	m_radius2,2
	zmalc	m_rr,2
	zmalc	m_xc,2
	zmalc	m_yc,2
	zmalc	m_yp,2







;===================================================================
;	mhud.mc
;===================================================================

	malc	m_hudrot,2
	malc	m_hudcolour,2
	malc	m_hudflags,2
	malc	m_hudcol1,2
	malc	m_hudcol2,2

;===================================================================
;	mpart.mc
;===================================================================

	Zmalc	m_particlerand,2

maxparticles	=	300		mmaxpnts
part_len	equ	14

	malc	m_particles,part_len*(maxparticles+1)
;	malc	m_particlerand2,2
;	malc	m_drawparticles,(8+6)*(maxparticles+1)

;===================================================================
;	mdrawlis.mc
;===================================================================


	zmalc	m_clrbitmaps,2
	zmalc	m_player,2
	zmalc	m_numshapes,2
	zmalc	m_damage,2
	zmalc	m_boostcnt,2
	zmalc	m_boostanim,2

	zmalc	m_boostframex,2
	zmalc	m_boostposx,2

;===================================================================
;	mobj.mc
;===================================================================

	ifne	mario_stats3d

	malc	m_shapes_notdrawn,2
	malc	m_polys_drawn,2
	malc	m_lines_drawn,2
	malc	m_points_done,2
	malc	m_visis_done,2
	malc	m_polys_clip2d,2
	malc	m_polys_clip3d,2
	malc	m_poly_lists,2

	endc

;===================================================================
;	mcircle.mc
;===================================================================

m_circlebuf		equ	m_rotpnts
m_circlebuf2		equ	m_projpnts

;===================================================================
;	mdecru.mc
;===================================================================

m_enddata		equ	m_x1
m_enddatabnk		equ	m_x2
m_decaddr		equ	m_y1
m_decoffset		equ	m_y2
m_decend		equ	m_tr1

;===================================================================
;	mbumwipe.mc
;===================================================================

m_winwbglog		equ	m_bigx
m_wintabptr		equ	m_bigy

m_winbuf		equ	m_circlebuf
m_winbuf2		equ	m_circlebuf2

;===================================================================
;	mxtxprt.mc
;===================================================================

m_lastspace		equ	m_spra
m_lastlen		equ	m_sprb
m_lastnumchars	equ	m_sprc
m_lasttrans		equ	m_sprd
m_lastwidth		equ	m_sprxmin

m_linewrap		equ	m_sprbank
m_linetrn		equ	m_sprxmax
m_linewid		equ	m_sprymin

m_txtdata		equ	m_sprymax

m_textrightclip	equ	m_sprx

m_widthst		equ	m_rotpnts
m_transst		equ	m_rotpnts+512
m_totalchars		equ	m_sprxscale
m_lastchar		equ	m_spryscale

;===================================================================
;	mdebug.mc
;===================================================================

m_txtdatabank	equ	m_linewrap
m_visualwidth	equ	m_sprwidth
m_font		equ	m_sprx

;===================================================================
; mgdots.mc

;	malc	m_ts_buffer,number_turbosprites*ts_sizeof

	malc	m_p1_vx,2
	malc	m_p1_vy,2
	malc	m_p1_vz,2

;===================================================================
;===================================================================
;===================================================================
;===================================================================
;===================================================================

	malc	m_debugvar1,2
	malc	m_debugvar2,2
	malc	m_debugvar3,2

	malc	m_pollcon,4
	malc	m_pollchk,2



;####################################################################
;====================================================================
;	---------------------
;	BACKUP RAM AREA START
;	---------------------
;====================================================================
;####################################################################

	malc	m_backupram_start,0		; BACKUP START
	malc	m_backupcheck,2			; BACKUP sum CODE
	malc	m_magicnumber,2			; BACKUP entry ID

	malc	m_backupram_sumstart,0		; BACKUP sumcheck start

	malc	m_backupflags,2			; BACKUP special flag
	malc	m_backupcoin,8			; BACKUP all coin
	malc	m_backupcoincount,4		; BACKUP coin counter
	malc	m_backuprandom,2		; BACKUP random data

;---------------------------------------------------------------------

	malc	m_highscorestmp,0		; BACKUP hiscore structure

;----- structure of high score format
	structure	m_highscorestmp
	struct		hs_structstart,0	; BACKUP start
	struct		hs_code,1		; BACKUP hiscore code
	struct		hs_rank,1		; BACKUP hiscore rank
	struct		hs_name,3		; BACKUP hiscore name
	struct		hs_pilot,2		; BACKUP hiscore polot
	struct		hs_score,3		; BACKUP total score
	struct		hs_time,2		; BACKUP total time
	struct		hs_state,1		; BACKUP hiscore state
	struct		hs_percent,1		; BACKUP corneria percent
	struct		hs_planets,1		; BACKUP hit planets
	struct		hs_battleships,1	; BACKUP hit battleships
	struct		hs_kdifficulty,1	; BACKUP easy normal hard
	struct		hs_kxresult,1		; BACKUP result flag
	struct		hs_ecountmissile,2	; BACKUP missile
	struct		hs_ecountfighter,2	; BACKUP fighter
	struct		hs_basicscore,3		; BACKUP basic score
	struct		hs_resultflag,2		; BACKUP partner continue
	struct		hs_size,0
hs_sizeof	equ		hs_size-m_highscorestmp

	malc	m_highscores,number_highscores*hs_sizeof

	malc	m_backupram_sumexit,0		; BACKUP END 


	malc	m_backupram_subbuffer,m_backupram_sumexit-m_backupram_start

	IFNE	mmempt&1
	malc	m_odd_dummy,1			; word offset
	ENDC

	malc	m_backupram_end,0

;####################################################################
;====================================================================
;	---------------------
; 	 BACKUP RAM AREA END
;	---------------------
;====================================================================
;####################################################################

	malc	m_temptemp,4
	malc	m_currentpoll,4
	malc	m_bossmeter_off,2
	malc	m_olddrawmap,2


