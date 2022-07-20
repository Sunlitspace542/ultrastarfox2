;--------------------------------------------------------------------;--------------------------------------------------------------------
;--------------------------------------------------------------------
;--------------------------------------------------------------------
;--------------------------------------------------------------------
;--------------------------------------------------------------------
;--------------------------------------------------------------------
;--------------------------------------------------------------------

	INCPUB	colboxes


;colbox	MACRO	;next,xoff,yoff,zoff,rot[x/y/z]|norot,xmax,ymax,zmax,flags to set,flags to clear[,scale]
; collision box for first cube


player_col		colbox	playerLW_col,0,0,0,rotxyz,10,10,10,HF1,0,0
playerLW_col		colbox	playerRW_col,-25,10,-15,rotxyz,10,10,10,HF2,0
playerRW_col		colbox	0,25,10,-15,rotxyz,10,10,10,HF3,0

B_WING_col		colbox	B_WINGLW_col,0,0,0,rotxyz,15,10,15,HF1,0,0
B_WINGLW_col		colbox	B_WINGRW_col,-20,-5,-10,rotxyz,10,10,10,HF2,0
B_WINGRW_col		colbox	0,20,-5,-10,rotxyz,10,10,10,HF3,0

C_WING_col		colbox	C_WINGLW_col,0,0,10,rotxyz,20,10,20,HF1,0,0
C_WINGLW_col		colbox	C_WINGRW_col,-30,0,0,rotxyz,10,10,10,HF2,0
C_WINGRW_col		colbox	0,30,0,0,rotxyz,10,10,10,HF3,0

ROBOT_col		colbox	0,0,0,0,roty,100,100,100,HF1!HF2!HF3,0

ROBOTB_col		colbox	ROBOTBLleg_col,0,-50,0,roty,10,10,10,HF1,0
ROBOTBLleg_col	colbox	ROBOTBRleg_col,-10,-20,-5,roty,5,20,5,HF2,0
ROBOTBRleg_col	colbox	0,10,-20,-5,roty,5,20,5,HF3,0

ROBOTA_col		colbox	ROBOTALleg_col,0,-45,0,roty,10,10,10,HF1,0
ROBOTALleg_col	colbox	ROBOTARleg_col,-15,-25,0,roty,10,25,10,HF2,0
ROBOTARleg_col	colbox	0,15,-25,0,roty,10,25,10,HF3,0

;ROBOTA_col		colbox	ROBOTALleg_col,0,-45,0,roty,10,10,10,HF1,0
;ROBOTALleg_col	colbox	ROBOTARleg_col,-15,-25,-10,roty,10,25,10,HF2,0
;ROBOTARleg_col	colbox	0,15,-25,-10,roty,10,25,10,HF3,0

;bu_4_col		colbox	bu_4_col1,30,-50,-30,roty,20,50,20,HF1,0,bu_scale
;bu_4_col1		colbox	bu_4_col2,30,-22,30,roty,20,22,20,HF1,0,bu_scale
;bu_4_col2		colbox	bu_4_col3,-30,-22,-30,roty,20,22,20,HF1,0,bu_scale
;bu_4_col3		colbox	0,-30,-22,30,roty,20,22,20,HF1,0,bu_scale

;bu_5_col		colbox	bu_5_col1,30,-50,0,roty,20,50,45,HF1,0,bu_scale
;bu_5_col1		colbox	bu_5_col2,-30,-22,-30,roty,20,22,20,HF1,0,bu_scale
;bu_5_col2		colbox	0,-30,-22,30,roty,20,22,20,HF1,0,bu_scale
;
;bu_6_col		colbox	bu_6_col1,30,-50,-30,roty,20,50,20,HF1,0,bu_scale
;bu_6_col1		colbox	bu_6_col2,30,-50,30,roty,20,50,20,HF1,0,bu_scale
;bu_6_col2		colbox	bu_6_col3,-30,-50,-30,roty,20,50,20,HF1,0,bu_scale
;bu_6_col3		colbox	0,-30,-50,30,roty,20,50,20,HF1,0,bu_scale


tank_0_col		colbox	0,30,-27,10,roty,30,27,50,HF1,0,0

big_gate_col1
	colbox	big_gate_col2,-45,-25,0,norot,5,25,55,HF1,0,2
big_gate_col2
	colbox	big_gate_col3,45,-25,0,norot,5,25,55,HF1,0,2
big_gate_col3
	colbox	0,0,-55,0,norot,50,5,55,HF1,0,2


;--------------------------------------------------------------------
; COLLISION BOX for BOSS SHAPES

spin_0_col		colbox	0,0,0,0,roty,15,60,15,HF1!HF2!HF3,0,spin_scale
spin_0yoko_col	colbox	0,0,0,0,roty,15,15,15,HF1!HF2!HF3,0,spin_scale
spin_1_col		colbox	0,0,0,0,roty,15,10,15,HF1!HF2!HF3,0,spin_scale
spin_2_col		colbox	0,0,0,0,roty,15,10,15,HF1!HF2!HF3,0,spin_scale

warpl_col		colbox	warpl_col1,0,0,060,rotxyz,5,10,5,HF1,0,warpl_scale
warpl_col1		colbox	warpl_col2,0,0,040,rotxyz,5,10,5,HF1,0,warpl_scale
warpl_col2		colbox	warpl_col3,0,0,020,rotxyz,5,10,5,HF1,0,warpl_scale
warpl_col3		colbox	warpl_col4,0,0,000,rotxyz,5,10,5,HF1,0,warpl_scale
warpl_col4		colbox	warpl_col5,0,0,-20,rotxyz,5,10,5,HF1,0,warpl_scale
warpl_col5		colbox	0,0,0,-40,rotxyz,5,5,5,HF1,0,warpl_scale

;dragon_0_col		colbox	dragon_0_col1,0,0,15,rotxyz,15,15,15,HF1,0,1
;dragon_0_col1	colbox	dragon_0_col2,0,-15,10,rotxyz,15,15,15,HF2,0,1
;dragon_0_col2	colbox	0,0,15,10,rotxyz,15,15,15,HF3,0,1

;dragon_1_col		colbox	dragon_1_col1,0,0,-25,rotxyz,15,15,15,HF1!HF2!HF3,0,1
;dragon_1_col1	colbox	dragon_1_col2,0,0,0,rotxyz,15,15,15,HF1!HF2!HF3,0,1
;dragon_1_col2	colbox	0,0,0,25,rotxyz,15,15,15,HF1!HF2!HF3,0,1

;dragon_2_col		colbox	dragon_2_col1,0,-10,0,rotxyz,10,10,10,HF1!HF2!HF3,0,1
;dragon_2_col1	colbox	dragon_2_col2,0,0,0,rotxyz,10,10,10,HF1!HF2!HF3,0,1
;dragon_2_col2	colbox	0,0,10,0,rotxyz,10,10,10,HF1!HF2!HF3,0,1


mask_col	colbox	mask_col2,-30,-40,-30,roty,20,20,20,HF2,0,andorf_scale
mask_col2	colbox	0,30,-40,-30,roty,20,20,20,HF1,0,andorf_scale
;--------------------------------------------------------------------
;--------------------------------------------------------------------
;--------------------------------------------------------------------
;--------------------------------------------------------------------
;--------------------------------------------------------------------
;--------------------------------------------------------------------
;--------------------------------------------------------------------
;--------------------------------------------------------------------

;           
;           
;ษอออออออออออออออออออออออออออป
;           
;           
;ษอออออออออออออออออออออออออออป
;บ  EGUCHI'S BLOCK collision บ 
;ศอออออออออออออออออออออออออออผ
;
firebr_col		colbox	0,0,0,50,rotxyz,8,8,8,HF1,0,dodora_scale+2
;;firebr_col		colbox	firebr_col2,0,0,80,rotxyz,5,5,5,HF1,0,dodora_scale+2
;;firebr_col2		colbox	0,0,0,20,rotxyz,5,5,5,HF1,0,dodora_scale+2

;;laser's collision

elaser0_col		colbox	el0_col2,0,0,0,rotxyz,10,10,10,HF1!HF2!HF3,0,2
el0_col2		colbox	el0_col3,0,0,-20,rotxyz,10,10,10,HF1!HF2!HF3,0,2
el0_col3		colbox	       0,0,0,-40,rotxyz,10,10,10,HF1!HF2!HF3,0,2

beam_s_col		colbox	beam_s_col2,0,0,10,rotxyz,5,5,5,HF1!HF2!HF3,0,2
beam_s_col2		colbox	beam_s_col3,0,0,30,rotxyz,5,5,5,HF1!HF2!HF3,0,2
beam_s_col3		colbox		  0,0,0,50,rotxyz,5,5,5,HF1!HF2!HF3,0,2

elaser2_col		colbox	el2_col2,0,0,10,rotxyz,10,10,10,HF1!HF2!HF3,0,2
el2_col2		colbox	el2_col3,0,0,-20,rotxyz,10,10,10,HF1!HF2!HF3,0,2
el2_col3		colbox	el2_col4,0,0,-50,rotxyz,10,10,10,HF1!HF2!HF3,0,2
el2_col4		colbox	0,0,0,-80,rotxyz,10,10,10,HF1!HF2!HF3,0,2

elaser2s_col		colbox	el2s_col2,0,0,105,rotxyz,5,5,5,HF1!HF2!HF3,0,3
el2s_col2		colbox	el2s_col3,0,0,75,rotxyz,5,5,5,HF1!HF2!HF3,0,3
el2s_col3		colbox	el2s_col4,0,0,45,rotxyz,5,5,5,HF1!HF2!HF3,0,3
el2s_col4		colbox	el2s_col5,0,0,15,rotxyz,5,5,5,HF1!HF2!HF3,0,3
el2s_col5		colbox		0,0,0,-15,rotxyz,5,5,5,HF1!HF2!HF3,0,3

elaser2m_col		colbox	el2m_col2,0,0,20,rotxyz,10,10,10,HF1!HF2!HF3,0,3
el2m_col2		colbox	el2m_col3,0,0,60,rotxyz,10,10,10,HF1!HF2!HF3,0,3
el2m_col3		colbox	el2m_col4,0,0,100,rotxyz,10,10,10,HF1!HF2!HF3,0,3
el2m_col4		colbox	el2m_col5,0,0,-20,rotxyz,10,10,10,HF1!HF2!HF3,0,3
el2m_col5		colbox	el2m_col6,0,0,-60,rotxyz,10,10,10,HF1!HF2!HF3,0,3
el2m_col6		colbox		0,0,0,-100,rotxyz,10,10,10,HF1!HF2!HF3,0,3

elaser2b_col		colbox	el2b_col2,0,0,0,rotxyz,35,35,35,HF1!HF2!HF3,0,3
el2b_col2		colbox	el2b_col3,0,0,90,rotxyz,35,35,35,HF1!HF2!HF3,0,3
el2b_col3		colbox	0,0,0,-90,rotxyz,35,35,35,HF1!HF2!HF3,0,3

;;;;;;;;;;;
b_meteo_col		colbox	0,0,0,0,roty,45,45,45,HF1,0,5

yoyo_col		colbox	yoyo_col2,0,0,0,roty,10,30,10,HF1,0,yoyo_scale
yoyo_col2		colbox	yoyo_col3,0,0,20,roty,10,30,10,HF1,0,yoyo_scale
yoyo_col3		colbox		0,0,0,-20,roty,10,30,10,HF1,0,yoyo_scale

miss2_col		colbox	miss2_col2,0,0,0,rotxyz,15,15,15,HF1,0,miss2_scale
miss2_col2		colbox	miss2_col3,0,0,100,rotxyz,15,15,15,HF1,0,miss2_scale
miss2_col3		colbox		 0,0,0,-100,rotxyz,15,15,15,HF1,0,miss2_scale

core6_col		colbox	core6_col2,0,0,0,roty,7,10,7,HF1,0,kaku6_scale
core6_col2		colbox		 0,0,12,0,roty,10,8,10,HF1,0,kaku6_scale

bou_0_col		colbox	bou_0_col2,15,-5,0,rotxyz,6,6,6,HF1,0,bou_scale
bou_0_col2		colbox	bou_0_col3,15,15,0,rotxyz,6,6,6,HF1,0,bou_scale
bou_0_col3		colbox		 0,-25,15,0,rotxyz,6,6,6,HF1,0,bou_scale

tako_0_col		colbox	tako_0_col2,0,-60,-60,roty,40,40,40,HF1,0,tako_scale
tako_0_col2		colbox		  0,0,-20,-30,roty,20,20,20,HF1,0,tako_scale

;tako_0_col		colbox	tako_0_col2,0,-30,-10,roty,20,20,20,HF1,0,tako_scale
;tako_0_col2		colbox		  0,0,-40,-60,roty,30,30,30,HF1,0,tako_scale

chi_hou_col		colbox		  0,0,-15,20,roty,12,12,12,HF1,0,chi_hou_scale

yuka_hou_col		colbox		  0,0,-30,0,roty,10,30,10,HF1,0,yuka_hou_scale

;ha_hou_col		colbox		0,0,-40,0,roty,10,10,10,HF1,0,ha_hou_scale
;ha_hou_col		colbox	ha_hou_col2,0,-10,0,roty,10,5,10,HF2,0,ha_hou_scale
;ha_hou_col2		colbox	ha_hou_col3,0,-40,0,roty,10,20,10,HF1,0,ha_hou_scale
;ha_hou_col3		colbox		  0,0,-70,0,roty,10,5,10,HF2,0,ha_hou_scale

room_hou_col		colbox		    0,0,0,40,roty,30,30,30,HF1,0,room_hou_scale

da_ha_yo_col		colbox	da_ha_yo_col2,0,0,0,roty,9,10,9,HF1,0,da_ha_yo_scale
da_ha_yo_col2	colbox	da_ha_yo_col3,23,0,0,roty,9,10,9,HF1,0,da_ha_yo_scale
da_ha_yo_col3	colbox		    0,-23,0,0,roty,9,10,9,HF1,0,da_ha_yo_scale

tousen_col		colbox	tousen_col2,0,0,0,roty,20,20,20,HF1,0,tousenbo_scale
tousen_col2		colbox	tousen_col3,45,0,0,roty,25,20,20,HF1,0,tousenbo_scale
tousen_col3		colbox		  0,-45,0,0,roty,25,20,20,HF1,0,tousenbo_scale

;fuse_col		colbox		0,0,-25,0,roty,15,25,15,HF1,0,fuse_scale

;senkan_0_col		colbox	senkan_0_col2,0,0,40,roty,20,10,20,HF1,0,senkan_0_scale
;senkan_0_col2	colbox	senkan_0_col3,0,0,0,roty,20,10,20,HF1,0,senkan_0_scale
;senkan_0_col3	colbox		    0,0,0,-40,roty,20,10,20,HF1,0,senkan_0_scale

big_l_f_col		colbox	big_l_f_col2,0,0,-35,roty,30,30,30,HF1,0,big_l_scale
big_l_f_col2		colbox		   0,0,0,25,roty,30,30,30,HF1,0,big_l_scale

;kan_shield_col	colbox	kan_shild_col2,0,0,10,roty,10,40,10,HF1,0,teki_2_scale
;kan_shild_col2	colbox	kan_shild_col3,0,0,30,roty,10,40,10,HF1,0,teki_2_scale
;kan_shild_col3	colbox	kan_shild_col4,0,0,50,roty,10,40,10,HF1,0,teki_2_scale
;kan_shild_col4	colbox	kan_shild_col5,0,0,70,roty,10,40,10,HF1,0,teki_2_scale
;kan_shild_col5	colbox	kan_shild_col6,0,0,-10,roty,10,40,10,HF1,0,teki_2_scale
;kan_shild_col6	colbox	kan_shild_col7,0,0,-30,roty,10,40,10,HF1,0,teki_2_scale
;kan_shild_col7	colbox		     0,0,0,-50,roty,10,30,10,HF1,0,teki_2_scale

bara_miss_col	colbox	bara_miss_col2,0,0,-15,roty,10,10,10,HF1,0,miss2_scale
bara_miss_col2	colbox	bara_miss_col3,0,0,-45,roty,10,10,10,HF1,0,miss2_scale
bara_miss_col3	colbox	bara_miss_col4,0,0,-75,roty,10,10,10,HF1,0,miss2_scale
bara_miss_col4	colbox	bara_miss_col5,0,0,15,roty,10,10,10,HF1,0,miss2_scale
bara_miss_col5	colbox	bara_miss_col6,0,0,45,roty,10,10,10,HF1,0,miss2_scale
bara_miss_col6	colbox		     0,0,0,75,roty,10,10,10,HF1,0,miss2_scale

stepup_fly_col	colbox		  0,0,0,-20,roty,25,25,25,HF1,0,stepup_scale

shield_col		colbox	shield_col2,20,0,-18,roty,20,60,20,HF1,0,tekuteku_scale
shield_col2		colbox		  0,-20,0,-18,roty,20,60,20,HF1,0,tekuteku_scale

dandou_col		colbox	dan_col2,0,0,40,roty,40,40,40,HF1,0,dandou_scale
dan_col2		colbox	dan_col3,0,0,80,roty,40,40,40,HF1,0,dandou_scale
dan_col3		colbox	dan_col4,0,0,-40,roty,40,40,40,HF1,0,dandou_scale
dan_col4		colbox	       0,0,0,-80,roty,40,40,40,HF1,0,dandou_scale

;dandou_half_col	colbox	dan_h_col2,0,0,25,roty,25,25,25,HF1,0,dandou_half_scale
;dan_h_col2		colbox	dan_h_col3,0,0,75,roty,25,25,25,HF1,0,dandou_half_scale
;dan_h_col3		colbox	dan_h_col4,0,0,-25,roty,25,25,25,HF1,0,dandou_half_scale
;dan_h_col4		colbox	       0,0,0,-75,roty,25,25,25,HF1,0,dandou_half_scale

kusha_col		colbox	kusha_col1,0,0,0,roty,20,20,20,HF1,0,kusha_scale
kusha_col1		colbox	kusha_col2,0,-20,40,roty,20,20,20,HF1,0,kusha_scale
kusha_col2		colbox		 0,0,10,-30,roty,20,20,20,HF1,0,kusha_scale

;kurage_col		colbox		  0,0,-10,0,roty,30,30,30,HF1,0,kurage_scale
;kurage1_col		colbox	kurage1_col1,0,10,0,roty,10,10,10,HF1,0,kurage_scale
;kurage1_col1		colbox	kurage1_col2,0,30,0,roty,10,10,10,HF1,0,kurage_scale
;kurage1_col2		colbox		   0,0,50,0,roty,10,10,10,HF1,0,kurage_scale
;kurage2_col		colbox		  0,0,20,0,roty,20,20,20,HF1,0,kurage_scale

;f_robo_col		colbox	f_robo_col1,0,-30,0,roty,20,10,20,HF1,0,f_robo_scale
;f_robo_col1		colbox	f_robo_col2,40,-10,0,roty,10,10,10,HF1,0,f_robo_scale
;f_robo_col2		colbox		  0,-40,-10,0,roty,10,10,10,HF1,0,f_robo_scale

;colo_00_col		colbox	colo_00_col2,15,-15,10,roty,7,7,7,HF1,0,colo_0_scale
;colo_00_col2		colbox	colo_00_col4,15,-15,50,roty,7,7,7,HF1,0,colo_0_scale
;colo_00_col4		colbox	colo_00_col6,15,-15,90,roty,7,7,7,HF1,0,colo_0_scale
;colo_00_col6		colbox	colo_00_col8,15,-15,-30,roty,7,7,7,HF1,0,colo_0_scale
;colo_00_col8		colbox	colo_00_col9,15,-15,-70,roty,7,7,7,HF1,0,colo_0_scale
;colo_00_col9		colbox		   0,0,0,-90,roty,10,10,10,HF1,0,colo_0_scale

;d_keep_1_col		colbox		  0,0,65,0,roty,30,95,30,HF1,0,d_keep_scale

kani_1_col		colbox		  0,45,50,0,roty,15,50,15,HF1,0,kani_0_scale
kani_2_col		colbox		  0,-45,50,0,roty,15,50,15,HF1,0,kani_0_scale

;mikako_col1		colbox	mikako_col2,0,-80,0,roty,20,20,20,HF1,0,mikako_scale
;mikako_col2		colbox	mikako_col3,0,-50,0,roty,25,10,25,HF1,0,mikako_scale
;mikako_col3		colbox		  0,0,-20,0,roty,5,20,5,HF1,0,mikako_scale

mukade_0_col		colbox		    0,0,-15,0,roty,20,15,10,HF1,0,mukade_scale
mukade_2_col		colbox		    0,0,-65,0,roty,20,15,10,HF1,0,mukade_scale

;sagyou_0_col1	colbox	sagyou_0_col2,40,0,0,roty,10,10,10,HF1,0,sagyou_scale
;sagyou_0_col2	colbox	sagyou_0_col3,40,0,20,roty,10,10,10,HF1,0,sagyou_scale
;sagyou_0_col3	colbox	sagyou_0_col4,40,0,-20,roty,10,10,10,HF1,0,sagyou_scale
;sagyou_0_col4	colbox	sagyou_0_col5,-40,0,0,roty,10,10,10,HF1,0,sagyou_scale
;sagyou_0_col5	colbox	sagyou_0_col6,-40,0,20,roty,10,10,10,HF1,0,sagyou_scale
;sagyou_0_col6	colbox	sagyou_0_col7,-40,0,-20,roty,10,10,10,HF1,0,sagyou_scale
;sagyou_0_col7	colbox		    0,0,0,0,roty,10,10,10,HF2,0,sagyou_scale

sagyou_1_col1	colbox	sagyou_1_col2,0,0,10,roty,10,10,10,HF1,0,sagyou_scale
sagyou_1_col2	colbox	sagyou_1_col3,0,0,30,roty,10,10,10,HF1,0,sagyou_scale
sagyou_1_col3	colbox	sagyou_1_col4,0,0,-10,roty,10,10,10,HF1,0,sagyou_scale
sagyou_1_col4	colbox		    0,0,0,-30,roty,10,10,10,HF1,0,sagyou_scale

;miss_0_col1		colbox	miss_0_col2,0,0,5,roty,5,5,5,HF1,0,miss_dai_scale
;miss_0_col2		colbox	miss_0_col3,0,0,15,roty,5,5,5,HF1,0,miss_dai_scale
;miss_0_col3		colbox	miss_0_col4,0,0,-5,roty,5,5,5,HF1,0,miss_dai_scale
;miss_0_col4		colbox		  0,0,0,-15,roty,5,5,5,HF1,0,miss_dai_scale

;hasami_0_col		colbox	0,0,-50,0,roty,30,50,15,HF1,0,hasami_scale

hasami_2_col1	colbox	hasami_2_col2,0,-5,0,roty,5,5,5,HF1,0,hasami_scale
hasami_2_col2	colbox	hasami_2_col3,0,-15,0,roty,5,5,5,HF1,0,hasami_scale
hasami_2_col3	colbox	hasami_2_col4,0,-25,0,roty,5,5,5,HF1,0,hasami_scale
hasami_2_col4	colbox		    0,0,-35,0,roty,5,5,5,HF1,0,hasami_scale
        
;ibara_1_col1		colbox	ibara_1_col2,0,-12,0,rotz,10,12,10,HF1,0,ibara_scale
;ibara_1_col2		colbox	ibara_1_col3,0,-37,0,rotz,10,12,10,HF1,0,ibara_scale
;ibara_1_col3		colbox	ibara_1_col4,0,-62,0,rotz,10,12,10,HF1,0,ibara_scale
;ibara_1_col4		colbox	           0,0,-87,0,rotz,10,12,10,HF1,0,ibara_scale
;
guru2bar_col1	colbox	guru2bar_col2,-70,-10,0,roty,10,10,10,HF1,0,guru2bar_scale
guru2bar_col2	colbox	guru2bar_col3,-40,-10,0,roty,10,10,10,HF1,0,guru2bar_scale
guru2bar_col3	colbox	guru2bar_col4,040,-10,0,roty,10,10,10,HF1,0,guru2bar_scale
guru2bar_col4	colbox	guru2bar_col5,070,-10,0,roty,10,10,10,HF1,0,guru2bar_scale
guru2bar_col5	colbox		    0,000,-10,0,roty,10,10,10,HF2,0,guru2bar_scale

;gun_0_0_col		colbox	gun_0_0_col1,0,0,5,roty,5,5,5,HF1,0,gun_0_scale
;gun_0_0_col1		colbox	gun_0_0_col2,0,0,-5,roty,5,5,5,HF1,0,gun_0_scale
;gun_0_0_col2		colbox	           0,0,0,-15,roty,5,5,5,HF1,0,gun_0_scale

;flower_1_col		colbox	flower_1_col1,30,0,0,roty,30,30,20,HF1,0,flower_scale
;flower_1_col1	colbox	flower_1_col2,-30,0,0,roty,30,30,20,HF1,0,flower_scale
;flower_1_col2	colbox	flower_1_col3,0,0,30,roty,20,30,30,HF1,0,flower_scale
;flower_1_col3	colbox		    0,0,0,-30,roty,20,30,30,HF1,0,flower_scale

;saru_2_col		colbox	0,0,20,0,roty,20,30,20,HF1,0,saru_0_scale

;track_0_col		colbox	track_0_col1,0,0,-30,roty,15,13,15,HF1,0,track_scale
;track_0_col1		colbox		   0,0,0,30,roty,15,13,15,HF1,0,track_scale

