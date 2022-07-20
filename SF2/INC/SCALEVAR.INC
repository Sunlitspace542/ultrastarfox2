;***************************************************************************
;*                                                                         *
;*                              StarGlider                                 *
;*                              -----------                                *
;*                                                                         *
;*                           SuperNES version.                             *
;*                                                                         *
;*                                                                         *
;*                           Argonaut Software.        		      *	   
;*                                                                         *
;*_________________________________________________________________________*
;*                                                                         *
;*   File: SCALEVAR.INC                                                     *
;*                                                                         *
;*                                                                         *
;*_________________________________________________________________________*
;*                                                                         *
;*  Descr: SCALING AND GENERAL SHAPE/STRATEGY EQUATES                            *
;*                                                                         *
;*                                                                         *
;*_________________________________________________________________________*
;*                                                                         *
;*   Date: 11/3/94                                                         *
;*                                                                         *
;*                                                                         *
;*_________________________________________________________________________*
;*                                                                         *
;* Author:								      *
;*          Anybody !                                                              *
;*                                                                         *
;***************************************************************************

; Dylan's scale equates

tako_scale	=	2
andorf_scale	=	3
runner_scale	=	2

b_tank_scale	=	2

theend_scale	=	3

hako_0_scale	=	3
spin_scale	=	4

boss00_scale	=	2
kichi0_scale	=	6
kichi0_door	=	-10<<kichi0_scale
slot_scale	=	2

dodora_scale	=	1

arrowbox_scale	=	1

kichi2_scale	=	3
kichi2_len	=	49<<kichi2_scale

flingbosswidth	=	40
armlength	=	80
sprout_maxy	=	80

; mapmacs
tsize	=	200
dirEAST	=	deg270
dirNORTH	=	deg0
dirWEST	=	deg90
dirSOUTH	=	deg180


; shapes
stunnwidth	=	80
stunnheight	=	100
iris_h	=	60
iris_w	=	90
iris_boxz	=	50


saka0_scale	=	2
saka1_scale	=	2
saka3_scale	=	2
saka4_scale	=	2
saka5_scale	=	2
saka6_scale	=	2
saka7_scale	=	2
saka8_scale	=	2
oka0_scale	=	2
box4_scale	=	1



kame0_scale	=	2


;	
;	
; ษอออออออออออออออออออออออออออออออออออออออป
; บ                                       บ
; บ                                       บ
; บ 	EGUCHI'S BLOCK               บ
; บ                                       บ
; บ                                       บ
; ศอออออออออออออออออออออออออออออออออออออออผ
toriaezu	=	0
toriaezu1	=	0
demo_cut_ground	=	1
e_boss_demo_cut	=	1
frobo_demo_cut	=	1
slide_demo_cut	=	0
hit_fuse_demo_cut	=	1
antenna_demo_cut	=	1
robo_quick		=	0
keep_ori_demo_cut	=	1
keep_worm_demo_cut	=	1
keep_body_demo_cut	=	1
keep_track_demo_cut	=	1
keep_bird_demo_cut	=	1

;MSG NO SENTOU NUMBER
fuse_stop_msg	=	127
;DEMO NO CAMERA NO SYURUI
;;;de_for_sonota	=	-1
;;;de_for_men		=	1
;;;de_for_kaiten	=	2
;;;de_for_slide		=	3
;;;de_for_kusha		=	4
;;;de_for_ori		=	5
;;;de_for_kani		=	6
;;;de_for_eisei		=	7
;;;de_for_robot		=	8
;;;de_for_hitfuse	=	9
;;;de_for_cupfuse	=	10
;;;de_for_mikako	=	11
;;;de_for_fumu		=	12
;;;de_for_base		=	13
;;;de_for_kurage	=	14
;;;de_for_sos_strong	=	15
de_for_map_fuse	=	16
;;;de_for_tekikan	=	17
;;;de_for_teki_3	=	18
;;;de_for_teki_2	=	19
;;;de_for_hydra		=	20
;;;de_for_stepsen	=	21
;;;de_for_stepsen2	=	22
de_for_sw_base_sw	=	23
de_for_base_base	=	24
de_for_sw_base_sli	=	25
de_for_sw_base_sw_takadai	=	26
de_for_sw_base_sw_far	=	27
de_for_neta			=	28
de_for_sw_base_sw_sea	=	29
de_for_neta_final_door	=	30
de_for_door_kotei_pos	=	31
de_for_door_kotei_pos_s	=	32
;STAGE 1 NO SETTING NUMBER

stg1_pnl_max		=	6
stg2_robo_max	=	5
stg3_ante_max	=	9

stg1_miss_msg	=	1
stg2_miss_msg	=	2
stg3_miss_msg	=	3
stg4_miss_msg	=	4
stg5_miss_msg	=	5
stg6_miss_msg	=	6
ext1_miss_msg	=	7
ext2_miss_msg	=	8
ext3_miss_msg	=	9
ext4_miss_msg	=	10


;
;kani_no_idou_hani

kani_max_x	=	1250
kani_min_x	=	-1250
kani_max_z	=	1250
kani_min_z	=	-1250

;
;;e_pn_3of8 : 8 places x,y,z
;pn_1of8_x		=	500			;2000
;pn_1of8_y		=	0
;pn_1of8_z		=	0			;4500
;
;pn_2of8_x		=	500			;2000
;pn_2of8_y		=	0
;pn_2of8_z		=	-500			;1000
;
;pn_3of8_x		=	0			;-500
;pn_3of8_y		=	0
;pn_3of8_z		=	-500			;2000
;
;pn_4of8_x		=	-500			;-4900
;pn_4of8_y		=	0
;pn_4of8_z		=	-500			;2000
;
;pn_5of8_x		=	-500			;04900
;pn_5of8_y		=	0
;pn_5of8_z		=	0			;-2000
;
;pn_6of8_x		=	-500			;500
;pn_6of8_y		=	0
;pn_6of8_z		=	500			;-2000
;
;pn_7of8_x		=	0			;-2000
;pn_7of8_y		=	0
;pn_7of8_z		=	500			;-1000
;
;pn_8of8_x		=	500			;-2000
;pn_8of8_y		=	0
;pn_8of8_z		=	500			;-4500
;
;
;;e_ri_3of8 : 8 places x,y,z
;
;ri_1of8_x		=	3500
;ri_1of8_y		=	-200
;ri_1of8_z		=	2000
;
;ri_2of8_x		=	0500
;ri_2of8_y		=	-300
;ri_2of8_z		=	2000
;
;ri_3of8_x		=	-2000
;ri_3of8_y		=	-250
;ri_3of8_z		=	2000
;
;ri_4of8_x		=	2000
;ri_4of8_y		=	-250
;ri_4of8_z		=	-2000
;
;ri_5of8_x		=	-0500
;ri_5of8_y		=	-300
;ri_5of8_z		=	-2000
;
;ri_6of8_x		=	-3500
;ri_6of8_y		=	-200
;ri_6of8_z		=	-2000
;
;ri_7of8_x		=	1500
;ri_7of8_y		=	-300
;ri_7of8_z		=	0
;
;ri_8of8_x		=	-1500
;ri_8of8_y		=	-300
;ri_8of8_z		=	0
;
;
;;e_ka_3of8 : 8 places x,y,z
;
;ka_1of8_x		=	500
;ka_1of8_y		=	00
;ka_1of8_z		=	00
;
;ka_2of8_x		=	500
;ka_2of8_y		=	00
;ka_2of8_z		=	-500
;
;ka_3of8_x		=	00
;ka_3of8_y		=	00
;ka_3of8_z		=	-500
;
;ka_4of8_x		=	-500
;ka_4of8_y		=	00
;ka_4of8_z		=	-500
;
;ka_5of8_x		=	-500
;ka_5of8_y		=	00
;ka_5of8_z		=	00
;
;ka_6of8_x		=	-500
;ka_6of8_y		=	00
;ka_6of8_z		=	500
;
;ka_7of8_x		=	00
;ka_7of8_y		=	00
;ka_7of8_z		=	500
;
;ka_8of8_x		=	500
;ka_8of8_y		=	00
;ka_8of8_z		=	500
;
;;----------5 of 16 
;;kakashi
;prk_1of16_kx		=	-1000
;prk_1of16_ky		=	0
;prk_1of16_kz		=	500
;
;prk_2of16_kx		=	-800
;prk_2of16_ky		=	0
;prk_2of16_kz		=	500
;
;prk_3of16_kx		=	-600
;prk_3of16_ky		=	0
;prk_3of16_kz		=	500
;
;prk_4of16_kx		=	-400
;prk_4of16_ky		=	0
;prk_4of16_kz		=	500
;
;prk_5of16_kx		=	-200
;prk_5of16_ky		=	0
;prk_5of16_kz		=	500
;
;prk_6of16_kx		=	00
;prk_6of16_ky		=	0
;prk_6of16_kz		=	500
;
;prk_7of16_kx		=	200
;prk_7of16_ky		=	0
;prk_7of16_kz		=	500
;
;prk_8of16_kx		=	400
;prk_8of16_ky		=	0
;prk_8of16_kz		=	500
;
;prk_9of16_kx		=	-1000
;prk_9of16_ky		=	-200
;prk_9of16_kz		=	500
;
;prk_10of16_kx	=	-800
;prk_10of16_ky	=	-200
;prk_10of16_kz	=	500
;
;prk_11of16_kx	=	-600
;prk_11of16_ky	=	-200
;prk_11of16_kz	=	500
;
;prk_12of16_kx	=	-400
;prk_12of16_ky	=	-200
;prk_12of16_kz	=	500
;
;prk_13of16_kx	=	-200
;prk_13of16_ky	=	-200
;prk_13of16_kz	=	500
;
;prk_14of16_kx	=	00
;prk_14of16_ky	=	-200
;prk_14of16_kz	=	500
;
;prk_15of16_kx	=	200
;prk_15of16_ky	=	-200
;prk_15of16_kz	=	500
;
;prk_16of16_kx	=	400
;prk_16of16_ky	=	-200
;prk_16of16_kz	=	500
;
;;paneru
;prk_1of16_px		=	-1000
;prk_1of16_py		=	0
;prk_1of16_pz		=	500
;
;prk_2of16_px		=	-800
;prk_2of16_py		=	0
;prk_2of16_pz		=	500
;
;prk_3of16_px		=	-600
;prk_3of16_py		=	0
;prk_3of16_pz		=	500
;
;prk_4of16_px		=	-400
;prk_4of16_py		=	0
;prk_4of16_pz		=	500
;
;prk_5of16_px		=	-200
;prk_5of16_py		=	0
;prk_5of16_pz		=	500
;
;prk_6of16_px		=	00
;prk_6of16_py		=	0
;prk_6of16_pz		=	500
;
;prk_7of16_px		=	200
;prk_7of16_py		=	0
;prk_7of16_pz		=	500
;
;prk_8of16_px		=	400
;prk_8of16_py		=	0
;prk_8of16_pz		=	500
;
;prk_9of16_px		=	-1000
;prk_9of16_py		=	-200
;prk_9of16_pz		=	500
;
;prk_10of16_px	=	-800
;prk_10of16_py	=	-200
;prk_10of16_pz	=	500
;
;prk_11of16_px	=	-600
;prk_11of16_py	=	-200
;prk_11of16_pz	=	500
;
;prk_12of16_px	=	-400
;prk_12of16_py	=	-200
;prk_12of16_pz	=	500
;
;prk_13of16_px	=	-200
;prk_13of16_py	=	-200
;prk_13of16_pz	=	500
;
;prk_14of16_px	=	00
;prk_14of16_py	=	-200
;prk_14of16_pz	=	500
;
;prk_15of16_px	=	200
;prk_15of16_py	=	-200
;prk_15of16_pz	=	500
;
;prk_16of16_px	=	400
;prk_16of16_py	=	-200
;prk_16of16_pz	=	500
;
;;ring
;prk_1of16_rx		=	-1000
;prk_1of16_ry		=	0
;prk_1of16_rz		=	500
;
;prk_2of16_rx		=	-800
;prk_2of16_ry		=	0
;prk_2of16_rz		=	500
;
;prk_3of16_rx		=	-600
;prk_3of16_ry		=	0
;prk_3of16_rz		=	500
;
;prk_4of16_rx		=	-400
;prk_4of16_ry		=	0
;prk_4of16_rz		=	500
;
;prk_5of16_rx		=	-200
;prk_5of16_ry		=	0
;prk_5of16_rz		=	500
;
;prk_6of16_rx		=	00
;prk_6of16_ry		=	0
;prk_6of16_rz		=	500
;
;prk_7of16_rx		=	200
;prk_7of16_ry		=	0
;prk_7of16_rz		=	500
;
;prk_8of16_rx		=	400
;prk_8of16_ry		=	0
;prk_8of16_rz		=	500
;
;prk_9of16_rx		=	-1000
;prk_9of16_ry		=	-200
;prk_9of16_rz		=	500
;
;prk_10of16_rx	=	-800
;prk_10of16_ry	=	-200
;prk_10of16_rz	=	500
;
;prk_11of16_rx	=	-600
;prk_11of16_ry	=	-200
;prk_11of16_rz	=	500
;
;prk_12of16_rx	=	-400
;prk_12of16_ry	=	-200
;prk_12of16_rz	=	500
;
;prk_13of16_rx	=	-200
;prk_13of16_ry	=	-200
;prk_13of16_rz	=	500
;
;prk_14of16_rx	=	00
;prk_14of16_ry	=	-200
;prk_14of16_rz	=	500
;
;prk_15of16_rx	=	200
;prk_15of16_ry	=	-200
;prk_15of16_rz	=	500
;
;prk_16of16_rx	=	400
;prk_16of16_ry	=	-200
;prk_16of16_rz	=	500
;

;SAGYOU ROBO NO TARGET POINT
pos_colony_x		=	1000
pos_colony_y		=	-300
pos_colony_z		=	-2500

;RADAR'S SPRITE NUMBER
;ra_off		=	0
;ra_honmei		=	43
;ra_sonota		=	44
;ra_player		=	45
;ra_enemy		=	46

;SHAPE SCALE
yoyo_scale		=	3
wolf_eg_scale	=	3
medal_scale		=	1
kaku6_scale		=	3
kaku5_scale		=	3
virus_scale		=	2
system_scale		=	4
cup_scale		=	2
karakasa_scale	=	2
bakugeki_scale	=	4
bou_scale		=	5
kaku_4_scale		=	3
ashi4_scale		=	1
tate_m_scale		=	4
jyouge_1_scale	=	5		;test 4
jyouge_scale		=	4		;test 3
mizukara_scale	=	2
ninja_scale		=	5
hakodai_scale	=	3
chi_hou_scale	=	3
boyon_scale		=	1
yuka_hou_scale	=	2
r_tank_scale		=	2
ha_hou_scale		=	2
room_hou_scale	=	1
to_hou_scale		=	3
tousenbo_scale	=	2
kakureto_scale	=	3
da_ha_yo_scale	=	3
da_ha_ta_scale	=	3
da_yuka_scale	=	3
s_kaku_scale		=	3
suisya_scale		=	3
kaku_scale		=	3
planet_base_scale	=	3
long_b_scale		=	0
enban_scale		=	4
font_p_scale		=	1
big_l_scale		=	3
shizumu_scale	=	1
teki_3_scale		=	4
taigun_scale		=	4	;test	3
speed_scale		=	3	;test	2
enkin_scale		=	3	;test	2
teki_2_scale		=	4
miss2_scale		=	2
toge_0_scale		=	0
r_an_scale		=	1
r_anbig_scale		=	3
batabata_scale	=	1
kotank_scale		=	0
koori_scale		=	3
guard_scale		=	0
stepup_scale		=	3
stepups_scale	=	0
kozakana_scale	=	1
iwashi_l_scale	=	2
iwashi_m_scale	=	1
kakomi_scale		=	5
hyouzan_scale	=	3
kururin0_scale	=	3		;test	2
kururin1_scale	=	4		;test	3
kieru_scale		=	3		;test	2
t_kichi_scale	=	3
f_car_scale		=	3
f_fune_scale		=	3
senkan_0_scale	=	4
senkan_0s_scale	=	0
dandou_scale		=	2
dandou_half_scale		=	1
miss_dai_scale	=	3
takadai_scale	=	1
fuse_dai_scale	=	2
on_d_scale		=	1
off_d_scale		=	1
pools_0_scale	=	3
machi_0_scale	=	4
machi_0_1_scale	=	1
machi_0_2_scale	=	2
machi_0_3_scale	=	3
lift_0_0_scale	=	1
nobiru_scale		=	2
torii_0_scale	=	1
yoi_hou_scale	=	2
crystal_scale	=	2
itembox0_scale	=	1
tekuteku_s_scale	=	0
tekuteku_scale	=	1
suisui_scale		=	1
amenbo_scale		=	1
sos_0_scale		=	4	;test	3
sos_1_scale		=	5	;test	3
kurage_scale		=	3
sagyou_r_scale	=	1
hae_0_scale		=	1
hiyasu_0_scale	=	3
f_robo_scale		=	3
ataru2_scale		=	2
slide_0_scale	=	3
slide_1_scale	=	3
c_cup_scale		=	2
ataru_scale		=	2
men_0_scale		=	2
men_1_scale		=	2
tomato_0_scale	=	2
tomato_1_scale	=	0
tomato_2_scale	=	0
hana_hou_scale	=	2	;0
sasori_0_scale	=	2	;1
saku_0_scale		=	5
saku_1_scale		=	5
saku_m_scale		=	5
hey_scale		=	4
;pole_0_scale		=	4
;pole_1_scale		=	4
;pole_2_scale		=	4
;pole_3_scale		=	4
;pole_5_scale		=	4
yuka_0_scale		=	5
yuka_1_scale		=	5
yuka_2_scale		=	5
lock_man_scale	=	1
m_box_scale		=	0
tsu_hou_scale	=	3
yamori_scale		=	0
fuse_scale		=	2
t_hako_0_scale	=	3
t_hako_lift_scale	=	2
t_saka_0_scale	=	3
t_saka_1_scale	=	3
t_to_0_scale		=	3
t_to_1_scale		=	3
t_to_2_scale		=	3

extra1_scale		=	4
extra1s_scale	=	3
zaco_0s_scale	=	1
ship_0s_scale	=	1

extra_2_scale	=	4
tekikansss_scale	=	0
tekikanss_scale	=	2
tekikans_scale	=	3
tekikan_scale	=	4
ryuhyou_scale	=	3
colo_0_scale		=	4
colo_1_scale		=	4
tsutsu_0_scale	=	3
w_kichi_scale	=	3
ana_0_scale		=	2
kazan_0_scale	=	3
box_0_scale		=	2
souko_0_scale	=	2
souko_1_scale	=	2
souko_2_scale	=	2
ka_0_scale		=	1
mikako_scale		=	3
ike_1_0_scale	=	4
kani_0_scale		=	2	;3
you_0_0_scale	=	2
you_0_1_scale	=	2
yousai_4_scale	=	3
taihou_0_scale	=	2
antenna_scale	=	2
wel_0_scale		=	2
wel_1_0_scale	=	1
wel_1_1_scale	=	2
wel_2_scale		=	2
ike_0_scale		=	4
house_0_scale	=	3
house_1_scale	=	3
house_2_scale	=	4
house_3_scale	=	3
caldera_scale	=	3
michi_0_scale	=	3	;michi_0,michi_1 no scale
michi_1_scale	=	3	;michi_0,michi_1 no scale
michi_2_scale	=	3
michi_3_scale	=	3
michi_4_scale	=	3
michi_5_scale	=	3
michi_6_scale	=	3
michi_7_scale	=	3
yama00_scale		=	3	;aaa0
yama01_scale		=	3	;aaa0
yama02_scale		=	3	;aaa0
yama_1_0_scale	=	3	;aaa0
yama_1_2_scale	=	3	;aaa0
mukade_scale		=	1
p3_ashi_scale	=	2
k_tori_0_scale	=	1
kao_man_scale	=	2	;aaa1
noru_dai_scale	=	2	;noru_dai is using
noru_small_scale	=	1	;noru_1 is using
test_dai_scale	=	3	;test_dai is using
kakashi_scale	=	2	;pyonta,_k and _t are using
yajiro_scale		=	1	;yajiro0,1,2 and 3 are using
tetra_scale		=	3	;tetra,0,1,2,3 and c are using
kusha_scale		=	3	;kusha0,1 are using
;kusha_2_scale	=	3	;kusha0,1 are using
pyramid0_scale	=	3	;pyramid0 is using
pyramid1_scale	=	2	;pyramid1 is using
hasi_scale		=	3	;hasi0_0~2 are using
arch_scale		=	2	;arch_0_0~2 are using
arch_1_scale		=	2	;arch_1_0~1 are using
arch_2_scale		=	1
arch_2a_scale		=	2
saka_0_0_scale	=	3	;saka_0_0~2 are using
gate_0_scale		=	2	;gate_0 is using
ita_0_scale		=	2	;ita_0,ita_1 are using
ring_0_scale		=	3	;ring_0 is using
build_scale		=	2	;build_0~8 are using
tou_scale		=	2	;tou_0~1 are using
gun_0_scale		=	2	;gun_0_0~1 are using
yashi_scale		=	3	;aaa2	;yashi_0 is using
lamp_0_scale		=	1
kumo_0_scale		=	1
wanwan_scale		=	1
zaco_0_scale		=	2	;1
sos_2_scale		=	5		;test	3
zaco_1_scale		=	0
zaco_2_scale		=	1
d_robo_scale		=	1
track_scale		=	1
iwa_0_scale		=	3	;aaa2
iwa_0half_scale	=	2	;aaa1
iwa_1_scale		=	1
iwa_2_scale		=	3	;aaa2
iwa_3_scale		=	3	;aaa2
iwa_4_scale		=	2
iwa_4big_scale	=	3
iwa_3half_scale	=	2	;aaa1
d_keep_scale		=	1
damyexp_scale	=	2
totem_2_scale	=	2
downship_scale	=	0
ibara_scale		=	1
flower_scale		=	3	;2
guru2bar_scale	=	3	;2
saru_0_scale		=	2	;1
kinoko_scale		=	1
kinoko_d_scale	=	1
jump_dai_scale	=	1
kogame_scale		=	1
taoreru_end_scale	=	2
taoreru_1_scale	=	2
munyu_scale		=	1
kaifuku_scale	=	1
kabe_0_scale		=	3
kabe_1_scale		=	4
kabe_2_scale		=	4
kabe_3_scale		=	3
kado_0_scale		=	3
kado_1_scale		=	3
kado_2_scale		=	4
kado_3_scale		=	4
kado_4_scale		=	3
kabe_to_scale	=	3
kabe_to1_scale	=	3
kabe_aku_scale	=	3
;kabe_ak1_scale	=	3
noru_3_scale		=	1
m_iwa_0_scale	=	3
m_iwa_1_scale	=	3
m_iwa_2_scale	=	3	;4
m_iwa_5_scale	=	3
m_iwa_6_scale	=	3	;4
m_iwa_7_scale	=	4
eisei_0_scale	=	1
nazca_1_scale	=	3	;aaa0
nazca_0_scale	=	3
hasami_scale		=	1
room_scale		=	2
colony_0_scale		=	0
colony_1_scale		=	0
colony_2_scale		=	0
colony_scale		=	4
colony_scale_t	=	4
pyramid2_scale	=	2	;aaa yamada test
;pyramid3_scale	=	2
osu_0_scale		=	2
sagyou_scale		=	2
rapyuta_scale	=	3


;SCORE
sc_wolf		=	2000
sc_wolf_zaco		=	1000
sc_kirai		=	5
sc_tate_m_c		=	50
sc_base_core		=	1000
sc_kabe_mukade	=	100
sc_yousai		=	200
sc_mogura_ana	=	100
sc_open_key		=	200
sc_hit_dead		=	50
sc_wakidashi		=	50
sc_enban_c		=	50
sc_enban_m		=	200
sc_sos_speed		=	100
sc_enkin		=	100
sc_bara_miss		=	50
sc_bara_miss_main	=	300
sc_stepup_hydra	=	500
sc_shield_robo	=	500
;;;sc_kurage		=	300
sc_bakugekiki	=	300
sc_sos_strong	=	300
sc_sos_weak		=	100
sc_mukade_target	=	150
sc_kani		=	300
sc_item_get		=	100
sc_hp_get		=	1
sc_found_item	=	50

;
;
;	
;      ษออออออออออออออออออออออออออออออออป
;      บ                                บ
;      บ       EGUCHI'S BLOCK END       บ
;      บ                                บ
;      ศออออออออออออออออออออออออออออออออผ
;
;	
; ษอออออออออออออออออออออออออออออออออออออออป
; บ                                       บ
; บ                                       บ
; บ 	KAWAGOE'S BLOCK              บ
; บ                                       บ
; บ                                       บ
; ศอออออออออออออออออออออออออออออออออออออออผ

base_scale	=	2
bases_scale	=	2
and_zoon_scale	=	3
and_box_scale	=	2
warp_scale	=	2
kabe_dem_scale	=	4
inseki_0_scale	=	0
inseki_1_scale	=	0
inseki_2_scale	=	0
inseki_2s_scale	=	4
warpl_scale		=	5
warps_scale		=	3
d_sen_scale		=	5
d_sens_scale		=	5
d_sen_s_scale	=	0
d_sen_2_scale	=	2
d_sen_ss_scale	=	0
last_ka_scale	=	5
last_to_scale	=	3
and_z_1_scale	=	3
and_ba_0_scale	=	3

tame_scale		=	2
tamel_scale		=	3

kujira_scale		=	3	;New!
rock_scale		=	3	;New!

mark_scale		=	3

wolf_scale		=	0

; ษอออออออออออออออออออออออออออออออออออออออป
; บ                                       บ
; บ                                       บ
; บ 	KAWAGOE'S BLOCK END          บ
; บ                                       บ
; บ                                       บ
; ศอออออออออออออออออออออออออออออออออออออออผ
