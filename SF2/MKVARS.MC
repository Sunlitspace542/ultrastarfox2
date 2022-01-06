;*player 1 parameter *
	km_malclabelstart	player1param
	malc	km_player1score,3		;SCORE
	malc	km_player1gold,2		;GOLD
	malc	km_player1weapon,1		;weapon no syurui
	malc	km_player1weaponval,1		;weapon no kazu
	malc	km_player1HP,1			;Hit Point
	malc	km_player1pilot,1		;pilot no syurui

	km_malclabelend		player1param

;*player 2 parameter *
	km_malclabelstart	player2param
	malc	km_player2score,3		;SCORE
	malc	km_player2gold,2		;GOLD
	malc	km_player2weapon,1		;weapon no syurui
	malc	km_player2weaponval,1		;weapon no kazu
	malc	km_player2HP,1			;Hit Point
	malc	km_player2pilot,1		;pilot no syurui
	km_malclabelend		player2param

;---------------------------------------------------------------------
;* kawaguchi Mario RAM Area *
	malc	m_planetcnt,2
	malc	m_planetptr,2
	malc	m_planetlen,2

	malc	m_planetdrawtmpbuf,0
	km_worklabelstart	m_planetdrawtmpbuf
	km_worklabel	w,mmm_planetcx		; 2 byte
	km_worklabel	w,mmm_planetcy		; 2 byte
	km_worklabel	w,mmm_planetR		; 2 byte
	km_worklabel	w,mmm_planetsprite	; 2 byte

;;;;	km_worklabel	w,mmm_scrcx		; 2 byte
;;;;	km_worklabel	w,mmm_scrcy		; 2 byte

	km_worklabellen	m_planetdrawlen		; length
	km_workvalcheck  16
	malc	m_planetdrawbuf,planetkazumax*m_planetdrawlen

;* kawaguchi Mario RAM Area *
;---------------------------------------------------------------------
