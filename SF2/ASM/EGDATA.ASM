
	INCPUB	egdata
b_core_cx
	dw	0
	dw	0
b_core_cz
	dw	35<<kaku_scale
	dw	-35<<kaku_scale
cari_core2_cz
	dw	0
	dw	0
cari_core2_cx
	dw	12<<kaku6_scale
	dw	-12<<kaku6_scale
	dw	0
	dw	0
cari_core2_ry
	db	-64
	db	64
	db	0
	db	128
bari_4z
	dw	71<<planet_base_scale
bari_4x
	dw	-71<<planet_base_scale
	dw	-71<<planet_base_scale
	dw	71<<planet_base_scale
	dw	71<<planet_base_scale
bari_4ry
	db	32
	db	96
	db	-96
	db	-32
kasa_op_time
	db	70
	db	55
	db	40
eisei_c_x
	dw	0
	dw	-45<<system_scale
	dw	45<<system_scale
	dw	105<<system_scale
	dw	-105<<system_scale
eisei_c_y
	dw	-80<<system_scale
	dw	-45<<system_scale
	dw	-45<<system_scale
	dw	-45<<system_scale
	dw	-45<<system_scale
eisei_c_z
	dw	0
	dw	105<<system_scale
	dw	-105<<system_scale
	dw	45<<system_scale
	dw	-45<<system_scale
eisei_c_ry
	db	0
	db	0
	db	128
	db	-64
	db	64
eisei_c_s
	dw	system_1
	dw	system_2
	dw	system_2
	dw	system_2
	dw	system_2
hackroot_tab
	db	0,1,-1
jyouge_turntab
	db	4,-4,8,-8,12,-12,16,-16
open_chrtab
	db	-128,-127,-126,-125,-126,-127,-128
fune_fuse_root
	db	2,2,3,3,4,4,5,5,6,6,7,7,0,0,1,1
bara_ang_tab
	db	-1,1,3,-3
open_chx_tab
	dw	-180,-60,60,180
open_chs_tab
	dw	opchr_o
	dw	opchr_p
	dw	opchr_e
	dw	opchr_n
base_smoke_z
	dw	43<<planet_base_scale	
base_smoke_x
	dw	-43<<planet_base_scale	
	dw	-43<<planet_base_scale	
	dw	43<<planet_base_scale	
	dw	43<<planet_base_scale	
d_sen_c_zz
	dw	-25<<d_sen_scale
	dw	120<<d_sens_scale
	dw	033<<d_sens_scale
	dw	-90<<d_sens_scale
	dw	-40<<d_sens_scale
d_sen_c_ss
	dw	d_sen_2
	dw	d_sen_0
	dw	d_sen_1
	dw	d_sen_3
	dw	d_sen_4
e_wolf_hp
	db	21+40
	db	26+40
	db	31+40
	db	36+40
dandou_tab
	db	-50,-40,-32,-24,-18,-12,-4
	db	4,12,18,24,32,40,50

init_angle_tab
	db		0,16,32,48,64,80,96,112,128,144,160,176,192,208,224,240

every_90
	db		0,64,128,-64

toji_muka_medal
	db		44h,45h,46h,47h

baku_yure_tab
	db	0,1,2,3,4,5,6,7,7,8,8,9,9,9,10,10,10,9,9,9,8,8,7,7,6,5,4,3,2,1,0
	db	-1,-2,-3,-4,-5,-6,-7,-7,-8,-8,-9,-9,-9,-10,-10,-10,-9,-9,-9,-8,-8,-7,-7,-6,-5,-4,-3,-2,-1
baku_yurenai_tab
	db	0,0,1,1,1,2,2,2,2,1,1,1,0,0,-1,-1,-1,-2,-2,-2,-2,-1,-1,-1

enemy_ehight
	dw	-3200,3200,-2700,2700,-2200,2200,-1700,1700

root_t_tab1
	db	64,-64
root_t_tab2
	dw	-10,10
root_t_tab3
	dw	0,-1024
pool_j_youi
	db		2<<mizukara_scale
	db		3<<mizukara_scale
	db		1<<mizukara_scale
	db		-1<<mizukara_scale
	db		-5<<mizukara_scale

pool_anim_out
	db	-121,-120,-119,-119,-119,-119,-119,-119,-118,-117
	db	-118,-119,-120,-121,-122,-123,-124,-125,-126,-127
pool_anim_minij
	db	0,0,0,-122,-121,-120,-119,-118,-120,-121
	db	-122,-123,-124,-125,-126,-127,-128
pool_next
	db	1,3		;from 0
	db	0,2		;from 1
	db	1,3		;from 2
	db	0,2		;from 3
pool_roty
	db	0,64		;from 0
	db	128,64		;from 1
	db	-64,128		;from 2
	db	-64,0		;from 3

d_sen_c_z
	dw	(120+25-40)<<d_sen_ss_scale
	dw	(033+25-40)<<d_sen_ss_scale
	dw	(0-40)<<d_sen_ss_scale
	dw	(-90+25-40)<<d_sen_ss_scale
	dw	(-40+25-40)<<d_sen_ss_scale


d_sen_shap
	dw	d_sen_0s,d_sen_1s,d_sen_2s,d_sen_3s,d_sen_4s

bari_moji_x
	dw	-360,-240,-120,0,120,240,360
bari_moji_sh
	dw	opchr_b
	dw	opchr_a
	dw	opchr_r
	dw	opchr_r
	dw	opchr_i
	dw	opchr_e
	dw	opchr_r
unknow_moji_x
	dw	-360,-240,-120,0,120,250,390
unknow_moji_sh
	dw	opchr_u
	dw	opchr_n
	dw	opchr_k
	dw	opchr_n
	dw	opchr_o
	dw	opchr_w
	dw	opchr_n
switch_moji_x
	dw	-300,-160,-45,60,180,300
switch_moji_sh
	dw	opchr_s
	dw	opchr_w
	dw	opchr_i
	dw	opchr_t
	dw	opchr_c
	dw	opchr_h
enter_moji_x
	dw	-420,-300,-180,-60,60,180,300,420
enter_moji_sh
	dw	opchr_e
	dw	opchr_n
	dw	opchr_t
	dw	opchr_r
	dw	opchr_a
	dw	opchr_n
	dw	opchr_c
	dw	opchr_e
core_moji_x
	dw	-180,-60,60,180
core_moji_sh
	dw	opchr_c
	dw	opchr_o
	dw	opchr_r
	dw	opchr_e

cup_y_pos
	db	0<<cup_scale+14<<cup_scale
	db	-1<<cup_scale+14<<cup_scale
	db	-2<<cup_scale+14<<cup_scale
	db	-4<<cup_scale+14<<cup_scale
	db	-6<<cup_scale+14<<cup_scale
	db	-8<<cup_scale+14<<cup_scale
	db	-10<<cup_scale+14<<cup_scale
	db	-12<<cup_scale+14<<cup_scale
	db	-13<<cup_scale+14<<cup_scale
	db	-14<<cup_scale+14<<cup_scale
enban_cx_tab
	dw	0
	dw	-61<<enban_scale
	dw	-61<<enban_scale
	dw	0
	dw	61<<enban_scale
	dw	61<<enban_scale
enban_cz_tab
	dw	70<<enban_scale
	dw	35<<enban_scale
	dw	-35<<enban_scale
	dw	-70<<enban_scale
	dw	-35<<enban_scale
	dw	35<<enban_scale
enban_ry_tab
	db	0,43,86,128,171,214
ame_sp_x
	dw	110,120,-110,-120
ame_sp_z
	dw	110,-110,100,-110
karakasa_cx
	dw	20<<karakasa_scale
	dw	-20<<karakasa_scale
karakasa_cz
	dw	0
	dw	0
	dw	20<<karakasa_scale
	dw	-20<<karakasa_scale
karakasa_ry
	db	-64,64,0,128
boyon_pos_z
	dw	1000
	dw	800
boyon_pos_x
	dw	0
	dw	-800
	dw	-1000
	dw	-800
	dw	0
	dw	800
	dw	1000
	dw	800
pool_pos_z
	dw	-1280
pool_pos_x
	dw	1280
	dw	1280
	dw	-1280
	dw	-1280

pool2_atack_roty
	db	-96,-32,32,96
pool2_pos_x
	dw	0,0,-1024,-1024
pool2_pos_z
	dw	-1024,0,0,-1024
ninjarun_x
	dw	600,600,-600,-600
ninjarun_z
	dw	600,-600,600,-600
ninjarun_ang
	db	224,160,32,96

hen_1_y_tab
	dw	0,-3000,3000,3000,0,0
yuka_hou_x
	dw	-768,768,0,-512,512,0,-768,768
yuka_hou_z
	dw	768,768,512,0,0,-512,-768,-768
big_shap_tab
	dw	beam_0s,beam_0sps,beam_0m,beam_0b
	dw	beam_1s,beam_1sps,beam_1m,beam_0b
	dw	beam_2s,beam_2sps,beam_2m,beam_2b
	dw	beam_0s,beam_0,nullshape,nullshape
	dw	beam_1s,beam_1,nullshape,nullshape
	dw	beam_2s,beam_2,nullshape,nullshape
plasma_tab
	dw	beam_2s,beam_2sps,beam_2m,beam_2b
	dw	plasma1s,plasma1sps,plasma1m,plasma1b
	dw	beam_2s,beam_2,nullshape,nullshape
	dw	plasma1s,plasma1,nullshape,nullshape




tamanage_pos_x
	dw	0,1024+256		;0,1024
	dw	0,1024+256		;0,1024
	dw	0,1024+256		;0,1024
tamanage_pos_z
	dw	0,0
	dw	-512-128,-512-128	;-512,-512
	dw	-1024-256,-1024-256	;-1024,-1024
tamanage_next
	db	1,2,4
	db	0,3,5
	db	0,3,4
	db	1,2,5
	db	2,5,0
	db	3,4,1
mukaderoom_x
	dw	-256,256,1056,1056,-1056,-1056,-256,256
mukaderoom_z
	dw	1056,1056,256,-256,256,-256,-1056,-1056
mukaderoom_rot
	db	128,128,64,64,-64,-64,0,0
gura_ang2
	db	-10
gura_ang
	db	20
	db	-18
	db	16
	db	-14
	db	12
	db	-10
	db	8
	db	-6
	db	4
	db	-2
shield_r_next_tab
	db		1,4		;from 0
	db		5,4		;from 1
	db		4,6		;from 2
	db		2,7		;from 3
	db		3,8		;from 4
	db		2,3		;from 5
	db		7,10		;from 6
	db		9,10		;from 7
	db		1,7		;from 8
	db		0,8		;from 9
	db		3,11		;from 10
	db		8,9		;from 11
shield_r_x_z
	dw		1536,2560
	dw		512,3584
	dw		-1536,2560
	dw		-512,2560
	dw		512,2560
	dw		-512,3584
	dw		-1536,1536
	dw		-512,1536
	dw		512,1536
	dw		1536,1536
	dw		-512,512
	dw		512,512

shield_r_next_tab_2
	db		3,5		;from 0
	db		2,3		;from 1
	db		1,4		;from 2
	db		0,5		;from 3
	db		2,3		;from 4
	db		6,9		;from 5
	db		4,10		;from 6
	db		4,6		;from 7
	db		2,7		;from 8
	db		5,10		;from 9
	db		5,8		;from 10
shield_r_x_z_2
	dw		-1792,3328
	dw		-768,3840
	dw		1280,3840
	dw		-768,2816
	dw		768,2816
	dw		-768,1792
	dw		256,1792
	dw		1792,1792
	dw		1280,768
	dw		-1792,256
	dw		256,256

friend_shape
	dw	a_wing	;fox,falco
	dw	c_wing	;peppy,slippy
	dw	b_wing	;gal1,gal2
friend_w1
	dw	a_wing_1	;fox
	dw	c_wing_1	;peppy
	dw	b_wing_1	;gal1
friend_w2
	dw	a_wing_0	;fox
	dw	c_wing_0	;peppy
	dw	b_wing_0	;gal1
friend_col
	dw	id_0_c
	dw	id_1_c
	dw	id_0_c
	dw	id_1_c
	dw	id_0_c
	dw	id_1_c

;eguchi's data end


