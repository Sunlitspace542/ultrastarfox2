;-------------------------------------------------------------------;
;                                                                   ;
;                    STARFOX II - THE SEQUEL                        ;
;                                                                   ;
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -;
;                                                                   ;
; FILE:         DSTRATS.ASM                                         ;
; AUTHOR:       Dylan Cuthbert                                      ;
; DESCRIPTION:  General Strategy code                               ;
; DATE CREATED: 16-2-93                                             ;
;                                                                   ;
;-------------------------------------------------------------------;

	INCPUB	dstrats

	strats_start


	IFEQ	1


;----------------------------------------------------------
null_istrat
	s_start_strat
	s_set_aldata	x,#10,#10
	s_end_strat

;----------------------------------------------------------
cube_istrat
	s_start_strat
;	s_set_alsflag	x,pickupable
	s_set_aldata	x,#10,#10
	jsl	generaldynamics_l
	s_cmp_alvar	W,x,al_worldy,#0
	s_beq		.shadowoff
	s_set_alsflag	x,shadow
	bra		.shadowon
.shadowoff
	s_clr_alsflag	x,shadow
.shadowon
	s_end_strat





;----------------------------------------------------------

seesaw2_istrat
	s_start_strat
	s_init_anim	x,#10
	s_set_alsflag	x,sflag1
	bra		seesaw_strat
seesaw_istrat
	s_start_strat
	s_init_anim	x,#0
seesaw_strat
	s_set_alsflag	x,shadow
	s_set_alsflag	x,colldisable
	s_set_alvar	B,x,al_sbyte1,#25
	s_set_aldata	x,#10,#10
	s_set_strat	x,.strat
.strat
	s_start_strat
	s_jmp_alsflag	x,sflag1,.addanim
	s_cmp_anim	x,#0
	s_beq		.notsflag
	s_add_anim	x,#-2,#11
	s_end_strat

.addanim	s_cmp_anim	x,#10
	s_beq		.notsflag
	s_add_anim	x,#2,#11
.end
	s_end_strat
.notsflag	s_decbne_alvar	B,x,al_sbyte1,.end
	s_set_alvar	B,x,al_sbyte1,#10
	s_not_alsflag	x,sflag1
	s_end_strat


;----------------------------------------------------------

hill_istrat
	s_start_strat
	s_set_aldata	x,#10,#10
	s_init_anim	x,#0
	s_set_alsflag	x,colldisable
	s_set_alvar	B,x,al_sbyte1,#100
	s_set_alsflag	x,shadow
	s_set_strat	x,.strat
.strat
	s_start_strat

	s_jmp_alsflag	x,sflag1,.addanim
	s_cmp_anim	x,#0
	s_beq		.notsflag
	s_add_anim	x,#-1,#10
	s_end_strat

.addanim	s_cmp_anim	x,#8
	s_beq		.notsflag
	s_add_anim	x,#2,#10
.end
	s_end_strat
.notsflag	s_decbne_alvar	B,x,al_sbyte1,.end
	s_set_alvar	B,x,al_sbyte1,#100
	s_not_alsflag	x,sflag1
	s_end_strat


;----------------------------------------------------------

raft_istrat
	s_start_strat
	s_set_aldata	x,#10,#10
	s_init_anim	x,#0
	s_set_alsflag	x,colldisable
	s_set_alvar	B,x,al_sbyte1,#100
	s_set_alsflag	x,shadow
	s_set_strat	x,.strat
.strat
	s_start_strat
	s_mode_table
	s_mode_entry	.left
	s_mode_entry	.forward
	s_mode_entry	.right
	s_mode_entry	.backward
	s_mode_entry	.up
	s_mode_entry	.down
	s_mode_entry	.again
	s_mode_table_end

;*********
.again	s_mode_change	x,#0
	jmp		.strat

;*********
.nxtmode	s_set_alvar	B,x,al_sbyte1,#100
	s_mode_change	x,+1
	jmp		.move
;*********
.cntdwn	s_beqdec_alvar	B,x,al_sbyte1,.nxtmode
	jmp		.move
;*********
.left
	s_set_alvar	W,x,al_vx,#-20
	s_set_alvar	W,x,al_vy,#0
	s_set_alvar	W,x,al_vz,#0
	jmp		.cntdwn

;*********
.right
	s_set_alvar	W,x,al_vx,#20
	s_set_alvar	W,x,al_vy,#0
	s_set_alvar	W,x,al_vz,#0
	jmp		.cntdwn

;*********
.forward
	s_set_alvar	W,x,al_vx,#0
	s_set_alvar	W,x,al_vy,#0
	s_set_alvar	W,x,al_vz,#20
	jmp		.cntdwn

;*********
.backward
	s_set_alvar	W,x,al_vx,#0
	s_set_alvar	W,x,al_vy,#0
	s_set_alvar	W,x,al_vz,#-20
	jmp		.cntdwn

;*********
.up
	s_set_alvar	W,x,al_vx,#0
	s_set_alvar	W,x,al_vy,#-2
	s_set_alvar	W,x,al_vz,#0
	jmp		.cntdwn

;*********
.down
	s_set_alvar	W,x,al_vx,#0
	s_set_alvar	W,x,al_vy,#2
	s_set_alvar	W,x,al_vz,#0
	jmp		.cntdwn

.move
	s_add_vecs2pos	x
.end
	s_end_strat


;----------------------------------------------------------

springboard_istrat
	s_start_strat
	s_set_aldata	x,#10,#10
	s_init_anim	x,#0
	s_set_alsflag	x,colldisable
	s_set_alvar	B,x,al_sbyte1,#100
	s_set_alsflag	x,shadow
	s_set_strat	x,.strat
.strat
	s_start_strat
	s_jmp_alsflag	x,sflag1,.addanim
	s_cmp_anim	x,#0
	s_beq		.notsflag
	s_add_anim	x,#-1,#15
	s_end_strat

.addanim	s_cmp_anim	x,#14
	s_beq		.notsflag
	s_add_anim	x,#1,#15
.end
	s_end_strat
.notsflag	s_decbne_alvar	B,x,al_sbyte1,.end
	s_set_alvar	B,x,al_sbyte1,#100
	s_not_alsflag	x,sflag1
	s_end_strat



;----------------------------------------------------------

swimmingpool_istrat
	s_start_strat
	s_set_aldata	x,#10,#10
	s_init_anim	x,#0
	s_set_alsflag	x,colldisable
	s_set_strat	x,.strat
.strat
	s_start_strat

	s_end_strat


;----------------------------------------------------------

	ENDC


	strats_end

