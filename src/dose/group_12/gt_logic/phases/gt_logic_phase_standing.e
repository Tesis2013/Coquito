note
	description: "Summary description for {GT_LOGIC_PHASE_STANDING}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GT_LOGIC_PHASE_STANDING

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
		phase := {GT_CONSTANTS}.phase_standing
	end


	-- TODO: Take into account playing text effects.

	start_phase
	do
		across player_1.get_cards_in_play_as_arrayed_list as card
		loop
			card.item.kneeling := true
		end
	end

	is_card_playable_in_phase(card_id: INTEGER_32; player_object: GT_LOGIC_PLAYER) : BOOLEAN
	--checks if the card can be played in this phase.
	do
		result := FALSE --no cards are playable in this phase.
	end

	stand_card(player_object: GT_LOGIC_PLAYER): BOOLEAN
	do

	end

feature {NONE} -- Implementation

invariant
	invariant_clause: True -- Your invariant here

end
