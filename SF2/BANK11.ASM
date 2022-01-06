
	include	header.inc
	include	marioi.inc
	include	strathdr.inc
	include	bgmacs.inc
	include	scalevar.inc

	include	yajima.inc
	include	shmacs.inc
	include	gamelist.inc

	incpub	yjmario

	bank	11

;--------------------------------------------------------------------
	Msetdate 94,12,28,2	; <==== year,month,date,version
;--------------------------------------------------------------------

this_bank	=	*&$ff0000

	incfile clear.asm

	mario_on
	incfile mmacs.mc
	incfile mmessage.mc
	incfile	mytest.mc
	incfile mkawa.mc
	incfile mover.mc
	incfile mtitle.mc
 	mario_off

	incfile	gameover.asm
	incfile	continue.asm
	incfile yjdebug.asm

	incfile	wipe.asm

	incfile	missobj.asm
	incfile	yjmap.asm
	incfile	mapexp.asm
	incfile gameobj.asm
	incfile hell.asm

	incfile pselect.asm
	incfile pselect2.asm

	incfile pausemap.asm

	incfile	oamset.asm
	incfile oamlist.asm
	incfile	oamdata.asm
	incfile oamface.asm
	incfile oamplane.asm

	incfile titleobj.asm
	incfile nameset.asm
	incfile bestscor.asm

	incfile mesdata.asm

	printf	"backupRAM start address ",:$m_backupram_start,"(Hex)%n"
	printf	"backupRAM total size    ",:$backup_totalsize,"(Hex)%n"
	printf	"backupRAM savecode(ID)  ",:$magic_data,"(Hex)%n"
	printf  "KenemyNumber            ",:$KEnemyNumber,"(Hex)%n"

	bankend	11

	include	tail.inc


