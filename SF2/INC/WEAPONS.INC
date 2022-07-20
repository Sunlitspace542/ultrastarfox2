;---------------------------------------------------

cweapon	=	0
	IFEQ	weaphdr
weapons_data
	ENDC
	weapon	<current>,0

; player's special weapon

	weapon	<rebound>,firerebound_l
;;;;	weapon	<flame>,fireflame_l
;;;;	weapon	<awdummy>,fireawdummy_l
;;;;	weapon	<spreadplasma>,firespreadplasma_l
;;;;	weapon	<missile1>,firemissile1_l

; player's normal weapon

	weapon	<Pplasma>,firePplasma_l
	weapon	<awlaser>,fireAWlaser_l
	weapon	<awlaser_twin>,fireAWlaser_twin_l
	weapon	<awlaser_twintwin>,fireAWlaser_twintwin_l

	weapon	<awpowerdlaser>,fireAWpowerdlaser_l
	weapon	<awpowerdlaser_twin>,fireAWpowerdlaser_twin_l
	weapon	<awpowerdlaser_twintwin>,fireAWpowerdlaser_twintwin_l

; friend's weapon

;;;;;;	weapon	<Flaser>,fireFlaser_l

; enemy's weapon

	weapon	<HomEmissile>,fireHomEmissile_l

	weapon	<Elaser>,fireElaser_l
	weapon	<RelElaser>,fireRelElaser_l

	weapon	<RelElaser_hsp>,fireRelElaser_hsp_l

	weapon	<Ering>,fireEring_l
	weapon	<RelEring>,fireRelEring_l

;	weapon	<Eplasma1>,fireEring_l
;	weapon	<RelEplasma1>,fireRelEring_l

	weapon	<Eplasma1>,fireEplasma1_l
	weapon	<RelEplasma1>,fireRelEplasma1_l


