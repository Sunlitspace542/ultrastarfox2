;
; File:	MOBJ.MC
;
; Use: 	3D Graphics Kernal jump table
; Code:	MARIO
; By:  	Peter Warnes
;      	Copyright 1991
;		Argonaut Software Ltd.

; 22/11/93	pete	New BSP code added
;
; bsp_init, bsp_node, bsp_faces, bsp_ret added
; Old BSP code still supported


shjmp	macro
	mlbra	msh_\1
mval_\1	equ	mshval
mshval	=	mshval+4
	endm



mshval	=	0

mshape_jmp_tab
	shjmp	endshape	;  0
	shjmp	rotpoints8	;  4
	shjmp	rotpoints16	;  8
	shjmp	endpoints	; 12
	shjmp	groups		; 16
	shjmp	faces		; 20
	shjmp	lines		; 24
	shjmp	frames		; 28
	shjmp	jump		; 32
	shjmp	spheres		; 36
	shjmp	bsp		; 40
	shjmp	outword		; 44
	shjmp	vizis		; 48	
	shjmp	rotpointsx16	; 52
	shjmp	rotpointsx8	; 56
	shjmp	bspinit		; 60
	shjmp	bspend		; 64
	shjmp	bspe		; 68
	shjmp	quit		; 72
	shjmp	vnormals	; 76
	shjmp	s_sprite	; 80
	shjmp	s_spritevis	; 84
	shjmp	bsp_init	; 88
	shjmp	bsp_node	; 92
	shjmp	bsp_faces	; 96
	shjmp	bsp_ret		;100
	shjmp	clip_plane	;104	Carl Plane clipping


	ifne	mshape_jmp_tab&$00007fff
	error	"mshape_jmp_tab must be at start of MARIO bank"
	endc

