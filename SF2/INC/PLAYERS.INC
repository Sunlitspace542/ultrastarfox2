;������Ŀ
;�MAX HP�
;��������	; max 40

maxHP_FOX	equ	32
maxHP_FALCO	equ	32
maxHP_PEPPY	equ	40
maxHP_SLIPPY	equ	40
maxHP_GAL1	equ	24
maxHP_GAL2	equ	24

;���������������Ŀ
;�TAME DAMA METER�	; max 40
;�����������������

maxMETER_FOX		equ	30-5
maxMETER_FALCO	equ	30-5
maxMETER_PEPPY	equ	40-5
maxMETER_SLIPPY	equ	40-5
maxMETER_GAL1	equ	15-5
maxMETER_GAL2	equ	15-5

;����������������������Ŀ
;�Default special weapon�
;������������������������

SPWEAP_FOX		equ	spweap_bomb
SPWEAP_FALCO		equ	spweap_bomb
SPWEAP_PEPPY		equ	spweap_heal
SPWEAP_SLIPPY	equ	spweap_heal
SPWEAP_GAL1		equ	spweap_shield
SPWEAP_GAL2		equ	spweap_shield

;���������������������Ŀ
;�Num of Special weapon�
;�����������������������

SPWEAPnum_FOX	equ	3
SPWEAPnum_FALCO	equ	3
SPWEAPnum_PEPPY	equ	3
SPWEAPnum_SLIPPY	equ	3
SPWEAPnum_GAL1	equ	3
SPWEAPnum_GAL2	equ	3




;����������������Ŀ
;� LOCK ON SYSTEM �
;������������������

lock_width	equ	20h	; (+-) lock suru hanni
lock_height	equ	20h	; (+-) lock suru hanni
lock_time	equ	0	; lock suru madeno jikan
lock_time2	equ	0ah	; lock suru madeno jikan

;���������������������������Ŀ
;� ARWING no ironna position �
;�����������������������������

;ARWING

wingheady_FF		equ	15	;wing no sakittyo(y)
wingheady_GG		equ	20
wingheady_SP		equ	20

wingheadz_FF		equ	-40	;wing no sakittyo(z)
wingheadz_GG		equ	-50
wingheadz_SP		equ	-40

rwingheadx_FF	equ	35	;migi no wing no sakittyo(x)
rwingheadx_GG	equ	15
rwingheadx_SP	equ	35

noseheadz_FF		equ	80	;sakippo(z)
noseheadz_GG		equ	80
noseheadz_SP		equ	45

; gunblaze pos
blazez_FF	equ	80
blazez_SP	equ	80
blazez_GG	equ	35

Tblazex_FF	equ	30
Tblazex_SP	equ	30
Tblazex_GG	equ	30

Tblazez_FF	equ	0
Tblazez_SP	equ	0
Tblazez_GG	equ	0

;ARMER

jetofsx_FF		equ	15	;25
jetofsx_GG		equ	15	;25
jetofsx_SP		equ	22	;30

jettailx_FF		equ	27	;arm no yoko offset(x)
jettailx_SP		equ	30
jettailx_GG		equ	20

jettailz_FF		equ	-10	;arm no usiro(z)
jettailz_SP		equ	-10
jettailz_GG		equ	-10

jetheadz_FF		equ	30	;arm no sakippo
jetheadz_SP		equ	30
jetheadz_GG		equ	45

;ROBOT

ashiofsy_FF		equ	0
ashiofsy_SP		equ	0
ashiofsy_GG		equ	0

;----------------------------------------------------------------------------------

;-- work ram --

work0	equ	twork+0		;16bit
work1	equ	twork+2		;16bit
work2	equ	twork+4		;16bit
work3	equ	twork+6		;16bit
work4	equ	twork+8		;16bit
work5	equ	twork+10	;16bit
work6	equ	twork+12	;16bit
work7	equ	twork+14	;16bit
work8	equ	twork+16	;16bit
work9	equ	twork+18	;16bit
X1c	equ	twork+20	;16bit
Y1c	equ	twork+22	;16bit
Z1c	equ	twork+24	;16bit
work_mx	equ	twork+26	;16bit
work_mz	equ	twork+28	;16bit

;----------------------------------------------------------------------------------

;	�������������������ͻ
;	�                   �
;	�Player no parameter�
;	�                   �
;	�������������������ͼ

;�����������ͻ
;�Arwing mode�
;�����������ͼ

; normal mode

OF_AW_ROTYOFSinc	equ	2*256

OF_AW_ROTYOFS_FOX	equ	8*3	; roty offset when push lr
OF_AW_ROTYOFS_FALCO	equ	8*2	; roty offset when push lr
OF_AW_ROTYOFS_PEPPY	equ	8*1	; roty offset when push lr
OF_AW_ROTYOFS_SLIPPY	equ	8*1	; roty offset when push lr
OF_AW_ROTYOFS_GAL1	equ	8*3	; roty offset when push lr
OF_AW_ROTYOFS_GAL2	equ	8*3	; roty offset when push lr

; no turn mode

OF_AW_ROTYOFSnoturn_FOX	equ	8*3	; roty offset when push lr
OF_AW_ROTYOFSnoturn_FALCO	equ	8*3	; roty offset when push lr
OF_AW_ROTYOFSnoturn_PEPPY	equ	8*3	; roty offset when push lr
OF_AW_ROTYOFSnoturn_SLIPPY	equ	8*3	; roty offset when push lr
OF_AW_ROTYOFSnoturn_GAL1	equ	8*3	; roty offset when push lr
OF_AW_ROTYOFSnoturn_GAL2	equ	8*3	; roty offset when push lr

OF_AW_XOFSVEL_FOX	equ	40
OF_AW_XOFSVEL_FALCO	equ	40	;90
OF_AW_XOFSVEL_PEPPY	equ	40	;30
OF_AW_XOFSVEL_SLIPPY	equ	40	;40
OF_AW_XOFSVEL_GAL1	equ	40	;10
OF_AW_XOFSVEL_GAL2	equ	40	;10

.armer

OF_AM_ROTYOFS	equ	8	; roty offset when push lr
OF_AM_ROTYOFSnoturn	equ	8	; roty offset when push lr

;��������������Ŀ
;� normal speed �
;� [ 0-127 ]    �
;� normal = 35  �
;����������������

speed_awFOX		equ	40
speed_awFALCO	equ	42
speed_awPEPPY	equ	32
speed_awSLIPPY	equ	30
speed_awGAL1		equ	48
speed_awGAL2		equ	50

;�����������������Ŀ
;� space no  speed �
;� [ 0-127 ]       �
;� normal = ??     �
;�������������������

speedspace_awFOX	equ	30
speedspace_awFALCO	equ	32
speedspace_awPEPPY	equ	24
speedspace_awSLIPPY	equ	23
speedspace_awGAL1	equ	38
speedspace_awGAL2	equ	38

;��������������Ŀ
;� normal speed �BATTLE MODE
;� [ 0-127 ]    �
;� normal = 35  �
;����������������

speed_battle_awFOX		equ	30
speed_battle_awFALCO		equ	30
speed_battle_awPEPPY		equ	20
speed_battle_awSLIPPY	equ	20
speed_battle_awGAL1		equ	40
speed_battle_awGAL2		equ	40

;�����������������Ŀ
;� space no  speed �BATTLE MODE
;� [ 0-127 ]       �
;� normal = ??     �
;�������������������

speedspace_battle_awFOX	equ	25
speedspace_battle_awFALCO	equ	25
speedspace_battle_awPEPPY	equ	18
speedspace_battle_awSLIPPY	equ	18
speedspace_battle_awGAL1	equ	33
speedspace_battle_awGAL2	equ	33

;��������������Ŀ
;� boost speed  �
;� [ 0-127 ]    �
;� normal = 120 �
;����������������

boostspeed_awFOX	equ	83
boostspeed_awFALCO	equ	85
boostspeed_awPEPPY	equ	67
boostspeed_awSLIPPY	equ	65
boostspeed_awGAL1	equ	100
boostspeed_awGAL2	equ	98

boostspeed_room_awFOX	equ	40
boostspeed_room_awFALCO	equ	42
boostspeed_room_awPEPPY	equ	32
boostspeed_room_awSLIPPY	equ	30
boostspeed_room_awGAL1	equ	50
boostspeed_room_awGAL2	equ	48

;���������������������Ŀ
;� boost speed(space)  �
;� [ 0-127 ]           �
;� normal = 120        �
;�����������������������

boostspeedspace_awFOX	equ	105	;80
boostspeedspace_awFALCO	equ	107	;90
boostspeedspace_awPEPPY	equ	92	;70
boostspeedspace_awSLIPPY	equ	90	;60
boostspeedspace_awGAL1	equ	125	;100
boostspeedspace_awGAL2	equ	123	;100

;��������������Ŀ
;� brake speed  �
;� [ -127-0 ]   �
;� normal = 10  �
;����������������

brakespeed_awFOX		equ	8-speed_awFOX
brakespeed_awFALCO		equ	10-speed_awFALCO
brakespeed_awPEPPY		equ	4-speed_awPEPPY
brakespeed_awSLIPPY		equ	4-speed_awSLIPPY
brakespeed_awGAL1		equ	7-speed_awGAL1
brakespeed_awGAL2		equ	7-speed_awGAL2

;���������������������Ŀ
;� brake turn no speed �
;� [ 0-127 ]           �
;� normal = 17         �
;�����������������������

brakeTspeed_awFOX		equ	17/2
brakeTspeed_awFALCO		equ	17/2
brakeTspeed_awPEPPY		equ	12/2
brakeTspeed_awSLIPPY		equ	12/2
brakeTspeed_awGAL1		equ	22/2
brakeTspeed_awGAL2		equ	22/2

;������������������������Ŀ
;� senkai no hayasa(UFO)  �
;� [ 0-7fffh]             �
;� normal = 400H          �
;��������������������������
rotyacclUFO_FOX	equ	100H
rotyacclUFO_FALCO	equ	100H
rotyacclUFO_PEPPY	equ	100H
rotyacclUFO_SLIPPY	equ	100H
rotyacclUFO_GAL1	equ	100H
rotyacclUFO_GAL2	equ	100H

;���������������������������������������Ŀ
;� senkai no hayasa(push left or right)  �
;� [ 0-7fffh]                            �
;� normal = 200H                         �
;�����������������������������������������
rotyaccl_FOX		equ	200H
rotyaccl_FALCO	equ	190H
rotyaccl_PEPPY	equ	220H
rotyaccl_SLIPPY	equ	220H
rotyaccl_GAL1	equ	180H
rotyaccl_GAL2	equ	180H

;���������������������������������������������������Ŀ
;� senkai no hayasa(push left or right with L or R)  �
;� [ 0-7fffh ]                                       �
;� normal = 300H                                     �
;�����������������������������������������������������
rotyacclLR_FOX	equ	300H
rotyacclLR_FALCO	equ	290H
rotyacclLR_PEPPY	equ	320H
rotyacclLR_SLIPPY	equ	320H
rotyacclLR_GAL1	equ	300H
rotyacclLR_GAL2	equ	280H

;�������������������������������������������������������Ŀ
;� senkai no hayasa(BRAKE+push left or right with L or R)�
;� [ 0-7fffh ]                                           �
;� normal = 3c0H                                         �
;���������������������������������������������������������
rotyacclBRAKE_FOX	equ	3c0H
rotyacclBRAKE_FALCO	equ	3c0H
rotyacclBRAKE_PEPPY	equ	3c0H
rotyacclBRAKE_SLIPPY	equ	3c0H
rotyacclBRAKE_GAL1	equ	3c0H
rotyacclBRAKE_GAL2	equ	3c0H

;����������������������ͻ
;�Arwing's boost & brake�
;����������������������ͼ
;�����������������������������������������Ŀ
;� Boost meter no hatsu-netsu no parameter.�
;� [ 0-7fh ]                               �
;� normal = 128                            �
;� over heart suru madeno                  �
;� FRAME suu wa = (40*256)/x               �
;�������������������������������������������

boostfever_FOX		equ	0	;128*20/100
boostfever_FALCO		equ	0	;128*20/100
boostfever_PEPPY		equ	0	;96*20/100
boostfever_SLIPPY		equ	0	;96*20/100
boostfever_GAL1		equ	0	;192*20/100
boostfever_GAL2		equ	0	;192*20/100

boostfeverbattle_FOX		equ	0	;128*20/100
boostfeverbattle_FALCO	equ	0	;128*20/100
boostfeverbattle_PEPPY	equ	0	;96*20/100
boostfeverbattle_SLIPPY	equ	0	;96*20/100
boostfeverbattle_GAL1	equ	0	;192*20/100
boostfeverbattle_GAL2	equ	0	;192*20/100

; heat up by enemy weapon.(frames)

heatup_FOX		equ	10
heatup_FALCO		equ	10
heatup_PEPPY		equ	5
heatup_SLIPPY	equ	5
heatup_GAL1		equ	15
heatup_GAL2		equ	15

;���������������������������������������Ŀ
;� Boost meter no rei-kyaku no parameter.�
;� [ 0-7fh ]                             �
;� normal = 32                           �
;�zenbu no power no kaifuku ni hitsuyou  �
;�na FRAME suu wa = (40*256)/x           �
;�����������������������������������������

boostcooldown_FOX		equ	32<<1
boostcooldown_FALCO		equ	32<<1
boostcooldown_PEPPY		equ	16<<1
boostcooldown_SLIPPY		equ	16<<1
boostcooldown_GAL1		equ	7fh
boostcooldown_GAL2		equ	7fh

boostcooldownbattle_FOX		equ	32<<1
boostcooldownbattle_FALCO		equ	32<<1
boostcooldownbattle_PEPPY		equ	16<<1
boostcooldownbattle_SLIPPY		equ	16<<1
boostcooldownbattle_GAL1		equ	7fh
boostcooldownbattle_GAL2		equ	7fh

;�������������������������������������������������������Ŀ
;� Boost meter no over heart karano kaifuku no parameter.�
;� [ 0-7fh ]                                             �
;� normal = 32                                           �
;�zenbu no power no kaifuku ni hitsuyou                  �
;�na FRAME suu wa = (40*256)/x                           �
;���������������������������������������������������������

;boostrecover_FOX		equ	32
;boostrecover_FALCO		equ	32
;boostrecover_PEPPY		equ	64
;boostrecover_SLIPPY		equ	64
;boostrecover_GAL1		equ	24
;boostrecover_GAL2		equ	24

;����������ͻ
;�Robot mode�
;����������ͼ
;����������������������Ŀ
;� ROBOT no speed(walk).�
;� [ 0-7fh ]            �
;� normal = 8           �
;������������������������

robospeed_FOX	equ	26	;20
robospeed_FALCO	equ	22	;20
robospeed_PEPPY	equ	28	;24
robospeed_SLIPPY	equ	26	;24
robospeed_GAL1	equ	24	;18
robospeed_GAL2	equ	28	;18

;������������������������Ŀ
;� ROBOT no speed(Y dush).�
;� [ 0-7fh ]              �
;� normal = 16            �
;��������������������������

robospeedFAST_FOX	equ	36	;30
robospeedFAST_FALCO	equ	32	;30
robospeedFAST_PEPPY	equ	38	;34
robospeedFAST_SLIPPY	equ	34	;34
robospeedFAST_GAL1	equ	30	;27
robospeedFAST_GAL2	equ	32	;27

;����������������������������������������Ŀ
;� ROBOT no kasokudo(walk)                �
;� [ 0-7fffH ]                            �
;� normal = 400H                          �
;������������������������������������������

robospeedaccl_FOX	equ	8<<8	;4<<8
robospeedaccl_FALCO	equ	10<<8	;4<<8
robospeedaccl_PEPPY	equ	12<<8	;4<<8
robospeedaccl_SLIPPY	equ	8<<8	;4<<8
robospeedaccl_GAL1	equ	10<<8	;4<<8
robospeedaccl_GAL2	equ	8<<8	;4<<8

;����������������������������������������Ŀ
;� ROBOT no Y dush no kasokudo(walk)      �
;� [ 0-7fffH ]                            �
;� normal = 800H                          �
;������������������������������������������

robospeeddushaccl_FOX	equ	16<<8	;8<<8
robospeeddushaccl_FALCO	equ	15<<8	;8<<8
robospeeddushaccl_PEPPY	equ	18<<8	;8<<8
robospeeddushaccl_SLIPPY	equ	14<<8	;8<<8
robospeeddushaccl_GAL1	equ	18<<8	;8<<8
robospeeddushaccl_GAL2	equ	16<<8	;8<<8

;������������������������������������������Ŀ
;� ROBOT no ground no friction              �
;� [ 0-7fH ]                                �
;� normal = 70H (small:tsuyoi  large:ti-sai)�
;��������������������������������������������

robogndfric_FOX	equ	40h	;60h
robogndfric_FALCO	equ	40h	;60h
robogndfric_PEPPY	equ	38h	;60h
robogndfric_SLIPPY	equ	38h	;60h
robogndfric_GAL1	equ	36h	;60h
robogndfric_GAL2	equ	40h	;60h

;������������������������������������������Ŀ
;� ROBOT no slope no friction               �
;� [ 0-7fH ]                                �
;� normal = 70H (small:tsuyoi  large:ti-sai)�
;��������������������������������������������

roboslopefric_FOX	equ	35H
roboslopefric_FALCO	equ	35H
roboslopefric_PEPPY	equ	35H
roboslopefric_SLIPPY	equ	35H
roboslopefric_GAL1	equ	35H
roboslopefric_GAL2	equ	35H

;������������������������������������������Ŀ
;� ROBOT no air no friction                 �
;� [ 0-7fH ]                                �
;� normal = 78H (small:tsuyoi  large:ti-sai)�
;��������������������������������������������

roboairfric_FOX	equ	60H
roboairfric_FALCO	equ	60H
roboairfric_PEPPY	equ	64H
roboairfric_SLIPPY	equ	62H
roboairfric_GAL1	equ	62H
roboairfric_GAL2	equ	60H

;������������������������������������������Ŀ
;� ROBOT no water no friction               �
;� [ 0-7fH ]                                �
;� normal = 70H (small:tsuyoi  large:ti-sai)�
;��������������������������������������������

robowatfric_FOX	equ	7aH
robowatfric_FALCO	equ	7aH
robowatfric_PEPPY	equ	7cH
robowatfric_SLIPPY	equ	7dH
robowatfric_GAL1	equ	7aH
robowatfric_GAL2	equ	7aH

;������������������������������������Ŀ
;� ROBOT no speed(walk left or right).�
;� [ 0-7fh ]                          �
;� normal = 5                         �
;��������������������������������������

robospeedLR_FOX	equ	24	;14
robospeedLR_FALCO	equ	24	;14
robospeedLR_PEPPY	equ	26	;20
robospeedLR_SLIPPY	equ	26	;20
robospeedLR_GAL1	equ	22	;10
robospeedLR_GAL2	equ	22	;10

;����������������������������������������������Ŀ
;� ROBOT no speed (Y dush) (walk left or right).�
;� [ 0-7fh ]                                    �
;� normal = 30                                  �
;������������������������������������������������

robospeedLRFAST_FOX		equ	34	;30
robospeedLRFAST_FALCO	equ	32	;30
robospeedLRFAST_PEPPY	equ	34	;30
robospeedLRFAST_SLIPPY	equ	34	;30
robospeedLRFAST_GAL1		equ	34	;30
robospeedLRFAST_GAL2		equ	36	;30

;����������������������������������������Ŀ
;� ROBOT no kaskokudo(walk left or right).�
;� [ 0-7fffH ]                            �
;� normal = 400H                          �
;������������������������������������������

robospeedLRaccl_FOX		equ	16<<8	;4<<8
robospeedLRaccl_FALCO	equ	16<<8	;4<<8
robospeedLRaccl_PEPPY	equ	16<<8	;4<<8
robospeedLRaccl_SLIPPY	equ	16<<8	;4<<8
robospeedLRaccl_GAL1		equ	16<<8	;4<<8
robospeedLRaccl_GAL2		equ	16<<8	;4<<8

;����������������������������������������Ŀ
;� ROBOT no kaskokudo(walk left or right).�
;� [ 0-7fffH ]                            �
;� normal = 400H                          �
;������������������������������������������

robospeedLRdushaccl_FOX	equ	16<<8	;4<<8
robospeedLRdushaccl_FALCO	equ	16<<8	;4<<8
robospeedLRdushaccl_PEPPY	equ	16<<8	;4<<8
robospeedLRdushaccl_SLIPPY	equ	16<<8	;4<<8
robospeedLRdushaccl_GAL1	equ	16<<8	;4<<8
robospeedLRdushaccl_GAL2	equ	16<<8	;4<<8


;�����������������������������������������������������������������������������������������������Ŀ
;�                                                                                               �
;�ROBOT no JUMP no parameter                                                                     �
;�                                                                                               �
;�*jmpvelmax = jump speed no max no atai.[15bit  0-32767]                                        �
;�	(normal:800H)                                                                       �
;�*jmpvel1st = jump speed no syosokudo.[15bit 0-32767]                                           �
;�	(normal:200H)                                                                       �
;�*jmpvelincrate = B button wo oshite iru tokino JUMP speed no nobi.[15bit 0-32767]              �
;�	(normal:100H)                                                                       �
;�*jmpvelaccl = Gravity no kasokudo.[8bit 0-255]						    �
;�	(normal:0c0H)                                                                       �
;�                                                                                               �
;�Jump no parameter wa tyotto fukuzatsu...                                                       �
;�Moshi hen ni nattara Fujii-kun ni soudan shiyou!                                               �
;�                                                                                               �
;�������������������������������������������������������������������������������������������������

jmpvelmax_FOX	equ	800H	;normal 900H
jmpvel1st_FOX	equ	2a0H	;normal 300H
jmpvelincrate_FOX	equ	0c0H	;normal 100H
jmpgravaccl_FOX	equ	100H	;normal 0c0H

jmpvelmax_FALCO	equ	800H	;normal 900H
jmpvel1st_FALCO	equ	200H	;normal 300H
jmpvelincrate_FALCO	equ	0c0H	;normal 100H
jmpgravaccl_FALCO	equ	0c0H	;normal 0c0H

jmpvelmax_PEPPY	equ	800H	;normal 900H
jmpvel1st_PEPPY	equ	200H	;normal 300H
jmpvelincrate_PEPPY	equ	0c0H	;normal 100H
jmpgravaccl_PEPPY	equ	0c0H	;normal 0c0H

jmpvelmax_SLIPPY	equ	800H	;normal 900H
jmpvel1st_SLIPPY	equ	200H	;normal 300H
jmpvelincrate_SLIPPY	equ	0c0H	;normal 100H
jmpgravaccl_SLIPPY	equ	0c0H	;normal 0c0H

jmpvelmax_GAL1	equ	800H	;normal 900H
jmpvel1st_GAL1	equ	2a0H	;normal 300H
jmpvelincrate_GAL1	equ	0c0H	;normal 100H
jmpgravaccl_GAL1	equ	100H	;normal 0c0H

jmpvelmax_GAL2	equ	800H	;normal 900H
jmpvel1st_GAL2	equ	2a0H	;normal 300H
jmpvelincrate_GAL2	equ	0c0H	;normal 100H
jmpgravaccl_GAL2	equ	100H	;normal 0c0H

;jmpvelmax_GAL1	equ	800H	;normal 900H
;jmpvel1st_GAL1	equ	200H	;normal 300H
;jmpvelincrate_GAL1	equ	0c0H	;normal 100H
;jmpgravaccl_GAL1	equ	0c0H	;normal 0c0H

;jmpvelmax_GAL2	equ	800H	;normal 900H
;jmpvel1st_GAL2	equ	200H	;normal 300H
;jmpvelincrate_GAL2	equ	0c0H	;normal 100H
;jmpgravaccl_GAL2	equ	0c0H	;normal 0c0H


;��������������ͻ
;�SUBMARINE mode�
;��������������ͼ
;����������������������������Ŀ
;� bataashi no toki no speed. �
;� [ 0-7fh ]                  �
;� normal = 10                �
;������������������������������

robospeedthrash_FOX		equ	22	;15*2
robospeedthrash_FALCO	equ	22	;15*2
robospeedthrash_PEPPY	equ	26	;28*2
robospeedthrash_SLIPPY	equ	28	;33*2
robospeedthrash_GAL1		equ	24	;20*2
robospeedthrash_GAL2		equ	24	;20*2

;����������������������������Ŀ
;� bataashi no toki no speed. �kasokudo
;� [ 0-7ffffh ]               �
;� normal = 10                �
;������������������������������

robospeedthrashaccl_FOX	equ	80H
robospeedthrashaccl_FALCO	equ	80H
robospeedthrashaccl_PEPPY	equ	80H
robospeedthrashaccl_SLIPPY	equ	80H
robospeedthrashaccl_GAL1	equ	80H
robospeedthrashaccl_GAL2	equ	80H

;���������������������������������Ŀ
;� bataashi+JUMP no toki no speed. �
;� [ 0-7fh ]                       �
;� normal = 30                     �
;�����������������������������������

robospeedthrashFAST_FOX	equ	127	;75
robospeedthrashFAST_FALCO	equ	75
robospeedthrashFAST_PEPPY	equ	127
robospeedthrashFAST_SLIPPY	equ	127
robospeedthrashFAST_GAL1	equ	105
robospeedthrashFAST_GAL2	equ	105

;���������������������������������ĿKasokudo
;� bataashi+JUMP no toki no speed. �
;� [ 0-7ffffh ]                    �
;� normal = 30                     �
;�����������������������������������

robospeedthrashFASTaccl_FOX		equ	100H
robospeedthrashFASTaccl_FALCO	equ	100H
robospeedthrashFASTaccl_PEPPY	equ	100H
robospeedthrashFASTaccl_SLIPPY	equ	100H
robospeedthrashFASTaccl_GAL1		equ	100H
robospeedthrashFASTaccl_GAL2		equ	100H

;����������������������������������������Ŀ
;� ROBOT no kaskokudo(walk left or right).�
;� [ 0-7fffH ]                            �
;� normal = 400H                          �
;������������������������������������������

robospeedthrashLRaccl_FOX	equ	2<<8
robospeedthrashLRaccl_FALCO	equ	2<<8
robospeedthrashLRaccl_PEPPY	equ	2<<8
robospeedthrashLRaccl_SLIPPY	equ	2<<8
robospeedthrashLRaccl_GAL1	equ	2<<8
robospeedthrashLRaccl_GAL2	equ	2<<8

;�������������������Ŀ
;� JUMP no syosokudo �
;� [0-7fffH]         �
;� normal = 100H     �
;���������������������

Sjmpvel1st_FOX	equ	100H
Sjmpvel1st_FALCO	equ	100H
Sjmpvel1st_PEPPY	equ	100H
Sjmpvel1st_SLIPPY	equ	100H
Sjmpvel1st_GAL1	equ	100H
Sjmpvel1st_GAL2	equ	100H

;������������������������������������������Ŀ
;� JUMP(UP,DOWN wo oshitatoki no syosokudo) �
;� [0-7fffH]                                �
;� normal = 100H                            �
;��������������������������������������������

Sjmpvel1st0_FOX	equ	100H
Sjmpvel1st0_FALCO	equ	100H
Sjmpvel1st0_PEPPY	equ	100H
Sjmpvel1st0_SLIPPY	equ	100H
Sjmpvel1st0_GAL1	equ	100H
Sjmpvel1st0_GAL2	equ	100H

;���������������������������������������Ŀ
;� JUMP no toki jyo-syo- suru frame suu. �
;� [0-0ffh]                              �
;� normal = 19                           �
;�����������������������������������������

Sjmpframe_FOX	equ	19
Sjmpframe_FALCO	equ	19
Sjmpframe_PEPPY	equ	19
Sjmpframe_SLIPPY	equ	19
Sjmpframe_GAL1	equ	19
Sjmpframe_GAL2	equ	19

;�����������������������Ŀ
;� weight in the sea.    �
;� [ 0(karui)-ffH(omoi) ]�
;� normal = 30H          �
;�������������������������
weight_isFOX		equ	40H
weight_isFALCO	equ	40H
weight_isPEPPY	equ	60H
weight_isSLIPPY	equ	60H
weight_isGAL1	equ	20H
weight_isGAL2	equ	20H

;�������������������������������Ŀ
;� mizu no teikou (jump no toki) �
;� [ 0(yowai)-7fffH(tsuyoi) ]    �
;� normal = 100H                 �
;���������������������������������

waterres_FOX		equ	100H
waterres_FALCO	equ	100H
waterres_PEPPY	equ	100H
waterres_SLIPPY	equ	100H
waterres_GAL1	equ	100H
waterres_GAL2	equ	100H

;��������ͻ
;�UFO mode�
;��������ͼ
;���������������������Ŀ
;� UFO no speed.       �
;� [ 0-7fffh ]         �
;� normal = 30*256     �
;�����������������������
UFO_speed_FOX	equ	30<<8
UFO_speed_FALCO	equ	30<<8
UFO_speed_PEPPY	equ	30<<8
UFO_speed_SLIPPY	equ	30<<8
UFO_speed_GAL1	equ	30<<8
UFO_speed_GAL2	equ	30<<8

tutuUFO_speed_FOX	equ	30<<8
tutuUFO_speed_FALCO	equ	30<<8
tutuUFO_speed_PEPPY	equ	30<<8
tutuUFO_speed_SLIPPY	equ	30<<8
tutuUFO_speed_GAL1	equ	30<<8
tutuUFO_speed_GAL2	equ	30<<8

;�����������������������������������������������Ŀ
;� UFO no gensoku-ritsu(automatic mode)          �
;� small=kansei ga tsuyoi  large:kansei ga yowai �
;� normal = 512                                  �
;�������������������������������������������������
UFO_dclspeed_FOX		equ	2<<8
UFO_dclspeed_FALCO		equ	2<<8
UFO_dclspeed_PEPPY		equ	2<<8
UFO_dclspeed_SLIPPY		equ	2<<8
UFO_dclspeed_GAL1		equ	20
UFO_dclspeed_GAL2		equ	2<<8

tutuUFO_dclspeed_FOX		equ	2<<8
tutuUFO_dclspeed_FALCO		equ	2<<8
tutuUFO_dclspeed_PEPPY		equ	2<<8
tutuUFO_dclspeed_SLIPPY		equ	2<<8
tutuUFO_dclspeed_GAL1		equ	20
tutuUFO_dclspeed_GAL2		equ	2<<8
;�����������������������������������������������Ŀ
;� UFO no gensoku-ritsu(manual mode)             �
;� small=kansei ga tsuyoi  large:kansei ga yowai �
;� normal = 1*256                                �
;�������������������������������������������������
UFO_DCLspeedMANU_FOX		equ	1<<8
UFO_DCLspeedMANU_FALCO	equ	1<<8
UFO_DCLspeedMANU_PEPPY	equ	1<<8
UFO_DCLspeedMANU_SLIPPY	equ	1<<8
UFO_DCLspeedMANU_GAL1	equ	40
UFO_DCLspeedMANU_GAL2	equ	1<<8

tutuUFO_DCLspeedMANU_FOX		equ	1<<8
tutuUFO_DCLspeedMANU_FALCO	equ	1<<8
tutuUFO_DCLspeedMANU_PEPPY	equ	1<<8
tutuUFO_DCLspeedMANU_SLIPPY	equ	1<<8
tutuUFO_DCLspeedMANU_GAL1	equ	40
tutuUFO_DCLspeedMANU_GAL2	equ	1<<8
;���������������������������������������������Ŀ
;� UFO no kasoku-ritsu                         �
;� small=kasoku ga osoi  large:kasoku ga hayai �
;� normal = 8*256                              �
;�����������������������������������������������
UFO_ACLspeed_FOX		equ	8<<8
UFO_ACLspeed_FALCO		equ	8<<8
UFO_ACLspeed_PEPPY		equ	8<<8
UFO_ACLspeed_SLIPPY		equ	8<<8
UFO_ACLspeed_GAL1		equ	10<<8
UFO_ACLspeed_GAL2		equ	8<<8

tutuUFO_ACLspeed_FOX		equ	8<<8
tutuUFO_ACLspeed_FALCO		equ	8<<8
tutuUFO_ACLspeed_PEPPY		equ	8<<8
tutuUFO_ACLspeed_SLIPPY		equ	8<<8
tutuUFO_ACLspeed_GAL1		equ	10<<8
tutuUFO_ACLspeed_GAL2		equ	8<<8

;����������������������������������Ŀ
;� UFO no yoko idou no speed.       �
;� [ 0-32767 ]         	       �
;� normal = 30*256                  �
;������������������������������������
UFO_sidespeed_FOX	equ	30<<8
UFO_sidespeed_FALCO	equ	30<<8
UFO_sidespeed_PEPPY	equ	30<<8
UFO_sidespeed_SLIPPY	equ	30<<8
UFO_sidespeed_GAL1	equ	30<<8
UFO_sidespeed_GAL2	equ	30<<8

tutuUFO_sidespeed_FOX	equ	30<<8
tutuUFO_sidespeed_FALCO	equ	30<<8
tutuUFO_sidespeed_PEPPY	equ	30<<8
tutuUFO_sidespeed_SLIPPY	equ	30<<8
tutuUFO_sidespeed_GAL1	equ	30<<8
tutuUFO_sidespeed_GAL2	equ	30<<8
;����������������������������������������������������������Ŀ
;� UFO no yokoidou no kasoku-ritsu(automatic mode)          �
;� small=kansei ga tsuyoi  large:kansei ga yowai            �
;� normal = 512                                             �
;������������������������������������������������������������

UFO_sideaclspeed_FOX		equ	2<<8
UFO_sideaclspeed_FALCO	equ	2<<8
UFO_sideaclspeed_PEPPY	equ	2<<8
UFO_sideaclspeed_SLIPPY	equ	2<<8
UFO_sideaclspeed_GAL1	equ	2<<8
UFO_sideaclspeed_GAL2	equ	2<<8

tutuUFO_sideaclspeed_FOX	equ	2<<8
tutuUFO_sideaclspeed_FALCO	equ	2<<8
tutuUFO_sideaclspeed_PEPPY	equ	2<<8
tutuUFO_sideaclspeed_SLIPPY	equ	2<<8
tutuUFO_sideaclspeed_GAL1	equ	2<<8
tutuUFO_sideaclspeed_GAL2	equ	2<<8

;�����������������������������������������������������������Ŀ
;� UFO no yokoidou no gensoku-ritsu(automatic mode)          �
;� small=kansei ga tsuyoi  large:kansei ga yowai             �
;� normal = 512                                              �
;�������������������������������������������������������������

UFO_sidedclspeed_FOX		equ	2<<8
UFO_sidedclspeed_FALCO	equ	2<<8
UFO_sidedclspeed_PEPPY	equ	2<<8
UFO_sidedclspeed_SLIPPY	equ	2<<8
UFO_sidedclspeed_GAL1	equ	2<<8
UFO_sidedclspeed_GAL2	equ	2<<8

tutuUFO_sidedclspeed_FOX	equ	2<<8
tutuUFO_sidedclspeed_FALCO	equ	2<<8
tutuUFO_sidedclspeed_PEPPY	equ	2<<8
tutuUFO_sidedclspeed_SLIPPY	equ	2<<8
tutuUFO_sidedclspeed_GAL1	equ	2<<8
tutuUFO_sidedclspeed_GAL2	equ	2<<8

;---------------------------------------------------------------------------------------

rotztendmax	equ	35	;rotz when push left or right

;---------------------------------------------------------------------------------------
;������������������������Ŀ
;� powerd laser no seinou �
;� 	             �
;� [ 0-7fffh ]            �
;��������������������������

powerlaserup_FOX	equ	180h	; 100h = 1frame de 1memori kaifuku.
powerlaserup_FALCO	equ	180h
powerlaserup_PEPPY	equ	180h
powerlaserup_SLIPPY	equ	180h
powerlaserup_GAL1	equ	180h
powerlaserup_GAL2	equ	180h

;���������������������������������������������������������������������������������������
;	GROUND
;���������������������������������������������������������������������������������������
;	map_playermode		ground
;	map_setplayerpos	1,0,-150,-4000,0
;	map_battlearea		-500,0,0,ground
;	map_camerainit_1screen	-220,100,16,-16,55H
;	map_arwinginit		-500,-12,15,-15
;���������������������������������������������������������������������������������������
;	SPACE
;���������������������������������������������������������������������������������������
;	map_playermode		space
;	map_setplayerpos	1,0,-1200,-4500,0
;	map_battlearea		-2000,2000,0,ground
;	map_camerainit_1screen	-130,100,30,-30,0
;	map_camerainit_2screen	-130,60,15,-15,0
;	map_arwinginit		-2000,2000,40,-40
;���������������������������������������������������������������������������������������
;	ROOM
;���������������������������������������������������������������������������������������
;	map_playermode		room
;	map_setplayerpos	1,0,-150,-4000,0
;	map_battlearea		-500,0,0,ground
;	map_camerainit_1screen	-220,100,16,-16,55H
;	map_arwinginit		-500,-12,15,-15
;���������������������������������������������������������������������������������������
;	MARINE
;���������������������������������������������������������������������������������������
;	map_setplayerpos	1,0,-1100,-2000,0
;	map_playermode		marine
;	map_battlearea		-1300,0,-1000,water
;	map_camerainit_1screen	-1000,100,16,-16,55H
;	map_arwinginit		-1300,-1012,15,-15
;���������������������������������������������������������������������������������������
;	DESERT
;���������������������������������������������������������������������������������������
;	map_setplayerpos	1,0,-150,-4500,0
;	map_playermode		desert
;	map_battlearea		-300,0,-50,sand
;	map_camerainit_1screen	-130,100,16,-16,55H
;	map_arwinginit		-300,-12,15,-15
;���������������������������������������������������������������������������������������
;	MAGMA
;���������������������������������������������������������������������������������������
;	map_setplayerpos	1,4500,-150,-4500,deg45
;	map_playermode		ground
;	map_battlearea		-300,0,-20,magma
;	map_camerainit_1screen	-130,100,16,-16,55H
;	map_arwinginit		-300,-12,15,-15
;���������������������������������������������������������������������������������������
;	GROUND (BATTLE)
;���������������������������������������������������������������������������������������
;	map_battlearea		-500,0,0,ground
;	map_camerainit_1screen	-250,100,16,-16,68H	;55H
;	map_camerainit_2screen	-250,100,16,-16,68H	;55H
;	map_arwinginit		-500,-12,15,-15
;���������������������������������������������������������������������������������������
;	EXT3 (BATTLE)
;���������������������������������������������������������������������������������������
;	map_playermode		room
;	map_setplayerpos	1,0512,-120,0000,0
;	map_battlearea		-300,0,0,ground
;	map_camerainit_1screen	-080,100,16,-16,55H
;	map_arwinginit		-300,-12,15,-15
;	map_playertunnel
;
;	map_demomode	1
;���������������������������������������������������������������������������������������
;	END OF FILE
;���������������������������������������������������������������������������������������
