;                            ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍµ  StarFox II ÆÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
;º                           ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ                              º
;º  Copyright Argonaut Software Limited, 1993.                            º
;º  All Rights Reserved.                                                  º
;ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
;º  Filename:     KSTRATS.ASM                                             º
;ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
;º  Description:  Strategy code.                                          º
;ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
;º  Date:         14/5/93.                                                º
;ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
;º  Author:       Yasuhiro Kawaguchi                                      º
;ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
;º  Modification list:                                                    º
;º                                                                        º
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼


	INCPUB	kstrats


	IFEQ	1


;============ Parameter ==========
kvel0	equ	$0

;============ Flag ===============
;-------- pbyte1 --------
;-------- pbyte2 -------
;-------- sbyte4 -------
;-------- pword1 -------
;-------- sword2 -------
;-------------------------------------------------------------------
;sflag3	:transform flag
;sflag4	:transform flag
;-------------------------------------------------------------------

;*********************************************************************
;*								*
;*			Temporary Strats			*
;*	 							*
;*********************************************************************
kstrat_istrat
	s_start_strat
	s_set_alptrs	x,.strat,hit_istrat,explode_istrat
	s_set_aldata	x,#10,#10	; hp,ap

;;;	s_set_alsflag	x,shadow	;shadow on
;;;	s_set_alsflag	x,colldisable

.strat	s_start_strat


.end	s_end_strat
;--------------------------------------------------------------------
kcolloff_istrat
	s_start_strat
	s_set_alptrs	x,.strat,hit_istrat,explode_istrat
	s_set_aldata	x,#10,#10	; hp,ap

.strat	s_start_strat
	s_set_alsflag	x,colldisable	;collions off
.end	s_end_strat
;--------------------------------------------------------------------
krot_istrat
	s_start_strat
	s_set_alptrs	x,.strat,hit_istrat,explode_istrat
	s_set_aldata	x,#10,#10	; hp,ap

;;;	s_set_alsflag	x,shadow	;shadow on
;;;	s_set_alsflag	x,colldisable

.strat	s_start_strat

;	s_add_alvar	B,x,al_rotx,#2
	s_add_alvar	B,x,al_roty,#2

.end	s_end_strat

;*********************************************************************
;*								*
;*			Base Strats				*
;*								*
;*********************************************************************
;*********************************************************************
;*								*
;*			Enemy Strats				*
;*								*
;*********************************************************************
;========================== Tank 0 Strat =============================
kturn360R_istrat
;360R turn move
	s_start_strat
	s_set_alptrs	x,.strat,hit_istrat,explode_istrat
	s_set_aldata	x,#50,#2	; hp,ap

.strat	s_start_strat

	s_set_alvar	B,x,al_vel,#10
	s_add_alvar	B,x,al_roty,#2
	s_gen_vecs	x,al_roty,al_vel
	s_add_vecs2pos	x

.end	s_end_strat

;========================== Zaco 2 Strat =============================
kzaco2_istrat
	s_start_strat
	s_set_alptrs	x,.strat,hit_istrat,explode_istrat
	s_set_aldata	x,#10,#10	; hp,ap

.strat	s_start_strat
	s_fchase_alvar2alvar	B,x,al_roty,x,al_pbyte1,3

;======== enemy moving ========
	s_set_alvar	B,x,al_vel,#5
	s_gen_vecs	x,al_roty,al_vel
	s_add_vecs2pos	x

.end	s_end_strat

.hit
;	s_set_objtobealvar	y,x,al_collobjptr
;	s_copy_alvar2alvar	W,x,al_pbyte1,y,al_roty
	s_jmpto_strat		x

;========================== Zaco 5 Strat =============================
kszaco_5_istrat
	s_start_strat
	s_set_alptrs	x,.strat,hit_istrat,explode_istrat
	s_set_aldata	x,#10,#10	; hp,ap
	s_set_alvar	B,x,al_vel,#15	; velocity

.strat	s_start_strat

	s_set_objtobeplayer1	y

	s_obj2obj_3dangle	x,y,al_roty,al_rotx,2
	s_gen_3Dvecs		x,al_roty,al_rotx,al_vel
	s_add_vecs2pos		x

.end	s_end_strat

.hit
;	s_set_objtobealvar	y,x,al_collobjptr
;	s_copy_alvar2alvar	W,x,al_pbyte1,y,al_roty
	s_jmpto_strat		x


;*********************************************************************
;*								*
;*			Item Strats				*
;*								*
;*********************************************************************

;*********************************************************************
;*								*
;*			Interrupt Strats			*
;*								*
;*********************************************************************
;============================== KBOX 1 ===============================
kbox1_istrat
	s_start_strat
;	s_set_alptrs	x,.strat,.hit,explode_istrat
	s_set_aldata	x,#100,#0	; hp,ap

.strat	s_start_strat
	s_set_alvar	B,x,al_hp,#100

	s_fchase_alvar	B,x,al_vel,#kvel0,10,.end
	s_gen_vecs	x,al_roty,al_vel
	s_add_vecs2pos	x
.end	s_end_strat
;--------------------------------------------------------------------
.hit	s_start_strat

;	s_set_objtobealvar	y,x,al_collobjptr
	s_jmp_objplayer1	y,.hitplayer1
	s_jmp_objplayer2	y,.hitplayer2

.hitplayer1
.hitplayer2
	s_set_alvar		B,x,al_vel,#$30
;	s_copy_alvar2alvar	B,x,al_vel,y,al_vel
	s_copy_alvar2alvar	B,x,al_roty,y,al_roty
	s_jmpto_strat		x

;============================== KBOX 2 ===============================
kbox2_istrat
	s_start_strat
;	s_set_alptrs	x,.strat,.hit,explode_istrat
	s_set_aldata	x,#100,#0	; hp,ap

.strat	s_start_strat
	s_set_alvar	B,x,al_hp,#100

	s_fchase_alvar	W,x,al_worldy,#-40,5
	s_fchase_alvar	B,x,al_rotx,#kvel0,8
	s_fchase_alvar	B,x,al_vel,#kvel0,1

	s_gen_3Dvecs	x,al_roty,al_rotx,al_vel
	s_add_vecs2pos	x
.end	s_end_strat
;--------------------------------------------------------------------
.hit	s_start_strat

;	s_set_objtobealvar	y,x,al_collobjptr
	s_jmp_objplayer1	y,.hitplayer1
	s_jmp_objplayer2	y,.hitplayer2

.hitplayer1
.hitplayer2
	s_set_alvar		B,x,al_vel,#50
	s_set_alvar		B,x,al_rotx,#-40
	s_copy_alvar2alvar	W,x,al_roty,y,al_roty
	s_jmpto_strat		x
;--------------------------------------------------------------------
;============================== KBOX 3 ===============================
kbox3_istrat
	s_start_strat
;	s_set_alptrs	x,.strat,.hit,explode_istrat
	s_set_aldata	x,#100,#0	; hp,ap

.strat	s_start_strat
	s_set_alvar	B,x,al_hp,#100

	s_gen_vecs	x,al_roty,al_vel
	s_add_vecs2pos	x
.end	s_end_strat
;--------------------------------------------------------------------
.hit	s_start_strat

;	s_set_objtobealvar	y,x,al_collobjptr
	s_jmp_objplayer1	y,.hitplayer1
	s_jmp_objplayer2	y,.hitplayer2

.hitplayer1
.hitplayer2
	s_copy_alvar2alvar	B,x,al_vel,y,al_vel
	s_copy_alvar2alvar	W,x,al_roty,y,al_roty
	s_jmpto_strat		x


	ENDC
