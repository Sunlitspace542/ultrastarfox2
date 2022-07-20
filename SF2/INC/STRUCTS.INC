;-------------------------------------------------------------
; STRUCTS.INC
;

alcon	=	1
	fopen	alvars.txt

;List structures---------------------------------------
;(first 4 bytes are _next & _prev)
	structure	4
	struct	al_start,0
	defal	shape,2
	defal	ptr,2		; ptr to attached alien 
	defal	flags,1
	defal	type,1
	defal	count,1
	defal	count1,1
	defal	worldx,2		; world x,y,z
	defal	worldy,2
	defal	worldz,2
	defal	rotx,1		; angles x,y,z
	defal	sbyte1,1	; pad in case 16 bit angles are required
	defal	roty,1
	defal	sbyte2,1
	defal	rotz,1
	defal	sbyte3,1
	defal	vel,1
	defal	stratptr,3		; ptr to strategy routine
	defal	immuneptr,2		; ptr. to immunity object
	defal	hitlist,0
	defal	collobjptr_obsolete,2		; ptr to collision object
	defal	sflags,0		; strategy flags.
	defal	sflags1,1
	defal	sflags2,1		; strategy flags.
	defal	sflags3,1		; strategy flags.
	defal	sflags4,1		; strategy flags.
	defal	sflags5,1		; strategy flags.
	defal	sflags6,1		; strategy flags.
	defal	sflags7,1		; strategy flags.
	defal	skidy,1
	defal	sbyte4,1		; BEFORE ADDING ALIEN VARIABLES
	defal	sword1,2		; PLEASE READ THE COMMENTS ON
	defal	sword2,2		; THE MACROS S_GET_RESOURCE
	defal	HP,1			; AND S_SET_RESOURCE IN STRATLIB.INC
	defal	AP,1
	defal	weapontype,1
	defal	collcount,1		; collision time counter.
	defal	collflags,1		; collision flags.
	defal	vx,2
	defal	vy,2
	defal	vz,2
	defal	hitflags,1
	defal	ox,2
	defal	oy,2
	defal	oz,2
	struct	al_size,0

	alc	viewblk,al_size
	alc	viewblk1,al_size
	alc	viewblk2,al_size
	alc	alblks,al_size*number_al
	xalc	xviewblk1,al_size
	xalc	xviewblk2,al_size
	xalc	xalblks,al_size*number_al

	structure	xalblks-alblks
	struct	alx_start,0
	defalx	mx,2	; movement vectors (rotated by the angle of the current slope)
	defalx	my,2
	defalx	mz,2
;	defalx	expstratptr,3	; ptr to explosion strategy routine
;	defalx	collstratptr,3	; ptr to collision strategy routine
	defalx	stratstate,1	; 
	defalx	depthoffset,2
	defalx	colframe,1	; BEFORE ADDING ALIEN VARIABLES
	defalx	animframe,1	; PLEASE READ THE COMMENTS ON
	defalx	snd1,0		; THE MACROS S_GET_RESOURCE
	defalx	snd2,1		; AND S_SET_RESOURCE IN STRATLIB.INC
	defalx	coltab,2
	defalx	childx,2
	defalx	childy,2
	defalx	childz,2
	defalx	childrotx,1
	defalx	childroty,1
	defalx	childrotz,1
	defalx	childrotobj,2
	defalx	tx,1
	defalx	ty,1
	defalx	memptr,2
	defalx	stackptr,2
	defalx	stratmem,2
	defalx	pbyte1,1
	defalx	pbyte2,1
	defalx	pword1,2
	defalx	inertptr,2
	defalx	slopeptr,2
	defalx	slopenum,1
	defalx	slopetype,1
	defalx	resources,2
	defalx	radarobj,1
	defalx	clip,1			; plane clipping flag
	defalx	area,1
	struct	alx_size,0
alx_sizeof	=	alx_size-xalblks+alblks

	fclose

	IFGT	alx_sizeof-al_size
	error	<Extended alien blocks have exceeded their maximum size!>
	ENDC

	IF	al_size>63
	error	<Alien blocks are too large (64 bytes max)>
	ENDC
;----------------------------------


;Strategy data block
	structure	4
	struct	sb_ptr,2
	struct	sb_x,2
	struct	sb_y,2
	struct	sb_z,2
	struct	sb_size,0

;Zed Sort block
	structure	4
	struct	zb_ptr,2
	struct	zb_x,2
	struct	zb_shadx,2
	struct	zb_y,2
	struct	zb_shady,2
	struct	zb_z,2
	struct	zb_shadz,2
	struct	zb_sz,2
	struct	zb_size,0


;----- structure of drawlist format
	structure	$700000
	struct		dl_next,2
	struct		dl_sortz,2
	struct		dl_rotx,1
	struct		dl_roty,1
	struct		dl_rotz,1
	struct		dl_sflags,1
	struct		dl_shape,2
	struct		dl_shady,2
	struct		dl_shadx,2
	struct		dl_shadz,2
	struct		dl_y,2
	struct		dl_x,2
	struct		dl_z,2
	struct		dl_coltab,2
	struct		dl_expcnt,1
	struct		dl_animframe,1
	struct		dl_colframe,1
	struct		dl_depth,1
 	struct		dl_tscrollx,1
	struct		dl_tscrolly,1
	struct		dl_clip,1
	struct		dl_dummy,1	; available for use
	struct		dl_xx,2
	struct		dl_yy,2
	struct		dl_zz,2
	struct		dl_size,0
dl_sizeof	equ		dl_size-$700000

;----- structure of allocation array of colour window
;(19 byte) * 9 * 2
	structure	0
	struct		wm_w12sel,1	;2123h
	struct		wm_w34sel,1	;2124h
	struct		wm_wobjsel,1	;2125h
	struct		wm_wbglog,1	;212ah
	struct		wm_wobjlog,1	;212bh
	struct		wm_ts,1		;212dh
	struct		wm_cgswsel,1	;2130h
	struct		wm_cgadsub,1	;2131h
	struct		wm_coldata,1	;2132h
	struct		wm_coldata_r,1	;2132h
	struct		wm_coldata_g,1	;2132h
	struct		wm_coldata_b,1	;2132h
	struct		wm_chparams,1	;43*0h
	struct		wm_hdma,3	;43*2h~43*5h
	struct		wm_val,1	;fade timer
	struct		wm_flags,1	;repeat flag
	struct		wm_sizeof,0

;----------------------------------
; window flags
	defflaglist	wf
	defflag		datarepeat	;0/1 ... data   normal /rept
	defflag		windowon	;0/1 ... window off/on
;;;wm_wbglog	equ	wm_cgadsub

maxwindows	=	0
; the windows are in priority order - highest is first
	defwindow	pausewindow
	defwindow	wipe
	defwindow	blackfade
	defwindow	whitefade
	defwindow	redfade
	defwindow	hitflash	
	defwindow	circle
	defwindow	outofbounds
	defwindow	dyingred
;maxwindows	= 9
;------------------------------------------------------------------
	xalc	collisttemp,0

; collision list structure
	structure	collisttemp
	struct	cl_alien,2
	struct	cl_colbox,2
	struct	cl_xmax,2
	struct	cl_ymax,2
	struct	cl_zmax,2
	struct	cl_size,0

cl_sizeof	=	cl_size-collisttemp


; COLBOXES
	xalc	collist,number_al*cl_sizeof

;----------------------------------
; hit list structure
	structure	4
	struct		hl_alptr,2	; pointer to alien that is hit
	struct		hl_hlptr,2	; pointer to hit list structure of alien that is hit
	struct		hl_hitflags,1	; which hit flag was set
	struct		hl_flags,1	; various flags
	struct		hl_count,1	; how many frames it has been colliding
	struct		hl_sizeof,0

; allow a maximum of one hit per shape, if the number of hits in one frame
; exceeds number_hl then the left over hits won't be registered. (in fact
; the game will probably crash at the moment!)

	xalc	hitlist,number_hl*hl_sizeof
	alc	hitlistfree,2

;----------------------------------
; hit list flags
	defflaglist	hf
	defflag		stillcolliding	; if zero hlblock should be removed
	defflag		firstframe

;----------------------------------
; inert object structure
	structure	4
	struct	i_worldx,2
	struct	i_worldy,2
	struct	i_worldz,2
	struct	i_rotx,1
	struct	i_roty,1
	struct	i_rotz,1
	struct	i_shape,2
	struct	i_strat,3
	struct	i_flags,1
	struct	i_alienptr,2
	struct	i_poslist,3	; used by order list system
	struct	i_area,1
	struct	i_sizeof,0


	xalc	inertlist,number_inert*i_sizeof
	alc	inertfree,2
	alc	inertlistptr,2

;----------------------------------
; inert flags
	defflaglist	if
	defflag		exists
	defflag		pathobj
	defflag		olsobj
	defflag		norangecheck
	defflag		removedinview
	defflag		target

;----------------------------------
; object structure for map screen

	structure	4
	struct		ob_x,1
	struct		ob_y,1
	struct		ob_spr,2
	struct		ob_path,2
	struct		ob_flags,1
	struct		ob_sizeof,0

;----------------------------------
; object flags
	defflaglist	obf
	defflag		destroyed

	xalc		obblocks,number_ob*ob_sizeof
	alc		obfree,2
	alc		oblist,2

;----------------------------------
;----- structure of radarlist format
	structure	$700000
	struct		rl_start,0
	struct		rl_x,2
	struct		rl_y,2
	struct		rl_z,2
	struct		rl_alptr,2
	struct		rl_outx,2
	struct		rl_outy,2
	struct		rl_outz,2
	struct		rl_size,0
rl_sizeof	equ		rl_size-rl_start

;------------------------------------
; structure for slope boxes

	structure	0
	struct	sl_frames,1
	struct	sl_x,2
;;	struct	sl_y,2
	struct	sl_z,2
	struct	sl_width,2
	struct	sl_length,2
	struct	sl_nx,1
	struct	sl_ny,1
	struct	sl_nz,1
;;	struct	sl_rotx,1
;;	struct	sl_rotz,1
	struct	sl_dist,2
	struct	sl_poly,2
	struct	sl_type,1
	struct	sl_scale,1
	struct	sl_sizeof,0

;------------------------------------
	xalc		debugtmp,0

	structure	debugtmp
	struct	de_text,3
	struct	de_value,2
	struct	de_type,1
	struct	de_count,1
	struct	de_size,0
de_sizeof	equ	de_size-debugtmp

	xalc	debuglist,de_sizeof*number_debug	; up to 50 items can be reported
	xalc	debugcount,2

dt_unused	equ	0
dt_dec	equ	1
dt_hex	equ	2
dt_nonumber	equ	3
dt_bin	equ	4

debug_delay	equ	100


;------------------------------------
; FontHeader structure

	structure	0
	struct		fh_width,1
	struct		fh_height,1
	struct		fh_firstentry,1
	struct		fh_lastentry,1
	struct		fh_spacing,1
	struct		fh_offset,2
	struct		fh_sizeof,0


;------------------------------------
; structure for storing area information

	xalc	areastmp,0

	structure	0
	struct		mar_x,2
	struct		mar_y,2
	struct		mar_z,2
	struct		mar_width,2
	struct		mar_height,2
	struct		mar_length,2
	struct		mar_mapaddr,3
	struct		mar_flags,1
	struct		mar_sizeof,0

	xalc	areas,number_area*mar_sizeof

	defflaglist	ar
	defflag		solid
	defflag		active

;------------------------------------
; map stack structure for storing map states

	structure	0
	struct		mss_prev,2
	struct		mss_next,2
	struct		mss_mapptr,2
	struct		mss_mapbank,1
	struct		mss_olslinks,(2+3)*ols_maxlinks
	struct		mss_olslptr,2
	struct		mss_olsobjs_num,2
	struct		mss_olsobj_dead,2
	struct		mss_olspositions_addr,3
	struct		mss_olspositions_num,1
	struct		mss_areas,mar_sizeof*number_area
	struct		mss_numareas,1
	struct		mss_sizeof,0


;------------------------------------
; structure for turbo sprites

	structure	0
	struct	ts_sprite,1
	struct	ts_size,1
	struct	ts_anim,1
	struct	ts_animlimit,1
	struct	ts_x,2
	struct	ts_y,2
	struct	ts_z,2
	struct	ts_sizeof,0


;------------------------------------

alcon	=	0


