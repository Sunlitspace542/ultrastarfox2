;旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
;�                                                                    �
;�                 STARFOX II - REVENGE OF PEPPY -                    �
;�                                                                    �
;쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캑
;�                                                                    �
;� FILE:         GAKKI.ASM                                            �
;� AUTHOR:       Inagaki "Gakki" YOji                                 �
;� DESCRIPTION:  Sound data                                           �
;� DATE CREATED: 22-5-95                                              �
;�                                                                    �
;읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

	INCPUB	gakki

;----------------------------------------------------------------------

ase	macro	[shape,se]
	dw	{shape}
	db	sport2_p2_{se}
	endm

;----------------------------------------------------------------------

ase_tab	ase	dragon_0,dragon
	ase	sos_0,sos_0


;	IFEQ	1
	ase	taigun,taigun
	ase	speed_s,speed_s
	ase	sos_1,sos_1
	ase	enkin,enkin
	ase	sos_2,sos_2
;	ase	kieru,sos_2
	ase	stepup_0,stepup_0
	ase	kuru1_u,kururin
	ase	kururin0,kururin
	ase	kururin1,kururin
	ase	dandou,dandou
	ase	miss2_1,miss2_1
	ase	enban_1,enban_1
	ase	tate_m_0,tate_m_0
	ase	jyouge,jyouge
	ase	jyouge_1,jyouge_1
	ase	baku_r,baku
	ase	baku_l,baku
	ase	ninja,ninja

	ase	virus_big,virus
	ase	wolf,wolf_arwing
	ase	wolf_1,wolf_arwing

;	ase	dragon,dragon
;	ENDC

	dw	0	; end code

