;  ##################
;  #                #
;  # Assembly Flags #
;  #                #
;  ##################

cesdemo				equ	0	; 0 is normal, 1/2 (unused)
janglish			equ	0	; 0 = english, 1 = japanese
cestime				equ	4	; ces countdown (in minutes) (unused)
pal					equ	0	; PAL/NTSC (1/0)
contest				equ	0	; contest version (unused)
german				equ	0	; german version  (unused)
french				equ	0	; french version  (unused)
fast				equ	1	; 21Mhz
CacheOn				equ	1	; Super FX chip cache on/off
cesboot				equ	0	; WCES 1995 "Nintendo Presents" screen
lockondef			equ 0	; Enable Lock-On by default
forceeasyandross	equ 0	; Force normal mode Andross on all difficulties
forcenormalandross	equ 0	; Force hard mode Andross on all difficulties
forcehardandross	equ 0	; Force expert mode Andross on all difficulties
expertbydefault		equ 0	; enable expert mode by default
walkertwirl			equ 0	; enable walker twirl from WCES 1995 (note: egdata is now in bank 36)
spaceviewchange		equ	0	; enable changing view in space like in the Aeon Genesis English Translation

nosecuritychk		equ	0	; disable region/controller port checks on boot

DamageHalf			equ 0	; Any damage taken is reduced by half.

kyear				equ	96	; 95/96/97/17 = 1995/1996/1997/2017

; debugging:

debuginfo		equ	1	; full strategy debugging
debuginfo2		equ	1 	; stage selection/ speed up mode
portinfo		equ	0	; 0/1 ... sound port display off/on 
randominfo		equ	0	; 0/1 ... random on/off
demoinfo		equ	0	; 0/1 ... polygon demo on / off
blockmap_dbg	equ	0	; display map blockmap?
pathcount		equ	0	; display amount of path commands executed
sos_test_egu	equ	0	; 0=off/1=on test mode Set SOS1 and SOS2.
polllaginfo		equ	0	; display cycles used up while polling mario chip
enableconfig		equ	1	; restores sound test replacing the stereo/mono menu option (note: config is now in bank 36)
configimprovements	equ	1	; improvements to the sound test such as track number wrapping to/from last track and changed songlist
configcursorsound	equ	0	; enable cursor sound like in vanilla

;	###############################################################
;	## to tweak other aspects of the game, see INC/GAMELIST.INC. ##
;	###############################################################

; user list:

user_anyone		equ	0
user_dylan		equ	1
user_kawaguchi	equ	2
user_kawagoe	equ	3
user_eguchi		equ	4
user_yamada		equ	5
user_giles		equ	6
user_noone		equ	7
user_yajima		equ	8
  
; current user:
; Get current user from environment variable (starfoxuser)

	string	username[40]

	IFNV	"starfoxuser"
	string	username="Noone"
	ELSEIF
	getenv	username="starfoxuser"
	ENDC

	run	"user equ user_%$username"

;  #######################
;  #                     #
;  # Version Definitions #
;  #                     #
;  #######################

	STRING	version[80]

; define the 'version' string from the above variables.

	IFEQ	JANGLISH
	IFEQ	PAL
	defs	version,"US"
	STRING	version_name[32]="STARFOX2             "
	ELSEIF
	IFEQ	GERMAN+FRENCH
	defs	version,"UK"
	STRING	version_name[32]="STARWING2            "
	ENDC
	IFNE	GERMAN
	defs	version,"GERMAN"
	STRING	version_name[32]="STARWING2            "
	ENDC
	IFNE	FRENCH
	defs	version,"FRANCE"
	STRING	version_name[32]="STARWING2            "
	ENDC
	ENDC
	ELSEIF
	defs	version,"JAPAN"
	STRING	version_name[32]="STARFOX2             "
	ENDC

	IFEQ	PAL
	defs	version,"%$version/NTSC"
	ELSEIF
	defs	version,"%$version/PAL"
	ENDC

	IFNE	CONTEST
	defs	version,"%$version/CONTEST"
	ENDC

	IFNE	CESDEMO
	IFEQ	CESDEMO-1
	defs	version,"%$version/CESDEMO #1"
	ELSEIF
	defs	version,"%$version/CESDEMO #2"
	ENDC
	ENDC

	IFNE	debuginfo&debuginfo2
	defs	version,"%$version/FULL DEBUG"
	ELSEIF

	IFNE	debuginfo
	defs	version,"%$version/STRATEGY DEBUG"
	ENDC

	IFNE	debuginfo2
	defs	version,"%$version/SIMPLE DEBUG"
	ENDC
	ENDC

	IFNE	fast
	defs	version,"%$version/21Mhz"
	ELSEIF
	defs	version,"%$version/10#Mhz"
	ENDC

	printf	"%01%32-- Generating %$version version for %$username --%00%n"




;  ##################### 
;  #                   #
;  # Angle Definitions #
;  #                   #
;  #####################

deg360	equ	256
deg180	equ	deg360/2
deg90	equ	deg360/4
deg45	equ	deg360/8
deg22	equ	deg360/16
deg11	equ	deg360/32
deg5	equ	deg360/64
deg270	equ	deg180+deg90
deg0	equ	0
deg120	equ	deg360/3
deg60	equ	deg120/2
deg240	equ	deg120*2
deg300	equ	deg240+deg60

deg135	equ	deg90+deg45
deg225	equ	deg180+deg45
deg315	equ	deg180+deg90+deg45

deg72	equ	deg360/5
deg144	equ	(deg360*2)/5
deg216	equ	(deg360*3)/5
deg288	equ	(deg360*4)/5


;  ###################
;  #                 #
;  # Processor Flags #
;  #                 #
;  ###################

p_n	equ	10000000b
p_v	equ	01000000b
p_a	equ	00100000b
p_x	equ	00010000b
p_d	equ	00001000b
p_int	equ	00000100b
p_z	equ	00000010b
p_c	equ	00000001b



;  #################
;  #               #
;  # Key Pad Codes #
;  #               #
;  #################

pad_B	equ	1<<15
pad_Y	equ	1<<14
pad_SELECT	equ	1<<13
pad_START	equ	1<<12
pad_UP	equ	1<<11
pad_DOWN	equ	1<<10
pad_LEFT	equ	1<<9
pad_RIGHT	equ	1<<8
pad_A	equ	1<<7
pad_X	equ	1<<6
pad_TLEFT	equ	1<<5
pad_TRIGHT	equ	1<<4

padl_B	equ	pad_B>>8
padl_Y	equ	pad_Y>>8
padl_SELECT	equ	pad_SELECT>>8
padl_START	equ	pad_START>>8
padl_UP	equ	pad_UP>>8
padl_DOWN	equ	pad_DOWN>>8
padl_LEFT	equ	pad_LEFT>>8
padl_RIGHT	equ	pad_RIGHT>>8
padl_A	equ	pad_A
padl_X	equ	pad_X
padl_TLEFT	equ	pad_TLEFT
padl_TRIGHT	equ	pad_TRIGHT


;  #############################
;  #                           #
;  # Miscellaneous Definitions #
;  #                           #
;  #############################

NULL	equ	0
TRUE	equ	-1
FALSE	equ	0

WM	equ	$ffff
BM	equ	$ff

K	equ	1024

RadarON_OFF	equ	0	:Sprites Radar	       :0..on,1..off

P1radar	equ	0	;Player 1 Radar	:0..absolute,1..relative
P2radar	equ	0	;Player 2 Radar :0..absolute,1..relative

st_GROUND	equ	0	; slope type definitions
st_WATER	equ	1
st_ICE	equ	2
st_GRASS	equ	3
st_MAGMA	equ	4
st_SAND	equ	5
st_WALL	equ	6

bitmapbase	equ	$700000

mramsize	equ	65536	; amount of mario chip ram onboard


MAGIC_Y	equ	8192	; magic Y for ground level (to allow slopes to dip into the ground)

bank13_split	equ	16384-4096-300


;-------------------------------------
; --- flags for defining text output

tdflag_FLASH =	1<<4
tdflag_LARGE =	1<<5
tdflag_SMALL	=	1<<6
tdflag_SPECIAL =	1<<7

; --- colour equates

tdcol_BLACK	=	0
tdcol_RED	=	1
tdcol_LIGHTRED =	2
tdcol_ORANGE	=	3
tdcol_YELLOW	=	4
tdcol_BLUE	=	5
tdcol_LIGHTBLUE =	6
tdcol_CYAN	=	7
tdcol_LIGHTCYAN =	8
tdcol_DARKGREY =	9
tdcol_GREY1	=	10
tdcol_GREY2	=	11
tdcol_GREY3	=	12
tdcol_LIGHTGREY =	13
tdcol_WHITE	=	14
tdcol_GREEN	=	15

;  ##################################
;  #                                #
;  # Equates For training screen    #
;  #                                #
;  ##################################

bitmapwidth_tr	equ	22
bitmapheight_tr	equ	24
bitmapvheight_tr	equ	12

player1_wx_tr	equ	2	; x position of player 1's window
player1_wy_tr	equ	2	; x position of player 1's window

;  ##################################
;  #                                #
;  # Equates For 3d glasses Bitmaps #
;  #                                #
;  ##################################

bitmapwidth_3d	equ	22
bitmapheight_3d	equ	16
bitmapvheight_3d	equ	16

player1_wx_3d	equ	5	; x position of player 1's window
player1_wy_3d	equ	2	; x position of player 1's window

;  ##################################
;  #                                #
;  # Equates For One Player Bitmaps #
;  #                                #
;  ##################################

bitmapwidth_1	equ	28
bitmapheight_1	equ	24
bitmapvheight_1 equ	24	; visible height

bitmapwidth_1c	equ	28
bitmapheight_1c	equ	24
bitmapvheight_1c	equ	18	; visible height

bitmapsize_1	=	bitmapheight_1*8*bitmapwidth_1*4
bitmap1	equ	16384 mramsize-bitmapsize_1	; player 1's bit map
bitmap1_1	equ	bitmap1
bitmap1_dbl	equ	(mramsize-bitmap1)/2+bitmap1

player1_wx_1		equ	2	; x position of player 1's window
player1_wy_1		equ	2	; x position of player 1's window
player1_wx_1c	equ	2	; x position of player 1's window
player1_wy_1c	equ	2	; x position of player 1's window

;  ##################################
;  #                                #
;  # Equates For Two Player Bitmaps #
;  #                                #
;  ##################################

bitmapwidth	equ	22
bitmapheight	equ	16
bitmapvheight equ	12	; visible height

bitmapsize	=	bitmapheight*8*bitmapwidth*4
;bitmap1	equ	mramsize-bitmapsize*2	; player 1's bit map
bitmap2	equ	bitmap1+bitmapsize	; player 2's bit map

player1_wx	equ	2	; x position of player 1's window
player2_wx	equ	8	; x position of player 2's window

player1_wy	equ	2	; x position of player 1's window
player2_wy	equ	player1_wy+bitmapvheight+1	; x position of player 2's window






;  #####################################
;  #                                   #
;  # VRAM Layout For Two Player Screen #
;  #                                   #
;  #####################################

_bg1_cgx1	equ	(0*k)/2
_bg1_cgx2	equ	(24*k)/2

_bg1_scr	equ	(22*k)/2

_bg2_cgx	equ	(56*k)/2
_bg2_scr	equ	(46*k)/2

_obj_cgx	equ	(50*k)/2


; horizontal and vertical offsets are at bg1_cgx1 and bg1_cgx2

_hvofs_base1 equ	_bg1_cgx1+(24*k-256)/2
_hvofs_base2 equ	_bg1_cgx1+(24*k-128)/2

_bg1_cgx1_real equ	_bg1_cgx1	;+128/2
_bg1_cgx2_real equ	_bg1_cgx2	;+128/2

_cockpit_cgx1	equ	_bg1_cgx1_real+bitmapsize
_cockpit_cgx2	equ	_bg1_cgx2_real+bitmapsize

_bg1_firstchar equ	(_bg1_cgx1_real-_bg1_cgx1)/16

; VRAM lengths:

cockpit_cgx_len equ	10*k

bg2_cgx_len	equ	8*k
bg2_scr_len	equ	4*k


;  #####################################
;  #                                   #
;  # Base Addresses For RAM Allocation #
;  #                                   #
;  #####################################

zmempt	=	0	;zero page
wmempt	=	$300	;work space
xmempt	=	$7e2000	;extended RAM
xxmempt	=	$7f0000	;extended RAM
zmmempt	=	$700000
mmempt	=	$700200



;  ########################
;  #                      #
;  # Game Limit Variables #
;  #                      #
;  ########################

number_al	equ	60	;52		;Max aliens
number_zb	equ	number_al	;Max z srot blocks
number_inert	equ	512
number_debug	equ	50
rangeradius	equ	800		; scale oblivious radius for map generation
viewradius	equ	400		; scale oblivious radius for view
snddist_near	equ	800		; sound distance check length (near)
snddist_far	equ	1300		; sound distance check length (far)
snddist_view	equ	2560		; sound view radius
number_hl	equ	number_al	; number of items allowed in hitlist
number_ob	equ	20		; number of sprites on map screen
ols_maxlinks	equ	20		; max number of linked objects
number_area	equ	24
removal_leeway	equ	500	; leeway for removal of objects from sight
MAXMAPRANGE	equ	12000		; Absolute maximum distance of visible objects
number_turbosprites equ	40	; Forty turbo sprites allowed
number_highscores	equ	5	; number of high scores

blockmap_Resolution equ 512		; resolution of map solid blockmap
blockmap_numblocks  equ 65536/blockmap_Resolution



;  ##########################
;  #                         #
;  # Collision Box Hit Flags ##
;  #                         ##
;  ###########################
;   ###########################

HF1	equ	1<<0
HF2	equ	1<<1
HF3	equ	1<<2
HF4	equ	1<<3
HF5	equ	1<<4
HF6	equ	1<<5
HF7	equ	1<<6
HF8	equ	1<<7

;  ########################
;  #                      #
;  # Decruncher Variables #
;  #                      #
;  ########################

dec_base	equ	bitmap1-1200	;2800h
palettes_base equ	dec_base+13000



;  ########################
;  #                      #
;  # BG variables         #
;  #                      #
;  ########################



scr_offset	equ	0	;(vchr_logback-vchr_physback)/16

if_vofson	equ	1
if_hofson	equ	2
if_zroton	equ	4
if_ground	equ	8
if_space	equ	16
if_snow	equ	32
if_pollen	equ	64


;---------------------------------------------------------------
;---------------------------------------------------------------
;---------------------------------------------------------------


;  ########################
;  #                      #
;  # Clipping planes      #
;  #                      #
;  ########################


plane_OFF	equ	0
plane_GROUND	equ	1
plane_POOL1	equ	2
plane_POOL2	equ	3
plane_BOSS	equ	4
plane_BOSS2	equ	5
plane_BOSS3	equ	6
plane_BOSS4	equ	7
















;-------------------------------------------------------------
;-------------------------------------------------------------
;-------------------------------------------------------------
;-------------------------------------------------------------
;-------------------------------------------------------------
;-------------------------------------------------------------
;-------------------------------------------------------------











wallhgt	equ	120
walldist	equ	60+10

dma_clr_screen equ	1	; 0/1 off/on
mario_test	equ	0
mario_test1	equ	0
mario_board	equ	1
FastTrans	equ	0	; 0/1 0ff/on Fast transfer

mario_stats3d	equ	0

mario_showobj equ	1
mario_spr_demo equ	1
easytext	equ	0

min_lockon	equ	8


disableobj	equ	0

soundon	equ	1

mario_sph_demo	equ	0


;Key pad Codes		(ends in l = in contl0)
Key_al	equ	$80
Key_b	equ	$80
key_xl	equ	$40
key_y	equ	$40
key_start	equ	$10
key_select	equ	$20
key_leftl	equ	$20
key_rightl	equ	$10
key_jup	equ	$08
key_jdown	equ	$04
key_jleft	equ	$02
key_jright	equ	$01










gameNum_col		equ	28
gameNum_row		equ	24

vchr_base1		equ	0
vsc_base1		equ	22*k/2
vchr_base2		equ	24*k/2
vchr_physback	equ	40*k/2
vchr_logback	equ	46*k/2
vobj_base		equ	52*k/2
vsc_base2		equ	56*k/2
bg2offsets		equ	vsc_base1+32*28

num_col	equ	28
num_row	equ	24
char_size	equ	32
col_size	equ	char_size*bitmapheight
usedchar	equ	col_size*num_col
pal3d	equ	7



;alien flags (al_flags) -------
afexp	equ	1	;Exploding
afInRngPl	equ	2	;In Range of player
afLeftPl	equ	4	;Left of player
afFrontPl	equ	8	;Infront of Player
afInviewPl	equ	16	;Inview of player
afhit	equ	32	;was hit/ shot/blasted/bumped
afonfire	equ	64	;on fire

;alien type flags (al_type) ---
atgnd	equ	1	;ground object
atmissile	equ	2	;Is misslie
atlaser	equ	4	;Is laser bolt
atzremove	equ	8	;remove when behind
atnuked	equ	16	;if hit by nuke explosion.

;player machine flags (macflags 16 bit)
MACFEXISTS	equ	1
MACFRELAXIS	equ	2


; planets.asm
num_routes	equ	4


; main
GROUND_MODE	equ	1
SPACE_MODE	equ	2
WATER_MODE	equ	4

xhdma_max	equ	5*K

mapbase	=	$58000
mapbase2	=	$d8000


; continue.asm

friend_fox	equ	0
friend_rabbit equ	1
friend_peppy	equ	1
friend_falcon equ	2
friend_falco	equ	2
friend_frog	equ	3
friend_slippy equ	3
friend_pepper equ	4
friend_andross equ	5
friend_pepper2 equ	6
friend_girl1	equ	7
friend_girl2	equ	8
friend_explain	equ	9
friend_wolf		equ	10
friend_pig		equ	11
friend_monkey	equ	12
friend_chameleon	equ	13
friend_anyone	equ	14

friend_fox3	equ	0+128
friend_rabbit3 equ	1+128
friend_falcon3 equ	2+128
friend_frog3	equ	3+128
friend_pepper3 equ	4+128
friend_andross3 equ	5+128
friend_anyone3 equ	6+128


sound_other	equ	0
sound_down	equ	1
sound_help	equ	2
sound_special equ	3


; sprites.asm
spradd	equ	128	;((24*28)-512+2)

; trans
gamechar_size	equ	32
gamemdm		equ	1+32
gameStRow		equ	2

; position to turn screen off:
gameVW_Pos		equ	192+16	;220

; position to turn screen on
gameVW_Pos2		equ	14


; position to turn the screen off for a few lines during credits
techdata_Pos		equ	150
techdata_Pos2	equ	gamevw_pos2+40	; position at top of screen


gamemtrans		equ	((262-gameVW_Pos+8*gameStRow)*170)&(-30)
gameBMPSZ		equ	gameNum_col*gameNum_row*gamechar_size
		ifge	gamemtrans-gameBMPSZ
gamemaxtrans	equ	gameBMPSZ/2
		elseif
gamemaxtrans	equ	gamemtrans
		endc
gametranlen1	equ	10752
gametranlen2	equ	10752
paltranlen1	equ	(gamemaxtrans*3)/4
paltranlen2	equ	gamemaxtrans-paltranlen1

; irq vars
tm_planets	equ	8
tm_fox	equ	10
tm_fox2	equ	12
tm_fox3	equ	14
tm_planets2	equ	34

; Date and Time
	TIME	_TIME
_HOUR	=	_TIME>>24&$FF
_MIN	=	_TIME>>16&$FF



