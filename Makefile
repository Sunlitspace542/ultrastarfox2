################################
# UltraStarFox2 Linux Makefile #
################################

DOSBOX=dosbox-x

all: 
	@$(DOSBOX) BUILD.BAT

log: 
	@$(DOSBOX) BLDTOLOG.BAT

clean:
	@$(DOSBOX) CLEAN.BAT
