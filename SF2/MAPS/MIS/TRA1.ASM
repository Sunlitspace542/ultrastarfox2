	IFEQ	1
;ษออออออออออออออออออออออออออออออออออออออออออป
;บ  training_ground_map                     บ
;ศออออออออออออออออออออออออออออออออออออออออออผ
	setfadedown	quick
	mapwaitfade
	setbg	training
	initbg

;	m_range	8192
	m_scale	1

	mapcode_jsl	initblack_l
	setvar		stayblack,10

	setfadeup	quick
	setvar		kenemynumber,3

;-----------------------------------------
;**** MAP SET START ****
;-------------------------------
;dots_set
	map_setdust
;players_position

	map_mapareaout	off

	map_playermode		ground
	map_setplayerpos	1,0,-150,-4800,0
	map_battlearea		-400,0,0,ground
	map_camerainit_1screen	-150,100,16,-16,64H
	map_arwinginit		-500,-12,15,-15




;-------------------------------------------------------------
;**** MAP SET AREA ****
;-------------------------------------------------------------
;;;;;;;;;;;;;map_area <NO=0-15>,X,Z,W,L,Lavel,on\off,(inactive);;;;;;;;;;

	map_area 01,-05*1024,001*1024,03*1024,20*1024,tra1_1,off
	map_area 02,-08*1024,018*1024,06*1024,06*1024,tra1_2,on
	map_area 03,002*1024,001*1024,03*1024,20*1024,tra1_3,off
	map_area 04,002*1024,018*1024,06*1024,06*1024,tra1_4,on
	map_area 05,001*1024,-05*1024,20*1024,03*1024,tra1_5,off
	map_area 06,018*1024,-08*1024,06*1024,06*1024,tra1_6,on
	map_area 07,-21*1024,-05*1024,20*1024,03*1024,tra1_7,off
	map_area 08,-24*1024,-08*1024,06*1024,06*1024,tra1_8,on
	map_area 00,-05*1024,-05*1024,10*1024,10*1024,tra1_0,on


	map_endarea
;-----------------------------------
tra1_0	;MAIN
;ike
	m_inertpath	00000,0000,1500,0,ike_1_0,e_ike_0
;;;;;	m_inertpath	00450,0000,1400,0,ike_1_1,e_buil_shadow_off
	m_inertpath	04300,0000,-1700,0,ike_1_0,e_ike_0
;people
;	m_inertpath	00000,-050,1500,0,robo_0,e_nocol_s_off

;saka1
	m_inertpath	-2000,000,-3300,0,saka_0_0,e_buil_shadow_off
	m_inertpath	-2000,-80,-2900,0,saka_0_1,e_building
	m_inertpath	-2000,000,-2500,deg180,saka_0_0,e_buil_shadow_off
;people
;	m_inertpath	-2000,-050,-2900,deg90,robo_0,e_nocol_s_off
;welcome to panel zone
;;	m_inertpath	02200,-120,-3200,deg180,wel_2_1,e_wel_step
;people
;	m_inertpath	02300,-050,-3700,deg180,robo_0,e_nocol_s_off
;kusa
	m_inertpath	01500,00000,-3500,0,kusabig,ksprite
	m_inertpath	01700,00000,-3000,0,kusabig,ksprite
	m_inertpath	02000,00000,-2500,0,kusabig,ksprite
	m_inertpath	02300,00000,-2600,0,kusabig,ksprite
	m_inertpath	03500,00000,-3500,0,kusabig,ksprite
	m_inertpath	01100,00000,-1000,0,kusabig,ksprite
;hodoukyou
	m_inertpath	-4000,-158,01800,0,hasi0_1,e_building
	m_inertpath	-3450,0000,01800,0,hasi0_2,e_buil_shadow_off
	m_inertpath	-4550,0000,01800,0,hasi0_0,e_buil_shadow_off
;people
;	m_inertpath	-4000,-260,01800,deg90,robo_0,e_nocol_s_off

;yoko1_way
	m_inertpath	04402,0000,-3185,0,way_2,e_nocol_s_off
	m_inertpath	04402,0000,-4000,-deg90,way_1,e_nocol_s_off
	m_inertpath	03202,0000,-4000,deg90,way_0,e_nocol_s_off
	m_inertpath	02800,0000,-4000,deg90,way_0,e_nocol_s_off
	m_inertpath	01200,0000,-4000,deg90,way_0,e_nocol_s_off
	m_inertpath	00000,0000,-4000,deg180,way_3,e_nocol_s_off
	m_inertpath	-1200,0000,-4000,deg90,way_0,e_nocol_s_off
	m_inertpath	-2800,0000,-4000,deg90,way_0,e_nocol_s_off
	m_inertpath	-4000,0000,-4000,deg180,way_1,e_nocol_s_off
;yoko2_way
	m_inertpath	-1200,0000,-1800,deg90,way_0,e_nocol_s_off
	m_inertpath	-2800,0000,-1800,deg90,way_0,e_nocol_s_off
;tate2_way
	m_inertpath	00000,0000,-2800,0,way_0,e_nocol_s_off
	m_inertpath	00000,0000,-1800,-deg90,way_3,e_nocol_s_off
	m_inertpath	00000,0000,-0800,0,way_0,e_nocol_s_off
;tate1_way
	m_inertpath	-4000,0000,-2800,0,way_0,e_nocol_s_off
	m_inertpath	-4000,0000,-1800,deg90,way_3,e_nocol_s_off
	m_inertpath	-4000,0000,-0800,0,way_0,e_nocol_s_off
	m_inertpath	-4000,0000,00200,deg90,way_3,e_nocol_s_off
	m_inertpath	-4000,0000,01400,0,way_0,e_nocol_s_off
	m_inertpath	-4000,0000,03000,0,way_0,e_nocol_s_off
;welcome to ring zone
;;	m_inertpath	-3850,0000,04200,-deg90,wel_0_0,e_wel_gate
;people
;	m_inertpath	-4000,-050,03800,deg180,robo_0,e_nocol_s_off
;yoko3_way
	m_inertpath	00600,0000,00375,deg45,way_2,e_nocol_s_off
	m_inertpath	00000,0000,00200,0,way_3,e_nocol_s_off
	m_inertpath	-1200,0000,00200,deg90,way_0,e_nocol_s_off
	m_inertpath	-2800,0000,00200,deg90,way_0,e_nocol_s_off
;naname_way
	m_inertpath	01434,0000,-0460,deg45,way_0,e_nocol_s_off
	m_inertpath	02274,0000,-1300,deg90+deg45,way_3,e_nocol_s_off
	m_inertpath	02934,0000,-1960,deg45,way_0,e_nocol_s_off
	m_inertpath	03734,0000,-2760,deg45,way_0,e_nocol_s_off
	m_inertpath	02940,0000,-0640,-deg45,way_0,e_nocol_s_off
;shooting_way
	m_inertpath	04000,0000,4500,0,way_1,e_nocol_s_off
	m_inertpath	04000,0000,3700,-deg90,way_1,e_nocol_s_off
	m_inertpath	03200,0000,3700,deg180,way_1,e_nocol_s_off
	m_inertpath	03200,0000,4500,deg90,way_1,e_nocol_s_off
	m_inertpath	03600,0000,2770,0,way_0,e_nocol_s_off
	m_inertpath	03600,0000,1190,0,way_0,e_nocol_s_off
	m_inertpath	03778,0000,0200,-deg45,way_2,e_nocol_s_off
;welcome to shooting zone
;;	m_inertpath	03600,-260,04000,0,wel_1_0,e_wel_fan
;people
;	m_inertpath	03700,-050,03900,deg180,robo_0,e_nocol_s_off
;yama_tunnel
	m_inertpath	03060,0000,01800,-deg90,yama_0_1,e_buil_shadow_off
	m_inertpath	03600,-310,01800,0,yama_0_0,e_building
	m_inertpath	04140,0000,01800,deg90,yama_0_1,e_buil_shadow_off
;people
;	m_inertpath	03600,-050,01800,0,robo_0,e_nocol_s_off
;house
	m_inertpath	00600,0000,-1500,deg90,house_0,e_buil_shadow_off
	m_inertpath	00600,0000,-3100,deg90,house_1,e_buil_shadow_off
	m_inertpath	-3100,0000,-3400,deg180,house_0,e_buil_shadow_off
	m_inertpath	-0600,0000,-2700,-deg90,house_1,e_buil_shadow_off
	m_inertpath	-1600,0000,-0800,0,house_2,e_buil_shadow_off
	m_inertpath	-3400,0000,-0900,deg90,house_1,e_buil_shadow_off
	m_inertpath	-2000,0000,00800,deg180,house_0,e_buil_shadow_off
	m_inertpath	02000,0000,00000,deg90+deg45,house_1,e_buil_shadow_off
	m_inertpath	-4600,0000,-2500,-deg90,house_1,e_buil_shadow_off
	m_inertpath	-4600,0000,-0800,-deg90,house_0,e_buil_shadow_off
;people
;	m_inertpath	02150,-050,-0300,0,robo_0,e_nocol_s_off
;	m_inertpath	-1000,-020,-0900,deg180,robo_0,e_nocol_s_off
;yashi
	m_inertpath	-0400,0000,-3550,0,yashi_0,e_buil_shadow_off
	m_inertpath	-1400,0000,-3200,0,yashi_0,e_buil_shadow_off
	m_inertpath	-1200,0000,-2300,0,yashi_0,e_buil_shadow_off
	m_inertpath	-2700,0000,-2500,0,yashi_0,e_buil_shadow_off
	m_inertpath	-3400,0000,-2200,0,yashi_0,e_buil_shadow_off
	m_inertpath	-1000,0000,00700,0,yashi_0,e_buil_shadow_off
	m_inertpath	00700,0000,-0300,0,yashi_0,e_buil_shadow_off
	m_inertpath	00900,0000,00600,0,yashi_0,e_buil_shadow_off

	m_inertpath	-2000,0000,02000,0,yashi_0,e_buil_shadow_off
	m_inertpath	-3000,0000,03000,0,yashi_0,e_buil_shadow_off
	m_inertpath	-2500,0000,04000,0,yashi_0,e_buil_shadow_off
	m_inertpath	02500,0000,03500,0,yashi_0,e_buil_shadow_off
	m_inertpath	01000,0000,04800,0,yashi_0,e_buil_shadow_off
;rock
	m_inertpath	-1000,0000,04500,-deg11,m_iwa_6,e_for_m_iwa
	m_inertpath	01500,0000,03800,deg90,m_iwa_1,e_for_m_iwa
;people
;	m_inertpath	-0600,-050,04800,deg45,robo_0,e_nocol_s_off
;	m_inertpath	04250,-050,-3800,deg45,robo_0,e_nocol_s_off
;	m_inertpath	-4000,-050,-4000,-deg90,robo_0,e_nocol_s_off

	map_endarea
;-----------------------------------------
;-----------------------------------------
tra1_1	;RING CORSE
;yashi_line
tra1yashi1	=		6*1024
	rept		20
	m_inertpath	-05*1024,0,tra1yashi1,0,yashi_0,e_buil_shadow_off
	m_inertpath	-2*1024,0,tra1yashi1,deg180,yashi_0,e_buil_shadow_off
tra1yashi1	=	tra1yashi1+512
	endr

;-----------------
;	m_inertpath	-4*1024,-0200,06*1024,0,training,ktest
;	m_inertpath	-4*1024+256,-0250,07*1024,0,training,ktest
;	m_inertpath	-4*1024+512,-0300,08*1024,0,training,ktest
;	m_inertpath	-4*1024+384,-0250,09*1024,0,training,ktest
;	m_inertpath	-4*1024+256,-0180,10*1024,0,training,ktest
;	m_inertpath	-4*1024+400,-0200,11*1024,0,training,ktest
;	m_inertpath	-4*1024+512,-0250,12*1024,0,training,ktest
;	m_inertpath	-4*1024+768,-0400,13*1024,0,training,ktest
;	m_inertpath	-4*1024+512,-0450,14*1024,0,training,ktest
;	m_inertpath	-4*1024+768,-0350,15*1024,0,training,ktest
;	m_inertpath	-3*1024-256,-0200,16*1024,0,training,ktest

	map_endarea
;-----------------------------------------
;-----------------------------------------
tra1_2
;-----------------
	map_endarea
;-----------------------------------------
;-----------------------------------------
tra1_3
;yashi_line
tra1yashi3	=		6*1024
	rept		20
	m_inertpath	02*1024,0,tra1yashi3,0,yashi_0,e_buil_shadow_off
	m_inertpath	05*1024,0,tra1yashi3,deg180,yashi_0,e_buil_shadow_off
tra1yashi3	=	tra1yashi3+512
	endr

;-----------------
;	m_inertpath	4*1024,00,06*1024,0,kakashi,e_kakashi_0
;	m_inertpath	4*1024-256,0,07*1024,0,kakashi,e_kakashi_0
;	m_inertpath	4*1024-512,0,08*1024,0,kakashi,e_kakashi_0
;	m_inertpath	4*1024-384,0,09*1024,0,kakashi,e_kakashi_0
;	m_inertpath	4*1024-256,0,10*1024,0,kakashi,e_kakashi_0
;	m_inertpath	4*1024-400,0,11*1024,0,kakashi,e_kakashi_0
;	m_inertpath	4*1024-512,0,12*1024,0,kakashi,e_kakashi_0
;	m_inertpath	4*1024-768,0,13*1024,0,kakashi,e_kakashi_0
;	m_inertpath	4*1024-512,0,14*1024,0,kakashi,e_kakashi_0
;	m_inertpath	4*1024-768,0,15*1024,0,kakashi,e_kakashi_0
;	m_inertpath	3*1024+256,0,16*1024,0,kakashi,e_kakashi_0
	map_endarea
;-----------------------------------------
;-----------------------------------------
tra1_4
;-----------------
	map_endarea
;-----------------------------------------
;-----------------------------------------
tra1_5
;-----------------
	map_endarea
;-----------------------------------------
;-----------------------------------------
tra1_6
;-----------------
	map_endarea
;-----------------------------------------
;-----------------------------------------
tra1_7
;-----------------
	map_endarea
;-----------------------------------------
;-----------------------------------------
tra1_8
;-----------------
	map_endarea
;-----------------------------------------
;-----------------------------------------
;**** MAP SET END ****
;-----------------------------------------
.lp	mapwait	5000
	mapgoto	.lp


;++++++++++++++++++++++++++++++
;++++++++++++++++++++++++++++++
;++++++++++++++++++++++++++++++
;++++++++++++++++++++++++++++++
;++++++++++++++++++++++++++++++


	ENDC
