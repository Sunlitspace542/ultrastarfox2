; #######################
; ## ROM Configuration ##
; #######################

;####################################################################################################################

; Cartridge Configuration

; Super FX 3 support [0 = off, 1 = on]
; Seems to work, but some things may not be up to spec just yet.
; ROM map isn't properly set up yet.
; Real FX3 hardware does not fire IRQs and the IRQ handler needs to be retrofitted/replaced to reflect this.
; MesenCE still fires an IRQ on STOP, thus the game works.
SUPERFX3	equ 0

; PAL/NTSC (1/0)
pal					equ	0

; Run Super FX chip @ 21Mhz
fast				equ	1

; Super FX chip cache on/off
CacheOn				equ	1


; Game Language

; Switch language between:
; 0 = English (NOA 1995 Localization)
; and
; 0 = Japanese
janglish			equ	0

; Aeon Genesis English Translation (2004), with some slight changes:
; - partner -> wingman
; - Andrew -> Algy
; - New Secret Base dialogue (wasn't in 6/22/95 build)
; - Walker tutorial corrected (double tap D-pad to walk faster)
; - Typos fixed
; Assets Affected:
; - Skull texture for Andross emblem on ships, etc. (SPT_3_AG.CGX)
; - Dialogue font changed (obviously)
; set JANGLISH to 0 and this equate to 1 to enable.
aeongenesis			equ	0

; German Version  (unused)
german				equ	0

; French Version  (unused)
french				equ	0


; Title Screen Copyright Year

kyear				equ	96	; 95/96/97/17 = 1995/1996/1997/2017

;####################################################################################################################
