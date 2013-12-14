note
	description: "Summary description for {GT_LOGIC_PHASE_DOMINANCE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GT_LOGIC_PHASE_DOMINANCE

inherit
	GT_LOGIC_PHASE
	redefine
		is_card_playable_in_phase, make, start_phase
	end

create
	make

feature -- creation
	make (player_one : GT_LOGIC_PLAYER; player_two : GT_LOGIC_PLAYER; board : GT_LOGIC_BOARD)
	-- called from the phase handler. This initiates any needed variables.
	do
		Precursor(player_one, player_two, board)
		phase := {GT_CONSTANTS}.phase_dominance
	end

	start_phase
	local
		player_one_total_strength : INTEGER
		player_one_total_gold : INTEGER
		player_two_total_strength : INTEGER
		player_two_total_gold : INTEGER
	do
	-- Go through all cards that are not kneeling for player 1 and calculate overall score
		across player_1.get_cards_in_play_as_arrayed_list as card
			loop
				if attached {GT_LOGIC_CARD_CHARACTER} card as card_c then
					if not card_c.kneeling then

						player_one_total_strength := player_one_total_strength + card_c.strength
						player_one_total_gold := player_one_total_gold + card_c.gold_modifier

					end
				else if attached {GT_LOGIC_CARD_LOCATION} card as card_l then
					if not card_l.kneeling	then

						player_two_total_gold := player_two_total_gold + card_l.gold_modifier

					end
				end
			end
		end

	-- Go through all cards that are not kneeling for player 2 and calculate overall score
		across player_2.get_cards_in_play_as_arrayed_list as card
			loop
				if attached {GT_LOGIC_CARD_CHARACTER} card as card_c then
					if not card_c.kneeling then
						player_two_total_strength := player_two_total_strength + card_c.strength
						player_two_total_gold := player_two_total_gold + card_c.gold_modifier
					end
				else if attached {GT_LOGIC_CARD_LOCATION} card as card_l then
					if not card_l.kneeling then
						player_two_total_gold := player_two_total_gold + card_l.gold_modifier
					end
				end
			end
		end

		player_one_total_gold := player_one_total_gold + player_1.gold_dragon_tokens
		player_two_total_gold := player_two_total_gold + player_2.gold_dragon_tokens

		-- Decide who wins and receives a token
		if player_one_total_gold + player_one_total_strength > player_two_total_gold + player_two_total_strength then
			game_board.give_power_token (player_1.player_id, 1)
		elseif player_one_total_gold + player_one_total_strength < player_two_total_gold + player_two_total_strength then
			game_board.give_power_token (player_2.player_id, 1)
		end

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
