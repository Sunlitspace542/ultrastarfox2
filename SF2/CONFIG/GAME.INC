; ########################
; ## Game Configuration ##
; ########################

;####################################################################################################################

; Startup Behavior

; WCES 1995 "Nintendo Presents" screen
; [0 = off, 1 = on]
cesboot				equ	0

; Skips the title demo with the Mirage Dragon but not the Arwings entering the Mothership
; [0 = off, 1 = on]
skiptitledemo		equ	0

; disable region/controller port checks on boot
; [0 = off, 1 = on]
nosecuritychk		equ	0

; Gameplay
;###############################################################
;## to tweak other aspects of the game, see INC/GAMELIST.INC. ##
;###############################################################

; Gameplay Difficulty

; Force normal mode Andross on all difficulties
; [0 = off, 1 = on]
forceeasyandross	equ 0

; Force hard mode Andross on all difficulties
; [0 = off, 1 = on]
forcenormalandross	equ 0

; Force expert mode Andross on all difficulties
; [0 = off, 1 = on]
forcehardandross	equ 0

; enable expert mode by default
; [0 = off, 1 = on]
expertbydefault		equ 0

; Reduce damage taken by 1/2.
; [0 = off, 1 = on]
DamageHalf			equ 0


; Gameplay Changes

; Enable Lock-On/Homing by default
; [0 = off, 1 = on]
lockondef			equ 0

; enable walker twirl from WCES 1995 (note: egdata is now in bank 36)
; [0 = off, 1 = on]
walkertwirl			equ 0

; enable changing view in space like in the Aeon Genesis English Translation
; [0 = off, 1 = on]
spaceviewchange		equ	0

;####################################################################################################################