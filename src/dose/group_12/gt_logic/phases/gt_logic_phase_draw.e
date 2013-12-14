note
	description: "[
					{GT_LOGIC_PHASE_DRAW}  is the implementation of the draw phase of the card game.
			     	This phase is preceeded by the setup_phase (if first round) or the taxation phase in the previous round.
					]"
	author: "ITU14"
	date: "$Date$"
	revision: "$Revision$"

class
	GT_LOGIC_PHASE_DRAW

inherit
	GT_LOGIC_PHASE
	redefine is_card_playable_in_phase, make, start_phase
	end

create
	make

feature {ANY}
	make(player_one : GT_LOGIC_PLAYER; player_two : GT_LOGIC_PLAYER; board : GT_LOGIC_BOARD)
	--called from the phase handler. This initiates any needed variables.
	do
		Precursor(player_one, player_two, board)
		phase := {GT_CONSTANTS}.phase_draw
	end

	start_phase
	-- This is the draw phase, both players draw 2 cards each
	do
		player_1.draw (2)
		player_2.draw (2)
	end

is_card_playable_in_phase(card_id: INTEGER_32; player_object: GT_LOGIC_PLAYER) : BOOLEAN
do
	result := FALSE --no cards can be played in the draw phase
end

feature {NONE} -- Implementation

invariant
	invariant_clause: True -- Your invariant here

end
