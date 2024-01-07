;*********************************************************************
;*			Debugging	 			*
;*********************************************************************
	IFEQ	debuginfo

kbugsw	equ	0	; 0/1 ... off/on	;kbug1~kbug9 OFF/ON
kblinksw	equ	0	; 0/1 ... blink switch ON / OFF
kginfo	equ	0	; 0/1 ... kawaguchi info display OFF / ON
kdemosw	equ	0	; 0/1 ... demo ari / demo nashi
kplanetskill	equ	0	; 0/1 ... planet skill display
ksosskill	equ	0	; 0/1 ... SOS skill display

	ELSEIF

kbugsw	equ	1	; 0/1 ... off/on	;kbug1~kbug9 OFF/ON
kblinksw	equ	1	; 0/1 ... blink switch ON / OFF
kginfo	equ	1	; 0/1 ... kawaguchi info display OFF / ON
kdemosw	equ	0	; 0/1 ... demo ari / demo nashi
kplanetskill	equ	0	; 0/1 ... planet skill display
ksosskill	equ	0	; 0/1 ... SOS skill display

	ENDC
;*********************************************************************
;*			Bit					*
;*********************************************************************

	km_flagstart
	km_flag	d0	; %00000001
	km_flag	d1	; %00000010
	km_flag	d2	; %00000100
	km_flag	d3	; %00001000
	km_flag	d4	; %00010000
	km_flag	d5	; %00100000
	km_flag	d6	; %01000000
	km_flag	d7	; %10000000

;=====================================================================
	km_flagstart
	km_flag	kbit0	; %0000000000000001
	km_flag	kbit1	; %0000000000000010
	km_flag	kbit2	; %0000000000000100
	km_flag	kbit3	; %0000000000001000
	km_flag	kbit4	; %0000000000010000
	km_flag	kbit5	; %0000000000100000
	km_flag	kbit6	; %0000000001000000
	km_flag	kbit7	; %0000000010000000
	km_flag	kbit8	; %0000000100000000
	km_flag	kbit9	; %0000001000000000
	km_flag	kbit10	; %0000010000000000
	km_flag	kbit11	; %0000100000000000
	km_flag	kbit12	; %0001000000000000
	km_flag	kbit13	; %0010000000000000
	km_flag	kbit14	; %0100000000000000
	km_flag	kbit15	; %1000000000000000

;*********************************************************************
;*								*
;*			VRAM LAYOUT				*
;*								*
;*********************************************************************
scrsize1	equ	0
scrsizeyoko2	equ	1
scrsizetate2	equ	2
scrsize4	equ	3

bitmapdecbase	equ	bitmapbase+dec_base
;=====================================================================
;*			OBJ Offset				*
;=====================================================================
;_obj_cgx = (50*k)/2 :(vars.inc)
obj_offset		equ	(_obj_cgx-(_obj_cgx&($c000>>1)))/16	;32
mp_obj_offset	equ	0
mm_obj_offset	equ	0

;=====================================================================
;*			Title 					*
;=====================================================================
t_bg1_cgx1	equ	(0*k)/2
t_bg1_cgx2	equ	(0*k)/2
t_bg2_cgx	equ	(0*k)/2
t_bg3_cgx	equ	(0*k)/2
t_bg1_scr	equ	(0*k)/2
t_bg2_scr	equ	(40*k)/2
t_bg3_scr	equ	(0*k)/2
t_obj_cgx	equ	_obj_cgx
;=====================================================================
;*			Mission Map 				*
;=====================================================================
mm_bg1_cgx_1	equ	(00*k)/2		;16*k :bitmap chr
mm_bg1_cgx_2	equ	(16*k)/2		;16*k :bitmap chr
mm_bg2_cgx	equ	(00*k)/2		;16*k :512 chr
mm_bg2_cgx_1	equ	(00*k)/2		;8*k  :256 chr
mm_bg2_cgx_2	equ	(16*k)/2		;8*k  :256 chr
mm_bg3_cgx	equ	(32*k)/2		;4*k  :256 chr
mm_bg1_scr	equ	(36*k)/2		;4*k  :2 screen
mm_bg2_scr	equ	(40*k)/2		;4*k  :2 screen
mm_bg3_scr	equ	(44*k)/2		;4*k  :2 screen
mm_obj_cgx	equ	(48*k)/2		;16*k :512 chr

mm_enbase_cgx_1	equ	mm_bg1_cgx_1+$c0*32/2
mm_enbase_cgx_2	equ	mm_bg1_cgx_2+$c0*32/2

;'95/1/31
;(mario chip side)
mm_bitmaphight	equ	16
mm_bitmapwidth	equ	16
mm_messagehight	equ	16
mm_messagewidth	equ	16
mm_messagelength	equ	mm_messagehight*mm_messagewidth*32
mm_wbuflength	equ	mm_messagelength
mm_messagesaddr	equ	(mm_bitmaphight-mm_messagehight)*mm_messagewidth*32
mm_fixbg1cgxlength	equ	512*32-mm_messagelength
mm_planetbaseNO	equ	mm_fixbg1cgxlength/32

;(vram double buffer side)
mm_bg1_bitmap1	equ	mm_bg1_cgx_1+mm_fixbg1cgxlength/2
mm_bg1_bitmap2	equ	mm_bg1_cgx_2+mm_fixbg1cgxlength/2


;(OLD Version)
;mm_bitmaphight	equ	20
;mm_bitmapwidth	equ	16
;mm_wbuflength	equ	mm_bitmaphight*mm_bitmapwidth*32  ;Double Buffer Length
;mm_fixbg1cgxlength	equ	512*32-mm_wbuflength
;mm_bg1_bitmap1	equ	mm_bg1_cgx_1+mm_fixbg1cgxlength/2 ;VRAM BG1 bitmap base1
;mm_bg1_bitmap2	equ	mm_bg1_cgx_2+mm_fixbg1cgxlength/2 ;VRAM BG1 bitmap base2
;mm_planetbaseNO	equ	mm_fixbg1cgxlength/32
;=====================================================================
;*			Mission Player Select			*
;=====================================================================
mp_bg1_cgx	equ	(0*k)/2		;8*k
mp_bg1_scr	equ	(24*k)/2	;2*k
mp_bg2_cgx	equ	(0*k)/2		;bg1 to kyoutuu
mp_bg2_scr	equ	(26*k)/2	;2*k
mp_bg3_cgx	equ	(16*k)/2	;8*k
mp_bg3_scr	equ	(40*k)/2	;8*k
mp_obj_cgx	equ	(48*k)/2	;12*k
;=====================================================================
;*			Mission Explain				*
;=====================================================================
_me_bg1_cgx1	equ	(0*k)/2		;21*k
_me_bg1_cgx2	equ	(24*k)/2	;21*k
_me_bg1_scr	equ	(22*k)/2	;2*k
_me_bg2_cgx	equ	(48*k)/2	;2*k
_me_bg2_scr	equ	(46*k)/2	;2*k
_me_bg3_cgx	equ	(56*k)/2	;4*k
_me_bg3_scr	equ	(60*k)/2	;4*k
_me_obj_cgx	equ	_obj_cgx	;6*k

;=====================================================================
;*			Mission Result				*
;=====================================================================
mr_bg1_cgx	equ	(0*k)/2		;16*k
mr_bg1_scr	equ	(32*k)/2	;4*k
mr_bg2_cgx	equ	(0*k)/2		;?
mr_bg2_scr	equ	(36*k)/2	;2*k
mr_bg3_cgx	equ	(16*k)/2	;4*k
mr_bg3_scr	equ	(40*k)/2	;2*k
mr_obj_cgx	equ	(48*k)/2	;16*k

;=====================================================================
;*			HI score				*
;=====================================================================
hs_bg1_cgx	equ	(0*k)/2		;16*k
hs_bg1_scr	equ	(32*k)/2	;4*k
hs_bg2_cgx	equ	(0*k)/2		;16*k
hs_bg2_scr	equ	(36*k)/2	;2*k
hs_bg3_cgx	equ	(16*k)/2	;16*k
hs_bg3_scr	equ	(40*k)/2	;2*k
hs_obj_cgx	equ	(48*k)/2	;8*k

;=====================================================================
;*			Battle Field Select			*
;=====================================================================
bf_bg1_cgx	equ	(0*k)/2
bf_bg2_cgx	equ	(0*k)/2
bf_bg3_cgx	equ	(16*k)/2

bf_bg1_scr	equ	(32*k)/2
bf_bg2_scr	equ	(34*k)/2
bf_bg3_scr	equ	(42*k)/2

bf_obj_cgx	equ	_obj_cgx	;(50*k)/2	;50~
;-------------------------------------------------------------------
bp_bg1_cgx	equ	(0*k)/2
bp_bg1_scr	equ	(40*k)/2
bp_bg2_cgx	equ	(16*k)/2
bp_bg2_scr	equ	(42*k)/2
bp_bg3_cgx	equ	(0*k)/2
bp_bg3_scr	equ	(48*k)/2
bp_obj_cgx	equ	_obj_cgx	;(50*k)/2

;=====================================================================
;*		VRAM Layout for Config				*
;=====================================================================
cn_obj_cgx	equ	_obj_cgx	;(50*k)/2

;=====================================================================
;*		VRAM Layout for 3D megane			*
;=====================================================================
bg2_scr_3D	equ	(22*k)/2	;18/10/93 (3D megane)
bg3_scr_3D	equ	(58*k)/2
bg3_cgx_3D	equ	(56*k)/2

nuki	equ	0
beta	equ	$ffff

;*********************************************************************
;*								*
;*			GAME SEQUENCE 				*
;*								*
;*********************************************************************
;*** Not Using ****
	IFEQ	1
	km_gameptr	testgamemode		;
	km_gameptr	initbattle		;
	km_gameptr	selectbattlefield	;
	km_gameptr	selectbattleplayer	;
	km_gameptr	inittraining		;
	km_gameptr	typeselect		;
	km_gameptr	testmissionlevel	;
	km_gameptr	testlocation		;
	km_gameptr	testplayer		;
	km_gameptr	testuser		;
	km_gameptr	testbattlefield		;
	km_gameptr	3dglasses		;
	ENDC
;*********************************************************************
;*								*
;*			GAME Label				*
;*								*
;*********************************************************************
;**** Map Place Number ****
	km_gmlabelstart	map,0
	km_gmlabel	ground	;0
	km_gmlabel	marine	;1
	km_gmlabel	desert	;2
	km_gmlabel	space	;3
	km_gmlabel	dummy1	;4
	km_gmlabel	dummy2	;5
	km_gmlabel	tunnel	;6
	km_gmlabel	sun	;7
	km_gmlabel	dummy3	;8
	km_gmlabel	room	;9
map_notuse	equ	-1

;**** planet colour ****
	km_gmlabelstart	pal,0
	km_gmlabel	nopal	;0
	km_gmlabel	1	;1
	km_gmlabel	2	;2
	km_gmlabel	3	;3
	km_gmlabel	4	;4
	km_gmlabel	5	;5

;* mother ship *
mothercx	equ	$10*8
mothercy	equ	$18*8
motherchr	equ	$46

;* planet center (x,y) zahyou (sprites)  [mission map select] *
mm_planet1x	equ	$0c*8
mm_planet1y	equ	$14*8
mm_planet2x	equ	$05*8
mm_planet2y	equ	$19*8
mm_planet3x	equ	$1c*8
mm_planet3y	equ	$18*8
mm_planet4x	equ	$04*8
mm_planet4y	equ	$07*8
mm_planet5x	equ	$10*8
mm_planet5y	equ	$0b*8
mm_planet6x	equ	$1c*8
mm_planet6y	equ	$08*8

;**** player type ***
;(For Kawagoe)
;ep_FOX		equ	0
;ep_FALCO		equ	1
;ep_PEPPY		equ	2
;ep_SLIPPY		equ	3
;ep_GAL1		equ	4
;ep_GAL2		equ	5

	km_gmflagstart	kpltyf
	km_gmflag	fox
	km_gmflag	falco
	km_gmflag	peppy
	km_gmflag	slippy
	km_gmflag	gal1
	km_gmflag	gal2

;**** arwing type ***
kawtyf_FF		equ	%00000011
kawtyf_SP		equ	%00001100
kawtyf_GG		equ	%00110000

;**** NOT USE *****
;GameOverFlag	equ	%10000000
;ShtDownFlag		equ	%00000001
;TimeUpFlag		equ	%00000010
;RingOutFlag		equ	%00000011
;PLay1PFlag		equ	%00000001
;PLay2PBTFlag	equ	%00000010

;=====================================================================
;*			MissionMap				*
;=====================================================================

;* Game Initial Time *
misstgtime	equ	5*60+1

mm_planetnumber	equ	5	;planet no kazu
mm_planetCGXstart	equ	$100*$20;planet CGX no start character No
mm_cgx4		equ	$20	;1 chara no byte size (4bit mode) 
mm_planetCGXBase	equ	$2000	;BG1 VRAM base change address
cgxbuffer_len	equ	$1000	;Heap Buffer Length (OBJ Arwing)

;=====================================================================
;*			Battle					*
;=====================================================================
;* Game Initial Time *
batstgtime	equ	2*60+1

;*********************************************************************
;*								*
;*			Sprites Parameters			*
;*								*
;*********************************************************************
;* Ring Out Routine wo ireru/hazusu *
kv_ringout	equ	0	;0/1 ... ireru / hazusu

;=====================================================================
;*		Sprites temporary parameyters			*
;=====================================================================
colpal0	equ	0
colpal1	equ	1
colpal2	equ	2
colpal3	equ	3
colpal4	equ	4
colpal5	equ	5
colpal6	equ	6
colpal7	equ	7

pri0	equ	0
prio0	equ	0
pri1	equ	1
prio1	equ	1
pri2	equ	2
prio2	equ	2
pri3	equ	3
prio3	equ	3

noflip	equ	0
xflip	equ	1
yflip	equ	2
xyflip	equ	3

bg_colpal0	equ	0<<10
bg_colpal1	equ	1<<10
bg_colpal2	equ	2<<10
bg_colpal3	equ	3<<10
bg_colpal4	equ	4<<10
bg_colpal5	equ	5<<10
bg_colpal6	equ	6<<10
bg_colpal7	equ	7<<10
bg_pri0	equ	0<<13
bg_pri1	equ	1<<13
bg_noflip	equ	0<<14
bg_xflip	equ	1<<14
bg_yflip	equ	2<<14
bg_xyflip	equ	3<<14

bg_colpal0_h	equ	0<<2
bg_colpal1_h	equ	1<<2
bg_colpal2_h	equ	2<<2
bg_colpal3_h	equ	3<<2
bg_colpal4_h	equ	4<<2
bg_colpal5_h	equ	5<<2
bg_colpal6_h	equ	6<<2
bg_colpal7_h	equ	7<<2
bg_pri0_h	equ	0<<5
bg_pri1_h	equ	1<<5
bg_noflip_h	equ	0<<6
bg_xflip_h	equ	1<<6
bg_yflip_h	equ	2<<6
bg_xyflip_h	equ	3<<6

obj_colpal0	equ	0<<9
obj_colpal1	equ	1<<9
obj_colpal2	equ	2<<9
obj_colpal3	equ	3<<9
obj_colpal4	equ	4<<9
obj_colpal5	equ	5<<9
obj_colpal6	equ	6<<9
obj_colpal7	equ	7<<9
obj_pri0	equ	0<<12
obj_pri1	equ	1<<12
obj_pri2	equ	2<<12
obj_pri3	equ	3<<12
obj_noflip	equ	0<<14
obj_xflip	equ	1<<14
obj_yflip	equ	2<<14
obj_xyflip	equ	3<<14

obj_colpal0_h	equ	0<<1
obj_colpal1_h	equ	1<<1
obj_colpal2_h	equ	2<<1
obj_colpal3_h	equ	3<<1
obj_colpal4_h	equ	4<<1
obj_colpal5_h	equ	5<<1
obj_colpal6_h	equ	6<<1
obj_colpal7_h	equ	7<<1
obj_pri0_h		equ	0<<4
obj_pri1_h		equ	1<<4
obj_pri2_h		equ	2<<4
obj_pri3_h		equ	3<<4
obj_noflip_h		equ	0<<6
obj_xflip_h		equ	1<<6
obj_yflip_h		equ	2<<6
obj_xyflip_h		equ	3<<6

;============= OBJ SET parameter ================
obj_val	equ	128
objsub_val	equ	32/4
obj_clear	equ	$0e8e8
objsub_on	equ	$00
objsub_off	equ	$55

;============= Double buffer Flag ==============
oamtransflag	equ	1 	;(0...buf1 trans,buf2 write)
			;(1...buf1 write,buf2 trans)
oambuf1	equ	0
oambuf2	equ	(128*4)+(128/4)

;*********************************************************************
;*			OGJ RADAR				*
;*********************************************************************
;RADAR'S SPRITE NUMBER

ra_off		equ	0
ra_honmei		equ	obj_colpal0_h+$80	;($80 = special flag)
ra_sonota		equ	obj_colpal1_h+$80	;($80 = special flag)
ra_enemy		equ	obj_colpal3_h+$80	;($80 = special flag)

ra_base		equ	$2e
ra_entrance		equ	$1e
ra_HPpanel		equ	$2c
ra_player		equ	$69
ra_laser		equ	$1f

scale_ground	equ	-1	;1 dot = 128
scale_space	equ	1	;1 dot = 512
radarlen_0	equ	5120
radarlen_1	equ	10240
;*********************************************************************
;*			MISSION					*
;*********************************************************************
radscale	equ	1	;(0...1times,1...2times)
sprmask	equ	$6e

smarwingR	equ	0
smarwingL	equ	1
smarwingDW	equ	2
smarwingUP	equ	3

bossmeter_cgx	equ	_obj_cgx+($80*$20/2)
;*********************************************************************
;*		BATTLE FIELD SELECT				*
;*********************************************************************
fbfs_OKAnmOpenTM	equ	2	;OK ? aicon open speed
fbfs_OKAnmCloseTM	equ	2	;OK ? aicon close speed
fbfs_OKflashTM	equ	8	;OK ? aicon flash timing

fbfs_keymaxptr	equ	4		;field select MAX pointer
fbfs_OKAnmPatNumber	equ	4		;OK ANM pattern number

; [bfs_OKflag]
fbfs_OKptrmax	equ	%00000111	;field select pointer check val
fbfs_OKInitptr	equ	%00000000	;spr init
fbfs_OKanmptr	equ	%00000001	;spr Ok anime display
fbfs_OKflashptr	equ	%00000010	;spr OK flash
fbfs_OKcancelptr	equ	%00000011	;spr OK disp cancell
fbfs_ok		equ	%00001000	;field select OK? flag
fbfs_selEND		equ	%00010000	;field select ALL OK flag
fbfs_cancel		equ	%00100000	;field select Cancel flag
fbfs_buttondisable	equ	%01000000	;button read disable flag
fbfs_keydisable	equ	%10000000	;key read disable flag

;*********************************************************************
;*		BATTLE PLAYER SELECT				*
;*********************************************************************
fbps_keymaxptr	equ	6		;field select MAX pointer

;*********************************************************************
;*			BATTLE & MISSION			*
;*********************************************************************
;============= Pause Flag ======================
;;P1pauseflag	equ	%01000000
;;P2pauseflag	equ	%10000000
;;P12pauseflag	equ	%11000000
;============= Game Clear&Over Parameter =======
P1Falt	equ	1
P2Falt	equ	2
;============= Radar parameter =================
;* yamada san ga set shiteiru radar map no 1obj no data value *
RadarMapDataVal	equ	6
;------ Flags ------------------------
;* RadarFlag (RAM)*
P1radonFl	equ	1<<0
P1radmodeFl	equ	1<<1
P1radScChFl	equ	1<<2

P2radonFl	equ	1<<4
P2radmodeFl	equ	1<<5
P2radScChFl	equ	1<<6

P12radmodeFl	equ	(P1radmodeFl)!(P2radmodeFl)

;*****************************************************************************
;*		Radar Scale Map AREA LENGTH PARAMETER			*
;*****************************************************************************
;'94/7/29
;*** Memo ***
;* -2 (  64) :radar area 40*40 = (02560*02560),obj display area 48*48 = (03072*03072)
;* -1 ( 128) :radar area 40*40 = (05120*05120),obj display area 48*48 = (06144*06144)
;*  0 ( 256) :radar area 40*40 = (10240*10240),obj display area 48*48 = (12288*12288)
;*  1 ( 512) :radar area 40*40 = (20480*20480),obj display area 48*48 = (24576*24576)
;*  2 (1024) :radar area 40*40 = (40960*40960),obj display area 48*48 = (49152*49152)

;* -2 (  64)  :radar_max = 24* 64  ( 1536),($0600)
;* -1 ( 128)  :radar_max = 24*128  ( 3073),($0c00)
;*  0 ( 256)  :radar_max = 24*256  ( 6144),($1800)
;*  1 ( 512)  :radar_max = 24*512  (12288),($3000)
;*  2 (1024)  :radar_max = 24*1024 (24576),($6000)

;------- Radar Area (10240*10240) --------
;korewa "GAME SCREEN" de deteiru 5*5 chr no RADAR desu.
;** Radar Screen wa 5chr*5chr (40dot*40dot).dakara radar no hanpen wa 40dot/2
RDscale	equ	1		;Radar Scale (1 dot = 256)
RChr	equ	5		;Radar no chracter number (5*5)
RRdot	equ	Rchr*8/2	;Radar no hankei (20 dot)
radar_max	equ	(RRdot+4)*256/RDscale 	;(24*256) (1 radar dot =256 move)*+20dot
radar_min	equ	-(RRdot+4)*256/RDscale 	;(24*256) (1 radar dot =256 move)*-20dot

;* Ring Out Waku (sprites chr) no Syoukyo Area (12288 *12288) *
;Moshi 6chr * 6chr no AREA wo koetara wakusen no sprite set wo shinai
DelWakuMax	equ	 (Rchr+1)*8*256/2/RDscale	;(1 radar dot =256 move)*+24dot
DelWakuMin	equ	-(Rchr+1)*8*256/2/RDscale 	;(1 radar dot =256 move)*-24dot

;* Battle Field Length player1*
BfWakuPtrNo1		equ	1		;0..(4*4),1..(5*5),2..(6*6),3..(7*7),4..(8*8)
BfWakuPtr1		equ	BfWakuPtrNo1*2
BFWakuChr1		equ	BfWakuPtrNo1+4	;4*4,5*5,6*6,7*7,8*8
BFWakuLength1	equ	BFWakuChr1*8*256 ;waku no 1pen no nagasa
BFWakuR1		equ	BFWakuLength1/2  ;waku no hanpen no nagasa
BFRingOutMin1	equ	-BFWakuR1	 ;ring out no plas area
BFRingOutMax1	equ	BFWakuR1	 ;ring out no minus area

p1mapoffx		equ	$000		;map no idou X
p1mapoffz		equ	$000		;map no ido Z

;* Battle Field Length player2*
BfWakuPtrNo2		equ	1		;0..(4*4),1..(5*5),2..(6*6),3..(7*7),4..(8*8)
BfWakuPtr2		equ	BfWakuPtrNo2*2	;0..(4*4),1..(5*5),2..(6*6),3..(7*7),4..(8*8)
BFWakuChr2		equ	BfWakuPtrNo2+4	;4,5,6,7,8
BFWakuLength2	equ	BFWakuChr2*8*256 ;waku no 1pen no nagasa
BFWakuR2		equ	BFWakuLength2/2  ;waku no hanpen no nagasa
BFRingOutMin2	equ	-BFWakuR2
BFRingOutMax2	equ	BFWakuR2
p2mapoffx	equ	$000
p2mapoffz	equ	$000

;****************************************************************************
nradar_hight	equ	100
mradar_hight	equ	512
fradar_hight	equ	1024

;------ Relative Radar ----------
near_rdmode	equ	1280
mid_rdmode	equ	viewradius	;R=3840
RelRadRange	equ	viewradius/RRdot ;div=192
far_rdmode	equ 	1280*2

;================ OFFSET (X,Y)================
;---- MISSION -----
missradoffx	equ	$d8
missradoffy	equ	$20-1
missradoffxy	equ	missradoffx+(missradoffy<<8)
missringoutoffx	equ	$28
missringoutoffy	equ	$28
misstargetoffx	equ	$0
misstargetoffy	equ	$0
missscoreoffx	equ	$10
missscoreoffy	equ	$18

;---- BATTLE ------
p1radoffx	equ	$1b*8
p1radoffy	equ	$06*8
p2radoffx	equ	$4*8
p2radoffy	equ	$13*8
p1radoffxy	equ	p1radoffx+(p1radoffy<<8)
p2radoffxy	equ	p2radoffx+(p2radoffy<<8)

p1scroffx	equ	$10
p1scroffY	equ	$10
p2scroffx	equ	$40
p2scroffY	equ	$78

;================ OFFSET (Charaacter)================
retmarkchr	equ	$08
aimbigchroff		equ	$0e
aimsmallchroff	equ	$0c
;============= Ring Out Parameter ==============
;------- OBJ postion --------
;p1wakuoffx	equ	p1radoffx-4
;p1wakuoffz	equ	p1radoffy-4
;p2wakuoffx	equ	p2radoffx-4
;p2wakuoffz	equ	p2radoffy-4

P1RetMarkoffX	equ	$68		;Return Mark Offset X
P1RetMarkoffY	equ	$18		;Return Mark Offset Y
P2RetMarkoffX	equ	$98
P2RetMarkoffY	equ	$80

RetMarkoffX	equ	$50		;Return Mark Offset X
RetMarkoffY	equ	$08		;Return Mark Offset Y
RoutTimeoffX	equ	$50		;Ring Out Count Offset X
RoutTimeoffY	equ	$08-1		;Ring Out Count Offset Y

P1RoutTimeoffX	equ	$60		;Ring Out Count Offset X
P1RoutTimeoffY	equ	$18-1		;Ring Out Count Offset Y
P2RoutTimeoffX	equ	$90
P2RoutTimeoffY	equ	$80-1

;------ Ring Out Time Count Chr ------
ROutTMChrUp	equ	$10
ROutTMChrDw	equ	$20

WakuChr0	equ	$3d
WakuChr1	equ	$3e
WakuChr2	equ	$3f

;============== Game Timer Parameter ==================
;------ obj xy zahyo -------------
SprM10TmOffX	equ	$13*8
SprM01TmOffX	equ	SprM10TmOffX+$08
SprSmcolOffX	equ	SprM10TmOffX+$10
SprS10TmOffX	equ	SprM10TmOffX+$18
SprS01TmOffX	equ	SprM10TmOffX+$20

SprTmOffY	equ	$c8

SprTmWkOffX	equ	$60	
SprTmWkOffY	equ	$68	
;------ character ----------------
SprTimeChr	equ	$30
SprSmFlChr	equ	$3c
SprSmNfChr	equ	$3b

SprTmWkChr	equ	$0b
;=============== Flag & Timer value ===================
;RingOutFlag&Timer
KROutFlag	equ	$80
ROIntTm	equ	10

;*********************************************************************
;*								*
;*								*
;*			BG Parameters				*
;*								*
;*********************************************************************
second	equ	15
;---------------------------------------------------------------------
;*	Mario RAM Vars & ROM Vars				*
;---------------------------------------------------------------------
;============ Flags ===============
BoostSign	equ	$40	;boost meter (b6=0 ... dec ,b6=1 ... inc)

;========= Mario RAM Vars & Rom Vars ========
cockpitbase	equ	bitmapbase+bitmap1	;Mario RAM Game Screen Top Address
p1bmbase_cgx	equ	$4c	;character No
p2bmbase_cgx	equ	$7e	;character No
p2bmbase_hosei	equ	p2bmbase_cgx-p1bmbase_cgx	

;p1cockpitbase equ	cockpitbase+((p1bmbase_cgx&%111111100)<<2+p1bmbase_cgx&3+bitmapvheight)*32
;p2cockpitbase equ	cockpitbase+((p2bmbase_cgx&%111111100)<<2+p2bmbase_cgx&3+bitmapvheight)*32

;--- Boost ---
RomBoost	equ	$0
BmBoost	equ	$6f
;--- Damage mater ---
RomdecHp	equ	$0d
RomincHp	equ	$0e
RomRedHp	equ	$0f
BmDMGMT	equ	$74
;---- Score ----
ROMScore	equ	$43
BmSCORE	equ	$4c
;-------------------------------------------------------------------

;--- KBOMSHOT ---
;BOM Window Timer&Flag
kBomShotFlag	equ	$80
BomIntTm	equ	37
;--- KHITFLASH ---
;Damage Window Timer$Flag
kdmgflag	equ	%10000000

kdmgwinflag	equ	$40
kdmgallflag	equ	$c0
DmgIntTm	equ	5
;---------------------------------------------------------------------
;------ ROM Source Character Address -----
;--- Game timer ---
RTmtop	equ	$43
RBotop	equ	$0
RSmcolFl	equ	$4f
RSmcolnoFl	equ	$4e
;============= Dest Address to copy Mario RAM ==============
;--- Game Timer ----
BmTm10min	equ	$a4+$10	;10 minutes
BmTm01min	equ	$a5+$10	;01 minutes
Bmtmsemcol	equ	$a6+$10	;semicolon
Bmtm10sec	equ	$a7+$10	;10 seconds
Bmtm01sec	equ	$a8+$10	;01 seconds

;================ Window Parameter ====================
;-------- Window Flags -----------
Pl1WinFlag	equ	$3

;-------- Window potion ----------
MissWinXSta	equ	$10	   ;L
MissWinXEnd	equ	$10+($1c*8);R
MissWinYSta	equ	$10
MissWinYEnd	equ	$70
MissWinLine	equ	MissWinYEnd-MissWinYSta

P1WinXSta	equ	$10	;L
P1WinXEnd	equ	$c0	;R
P1WinYSta	equ	$10
P1WinYEnd	equ	$70	
P1WinLine	equ	P1WinYEnd-P1WinYSta

P2WinXSta	equ	$40
P2WinXEnd	equ	$f0
P2WinYSta	equ	$78
P2WinYEnd	equ	$d8	
P2WinLine	equ	P2WinYEnd-P2WinYSta

;---- HIT FLASH ----
MissHtflSta	equ	$10
MissHtflEnd	equ	$10+($1c*8)-1

P1HtFlXSta	equ	$10
P1HtFlXEnd	equ	$bf
P2HtFlXSta	equ	$40
P2HtFlXEnd	equ	$ef

NoWinXSta	equ	$1	;Cancel window data Left
NoWinXEnd	equ	$0	;Cancel Window Data Right
;---------- Value ------------------
LineNumber8	equ	8

;*********************************************************************
;*								*
;*		Controller Parameters				*
;*								*
;*********************************************************************
;============ TEMPORARY KEY ================

pad_UDLR		equ	pad_UP!pad_DOWN!pad_LEFT!pad_RIGHT
padl_UDLR		equ	padl_UP!padl_DOWN!padl_LEFT!padl_RIGHT
pad_UD		equ	pad_UP!pad_DOWN
padl_UD		equ	padl_UP!padl_DOWN
pad_Dsel		equ	pad_DOWN!pad_Select
padl_DSel		equ	padl_DOWN!padl_Select
pad_LR		equ	pad_LEFT!pad_RIGHT
padl_LR		equ	padl_LEFT!padl_RIGHT
pad_TLR		equ	pad_TLEFT!pad_TRIGHT
padl_TLR		equ	padl_TLEFT!padl_TRIGHT

pad_OK		equ	pad_B!pad_start
padl_OK		equ	padl_B!padl_start

pad_kettei		equ	pad_B
padl_kettei		equ	padl_B

pad_CANCEL		equ	pad_X!pad_Y
padl_CANCEL		equ	padl_X!padl_Y

pad_SPECIAL		equ	pad_A
padl_SPECIAL		equ	padl_A

pad_Pause		equ	pad_start
padl_Pause		equ	padl_start

pad_PREV		equ	pad_B!pad_TRight
padl_PREV		equ	padl_B!padl_TRight

pad_democancel	equ	pad_start!pad_b
padl_democancel	equ	padl_start!pad_b

;============ SPECIAL KEY ================
pad_stageclear	equ	pad_TRight!pad_A!pad_B!pad_Y
padl_stageclear	equ	padl_TRight!padl_A!padl_B!padl_Y

pad_playerdown	equ	pad_TLR!pad_A!pad_Y
padl_playerdown	equ	padl_TLR!padl_A!padl_Y

pad_RESET		equ	pad_TLR!pad_select!pad_start
padl_RESET		equ	padl_TLR!padl_select!padl_start

pad_timeup		equ	pad_TLR!pad_select!pad_right
padl_timeup		equ	padl_TLR!padl_select!padl_right

pad_gameover		equ	pad_TLR!pad_select!pad_left
padl_gameover	equ	padl_TLR!padl_select!padl_left


pad_bossappear	equ	pad_TLR!pad_select!pad_right
padl_bossappear	equ	padl_TLR!padl_select!padl_right

pad_bg1	equ	pad_UP!pad_select
padl_bg1	equ	padl_UP!padl_select
pad_bg2	equ	pad_Right!pad_select
padl_bg2	equ	padl_Right!padl_select
pad_bg3	equ	pad_Left!pad_select
padl_bg3	equ	padl_Left!padl_select
pad_obj	equ	pad_Down!pad_select
padl_obj	equ	padl_Down!padl_select
pad_bgall	equ	pad_Tleft!pad_select
padl_bgall	equ	padl_Tleft!padl_select
pad_bgclr	equ	pad_TRight!pad_select
padl_bgclr	equ	padl_TRight!padl_select
pad_enemygone	equ	pad_A!pad_B
padl_enemygone	equ	padl_A!padl_B


autokeywaittm	equ	5
triggerrepeat	equ	10

triggerflag		equ	%10000000
;*********************************************************************
;*								*
;*				MOJI				*
;*								*
;*********************************************************************
moji_a	equ	$00
moji_b	equ	$01
moji_c	equ	$02
moji_d	equ	$03
moji_e	equ	$04
moji_f	equ	$05
moji_g	equ	$06
moji_h	equ	$07
moji_i	equ	$08
moji_j	equ	$09
moji_k	equ	$0a
moji_l	equ	$0b
moji_m	equ	$0c
moji_n	equ	$0d
moji_o	equ	$0e
moji_p	equ	$0f
moji_q	equ	$10
moji_r	equ	$11
moji_s	equ	$12
moji_t	equ	$13
moji_u	equ	$14
moji_v	equ	$15
moji_w	equ	$16
moji_x	equ	$17
moji_y	equ	$18
moji_z	equ	$19

number_0	equ	$00
number_1	equ	$01
number_2	equ	$02
number_3	equ	$03
number_4	equ	$04
number_5	equ	$05
number_6	equ	$06
number_7	equ	$07
number_8	equ	$08
number_9	equ	$09
;---------------------------------------------------------------------------
gamemoji_base	equ	$a0
gamenumber_base	equ	$30

gamenumber_0	equ	gamenumber_base+number_0
gamenumber_1	equ	gamenumber_base+number_1
gamenumber_2	equ	gamenumber_base+number_2
gamenumber_3	equ	gamenumber_base+number_3
gamenumber_4	equ	gamenumber_base+number_4	
gamenumber_5	equ	gamenumber_base+number_5
gamenumber_6	equ	gamenumber_base+number_6	
gamenumber_7	equ	gamenumber_base+number_7
gamenumber_8	equ	gamenumber_base+number_8	
gamenumber_9	equ	gamenumber_base+number_9

gamemoji_a	equ	gamemoji_base+moji_a
gamemoji_b	equ	gamemoji_base+moji_b
gamemoji_c	equ	gamemoji_base+moji_c
gamemoji_d	equ	gamemoji_base+moji_d
gamemoji_e	equ	gamemoji_base+moji_e
gamemoji_f	equ	gamemoji_base+moji_f
gamemoji_g	equ	gamemoji_base+moji_g
gamemoji_h	equ	gamemoji_base+moji_h
gamemoji_i	equ	gamemoji_base+moji_i
gamemoji_j	equ	gamemoji_base+moji_j
gamemoji_k	equ	gamemoji_base+moji_k
gamemoji_l	equ	gamemoji_base+moji_l
gamemoji_m	equ	gamemoji_base+moji_m
gamemoji_n	equ	gamemoji_base+moji_n
gamemoji_o	equ	gamemoji_base+moji_o
gamemoji_p	equ	gamemoji_base+moji_p
gamemoji_q	equ	gamemoji_base+moji_q
gamemoji_r	equ	gamemoji_base+moji_r
gamemoji_s	equ	gamemoji_base+moji_s
gamemoji_t	equ	gamemoji_base+moji_t
gamemoji_u	equ	gamemoji_base+moji_u
gamemoji_v	equ	gamemoji_base+moji_v
gamemoji_w	equ	gamemoji_base+moji_w
gamemoji_x	equ	gamemoji_base+moji_x
gamemoji_y	equ	gamemoji_base+moji_y
gamemoji_z	equ	gamemoji_base+moji_z

gamemojiBU_a	equ	$60
gamemojiBD_a	equ	$70
gamemojiBU_c	equ	$61
gamemojiBD_c	equ	$71
gamemojiBU_d	equ	$62
gamemojiBD_d	equ	$72
gamemojiBU_e	equ	$63
gamemojiBD_e	equ	$73
gamemojiBU_g	equ	$64
gamemojiBD_g	equ	$74
gamemojiBU_i	equ	$65
gamemojiBD_i	equ	$75
gamemojiBU_l	equ	$66
gamemojiBD_l	equ	$76
gamemojiBU_m	equ	$67
gamemojiBD_m	equ	$77
gamemojiBU_o	equ	$69
gamemojiBD_o	equ	$79
gamemojiBU_r	equ	$6a
gamemojiBD_r	equ	$7a
gamemojiBU_s	equ	$6b
gamemojiBD_s	equ	$7b
gamemojiBU_t	equ	$6c
gamemojiBD_t	equ	$7c
gamemojiBU_x	equ	$6d
gamemojiBD_x	equ	$7d
;---------------------------------------------------------------------------
bossmoji_base	equ	$80

bossmoji_a	equ	bossmoji_base+moji_a
bossmoji_b	equ	bossmoji_base+moji_b
bossmoji_c	equ	bossmoji_base+moji_c
bossmoji_d	equ	bossmoji_base+moji_d
bossmoji_e	equ	bossmoji_base+moji_e
bossmoji_f	equ	bossmoji_base+moji_f
bossmoji_g	equ	bossmoji_base+moji_g
bossmoji_h	equ	bossmoji_base+moji_h
bossmoji_i	equ	bossmoji_base+moji_i
bossmoji_j	equ	bossmoji_base+moji_j
bossmoji_k	equ	bossmoji_base+moji_k
bossmoji_l	equ	bossmoji_base+moji_l
bossmoji_m	equ	bossmoji_base+moji_m
bossmoji_n	equ	bossmoji_base+moji_n
bossmoji_o	equ	bossmoji_base+moji_o
bossmoji_p	equ	bossmoji_base+moji_p
bossmoji_q	equ	bossmoji_base+moji_q
bossmoji_r	equ	bossmoji_base+moji_r
bossmoji_s	equ	bossmoji_base+moji_s
bossmoji_t	equ	bossmoji_base+moji_t
bossmoji_u	equ	bossmoji_base+moji_u
bossmoji_v	equ	bossmoji_base+moji_v
bossmoji_w	equ	bossmoji_base+moji_w
bossmoji_x	equ	bossmoji_base+moji_x
bossmoji_y	equ	bossmoji_base+moji_y
bossmoji_z	equ	bossmoji_base+moji_z

;---------------------------------------------------------------------------
confmoji_base	equ	$a
conf_0	equ	0
conf_1	equ	1
conf_2	equ	2
conf_3	equ	3
conf_4	equ	4
conf_5	equ	5
conf_6	equ	6
conf_7	equ	7
conf_8	equ	8
conf_9	equ	9
conf_a	equ	confmoji_base+moji_a
conf_b	equ	confmoji_base+moji_b
conf_c	equ	confmoji_base+moji_c
conf_d	equ	confmoji_base+moji_d
conf_e	equ	confmoji_base+moji_e
conf_f	equ	confmoji_base+moji_f
conf_g	equ	confmoji_base+moji_g
conf_h	equ	confmoji_base+moji_h
conf_i	equ	confmoji_base+moji_i
conf_j	equ	confmoji_base+moji_j
conf_k	equ	confmoji_base+moji_k
conf_l	equ	confmoji_base+moji_l
conf_m	equ	confmoji_base+moji_m
conf_n	equ	confmoji_base+moji_n
conf_o	equ	confmoji_base+moji_o
conf_p	equ	confmoji_base+moji_p
conf_q	equ	confmoji_base+moji_q
conf_r	equ	confmoji_base+moji_r
conf_s	equ	confmoji_base+moji_s
conf_t	equ	confmoji_base+moji_t
conf_u	equ	confmoji_base+moji_u
conf_v	equ	confmoji_base+moji_v
conf_w	equ	confmoji_base+moji_w
conf_x	equ	confmoji_base+moji_x
conf_y	equ	confmoji_base+moji_y
conf_z	equ	confmoji_base+moji_z

conf_bar	equ	$24
conf_cursor	equ	$25
