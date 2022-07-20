
	include	INC\header.inc
	include	INC\marioi.inc
	include	INC\strathdr.inc
	include	INC\bgmacs.inc
	include	INC\scalevar.inc

	include	INC\yajima.inc
	include	INC\shmacs.inc
	include	INC\gamelist.inc

	incpub	yjmario

	bank	11

;--------------------------------------------------------------------
	Msetdate 94,12,28,2	; <==== year,month,date,version
;--------------------------------------------------------------------

this_bank	=	*&$ff0000

	incfile ASM\clear.asm

	mario_on
	incfile MARIO\mmacs.mc
	incfile MARIO\mmessage.mc
	incfile	MARIO\mytest.mc
	incfile MARIO\mkawa.mc
	incfile MARIO\mover.mc
	incfile MARIO\mtitle.mc
 	mario_off

	incfile	ASM\gameover.asm
	incfile	ASM\continue.asm
	incfile ASM\yjdebug.asm

	incfile	ASM\wipe.asm

	incfile	ASM\missobj.asm
	incfile	yjmap.asm
	incfile	ASM\mapexp.asm
	incfile ASM\gameobj.asm
	incfile ASM\hell.asm

	incfile ASM\pselect.asm
	incfile ASM\pselect2.asm

	incfile ASM\pausemap.asm

	incfile	ASM\oamset.asm
	incfile ASM\oamlist.asm
	incfile	ASM\oamdata.asm
	incfile ASM\oamface.asm
	incfile ASM\oamplane.asm

	incfile ASM\titleobj.asm
	incfile ASM\nameset.asm
	incfile ASM\bestscor.asm

	incfile ASM\mesdata.asm

	printf	"backupRAM start address ",:$m_backupram_start,"(Hex)%n"
	printf	"backupRAM total size    ",:$backup_totalsize,"(Hex)%n"
	printf	"backupRAM savecode(ID)  ",:$magic_data,"(Hex)%n"
	printf  "KenemyNumber            ",:$KEnemyNumber,"(Hex)%n"

	bankend	11

	include	INC\tail.inc


