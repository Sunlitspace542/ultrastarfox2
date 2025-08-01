; #############################
; ## Debugging Configuration ##
; #############################

;####################################################################################################################

; full strategy debugging
; [0 = off, 1 = on]
debuginfo		equ	0

; stage selection/ speed up mode
; [0 = off, 1 = on]
debuginfo2		equ	0 

; 0/1 ... sound port display off/on 
; [0 = off, 1 = on]
portinfo		equ	0

; 0/1 ... random on/off
; [0 = off, 1 = on]
randominfo		equ	0

; 0/1 ... polygon demo on / off
; [0 = off, 1 = on]
demoinfo		equ	0

; display map blockmap?
; [0 = off, 1 = on]
blockmap_dbg	equ	0

; display amount of path commands executed
; [0 = off, 1 = on]
pathcount		equ	0

; 0=off/1=on test mode Set SOS1 and SOS2.
; [0 = off, 1 = on]
sos_test_egu	equ	0

; display cycles used up while polling mario chip
; [0 = off, 1 = on]
polllaginfo		equ	0

; Configuration Menu
; restores sound test (note: config is now in bank 36)
enableconfig	=	0

; improvements to the sound test such as track number wrapping to/from last track and changed songlist
; [0 = off, 1 = on]
configimprovements	equ	1

; enable cursor sound like in vanilla
; [0 = off, 1 = on]
configcursorsound	equ	1

;####################################################################################################################

; Sanity Checks
; Disable config in retail builds
	ifeq	debuginfo
enableconfig	=	0
	endc
