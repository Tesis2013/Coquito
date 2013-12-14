note
	description: "Summary description for {GT_LOGIC_PHASE_TAXATION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GT_LOGIC_PHASE_TAXATION

inherit
	GT_LOGIC_PHASE
	redefine
		is_card_playable_in_phase, make, start_phase
	end

create
	make

feature {ANY}
	make (player_one : GT_LOGIC_PLAYER; player_two : GT_LOGIC_PLAYER; board : GT_LOGIC_BOARD)
	--called from the phase handler. This initiates any needed variables.
	do
		Precursor(player_one, player_two, board)
		phase := {GT_CONSTANTS}.phase_taxation
	end

	start_phase
	do
		game_board.take_gold_dragon_token (player_1.player_id, player_1.gold_dragon_tokens)
		game_board.take_gold_dragon_token (player_2.player_id, player_2.gold_dragon_tokens)
	end

	is_card_playable_in_phase(card_id: INTEGER_32; player_object: GT_LOGIC_PLAYER) : BOOLEAN
	--checks if the card can be played in this phase.
	do
		result := FALSE --no cards are playable in this phase.
	end

feature {NONE} -- Implementation

invariant
	invariant_clause: True -- Your invariant here

end
