;-------------------------------------------------------------------
; structure for basic map header
	structure	mapbase&WM
	struct	map_ctrl,1
	struct	map_count,2
	struct	map_size,0
map_sizeof	=	map_size-mapbase&WM

;-------------------------------------------------------------------
; structure for basic mothermap header
	structure	mapbase
	struct	moth_ctrl,1
	struct	moth_count,2
	struct	moth_size,0
moth_sizeof	=	moth_size-mapbase

;-------------------------------------------------------------------
; structure for mapmother


	structure	map_size
	struct	mm_x,2
	struct	mm_y,2
	struct	mm_z,2
	struct	mm_shape,2
	struct	mm_strat,3
	struct	mm_map,2
	struct	mm_size,0
mm_sizeof	equ	mm_size-mapbase&WM

;-------------------------------------------------------------------
; structure for mapremove
	structure	map_size
	struct	mr_shape,2
	struct	mr_size,0
mr_sizeof	equ	mr_size-mapbase&WM

;-------------------------------------------------------------------
; mothermap structures
;-------------------------------------------------------------------
; structure for motherobj
	structure	moth_size
	struct	mo_x,2
	struct	mo_y,2
	struct	mo_z,2
	struct	mo_shape,2
	struct	mo_strat,3
	struct	mo_size,0
mo_sizeof	=	mo_size-mapbase

;-------------------------------------------------------------------
; structure for motherloop
	structure	moth_size
	struct	ml_loop,2
	struct	ml_count,1
	struct	ml_size,0
ml_sizeof	=	ml_size-mapbase

;-------------------------------------------------------------------
; structure for mothergoto
	structure	moth_size
	struct	mg_loop,2
	struct	mg_size,0
mg_sizeof	=	mg_size-mapbase

;-------------------------------------------------------------------
; structure for mothercount
	structure	moth_size
	struct	mc_shape,2
	struct	mc_size,0
mc_sizeof	=	mc_size-mapbase

;-------------------------------------------------------------------
; structure for motherjump
	structure	moth_size
	struct	mj_val,2
	struct	mj_addr,2
	struct	mj_func,1	; 0 = EQ, 1 = NE, 2 = GT, 3 = LT
	struct	mj_size,0
mj_sizeof	=	mj_size-mapbase

mj_EQ	equ	0
mj_NE	equ	1
mj_GT	equ	2
mj_LT	equ	3


;-------------------------------------------------------------------
; structure for motherset

;	structure	moth_size
;	struct	ms_size,0
;ms_sizeof	=	ms_size-mapbase



;-------------------------------------------------------------------
; normal map structures
;-------------------------------------------------------------------
; structure for mapqobj

	structure	map_size-1
	struct	mq_x,1
	struct	mq_y,1
	struct	mq_z,1
	struct	mq_shape,1
	struct	mq_strat,1
	struct	mq_size,0
mq_sizeof	equ	mq_size-mapbase&WM

;-------------------------------------------------------------------
; structure for mapobj8

	structure	map_size-1 ; (count is only byte sized)
	struct	m8_x,1
	struct	m8_y,1
	struct	m8_z,1
	struct	m8_shape,1
	struct	m8_strat,1
	struct	m8_size,0
m8_sizeof	equ	m8_size-mapbase&WM

;-------------------------------------------------------------------
; structure for mapdobj

	structure	map_size
	struct	md_x,2
	struct	md_y,2
	struct	md_z,2
	struct	md_strat,1
	struct	md_size,0
md_sizeof	equ	md_size-mapbase&WM

;-------------------------------------------------------------------
; structure for mapobj

	structure	map_size
	struct	mobj_x,2
	struct	mobj_y,2
	struct	mobj_z,2
	struct	mobj_shape,1
	struct	mobj_strat,1
	struct	mobj_size,0
mobj_sizeof	equ	mobj_size-mapbase&WM

;-------------------------------------------------------------------
; structure for mapobjzrot

	structure	map_size
	struct	mz_x,2
	struct	mz_y,2
	struct	mz_z,2
	struct	mz_shape,1
	struct	mz_strat,1
	struct	mz_rotz,1
	struct	mz_size,0
mz_sizeof	equ	mz_size-mapbase&WM


;-------------------------------------------------------------------
; structure for m_inertobj

	structure	mapbase&WM
	struct	mio_ctrl,1
	struct	mio_x,2
	struct	mio_y,2
	struct	mio_z,2
	struct	mio_roty,1
	struct	mio_shape,2
	struct	mio_strat,3
	struct	mio_size,0
mio_sizeof	equ	mio_size-mapbase&WM

;-------------------------------------------------------------------
; structure for m_inertpath

	structure	mapbase&WM
	struct	mip_ctrl,1
	struct	mip_x,2
	struct	mip_y,2
	struct	mip_z,2
	struct	mip_roty,1
	struct	mip_shape,2
	struct	mip_path,2
	struct	mip_size,0
mip_sizeof	equ	mip_size-mapbase&WM

;-------------------------------------------------------------------
; structure for m_scale

	structure	mapbase&WM
	struct	ms_ctrl,1
	struct	ms_scale,1
	struct	ms_size,0
ms_sizeof	equ	ms_size-mapbase&WM


ols	=	mapbase&WM+1
oo_id	=	mapbase&WM
;-------------------------------------------------------------------
; structure for ols_object

	structure	ols
	struct	oo_shape,2
	struct	oo_strategy,3
	struct	oo_size,0
oo_sizeof	equ	oo_size-mapbase&WM

;-------------------------------------------------------------------
; structure for ols_pathobj

	structure	ols
	struct	opo_shape,2
	struct	opo_path,2
	struct	opo_size,0
opo_sizeof	equ	opo_size-mapbase&WM

;-------------------------------------------------------------------
; structure for ols_goto

	structure	ols
	struct	og_condition,1
	struct	og_addr,2
	struct	og_size,0
og_sizeof	equ	og_size-mapbase&WM

;-------------------------------------------------------------------
; structure for ols_wait

	structure	ols
	struct	ow_condition,1
	struct	ow_size,0
ow_sizeof	equ	ow_size-mapbase&WM

;-------------------------------------------------------------------
; structure for ols_positions

	structure	ols
	struct	op_numpos,1
	struct	op_size,0
op_sizeof	equ	op_size-mapbase&WM

;-------------------------------------------------------------------
; structure for ols_link

	structure	ols
	struct	ol_bypass,2
	struct	ol_size,0
ol_sizeof	equ	ol_size-mapbase&WM

;-------------------------------------------------------------------
; structure for map_area

	structure	mapbase&WM
	struct	ma_ctrl,1
	struct	ma_num,1
	struct	ma_x,1
	struct	ma_z,1
	struct	ma_width,1
	struct	ma_length,1
	struct	ma_addr,3
	struct	ma_size,0
ma_sizeof	equ	ma_size-(mapbase&WM)

;-------------------------------------------------------------------
; structure for map_setdust

	structure	mapbase&WM
	struct		msd_ctrl,1
	struct		msd_dustflags,2
	struct		msd_size,0
msd_sizeof	equ	msd_size-(mapbase&WM)

;-------------------------------------------------------------------
; structure for mapgotoiflevel

	structure	mapbase&WM
	struct		mgil_ctrl,1
	struct		mgil_level,1
	struct		mgil_addr,2
	struct		mgil_size,0
mgil_sizeof	equ	mgil_size-(mapbase&WM)


