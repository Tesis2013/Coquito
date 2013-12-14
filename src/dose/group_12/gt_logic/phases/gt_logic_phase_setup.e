note
	description: "Summary description for {GT_LOGIC_PHASE_SETUP}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GT_LOGIC_PHASE_SETUP

inherit
	GT_LOGIC_PHASE
	redefine
		is_card_playable_in_phase, make, play, start_phase, end_phase
	end


create
	make

feature {NONE}

feature {ANY}
	make(player_one : GT_LOGIC_PLAYER; player_two : GT_LOGIC_PLAYER; board : GT_LOGIC_BOARD)
	--called from the phase handler. This initiates any needed variables.	
	do
		Precursor(player_one, player_two, board)
		phase := {GT_CONSTANTS}.PHASE_SETUP
	end

	play(card_id:INTEGER_32; player_object: GT_LOGIC_PLAYER)
	-- Play the card with this ID.
	local
		cost : INTEGER
		card_to_play : GT_LOGIC_CARD
		limited_keyword : GT_LOGIC_KEYWORD
	do
		create limited_keyword.make ({GT_CONSTANTS}.KEYWORD_LIMITED)

		-- Subtract the gold cost of card from the player
		cost := player_object.get_cards_in_hand.get_card_by_id (card_id).cost
		game_board.take_gold_dragon_token (player_object.player_id, cost)

		-- If limited card, make sure it is only played once
		if (card_to_play.keywords.has (limited_keyword)) then
			player_object.has_played_limited := true
		end

		-- TODO: Cards that are placed in this phase, should not trigger the in_play state, since they are not considered to be in play (see rules)

	end

	start_phase
	-- This will start the setup phase, giving each player 5 gold and draw 7 cards
	do
		-- give 5 gold to each player
		game_board.give_gold_dragon_token (player_1.player_id, 5)
		game_board.give_gold_dragon_token (player_2.player_id, 5)


		check player_one_had_played_limited_in_setup_phase : player_1.has_played_limited = false end
		check player_two_had_played_limited_in_setup_phase : player_2.has_played_limited = false end

		-- Draw 7 cards for each player
		player_1.draw (7)
		player_2.draw (7)

		-- Assert that players have the correct amount of cards
		check correct_cards_in_hand: player_1.get_cards_in_hand.size = 7 end
		check correct_cards_in_hand: player_2.get_cards_in_hand.size = 7 end
	end

	end_phase
	-- Ends the setup-phase, removing gold and resupplying cards
	local
		player_one_cards_to_draw : INTEGER
		player_two_cards_to_draw : INTEGER
	do
		player_1.gold_dragon_tokens := 0 -- the 5 starting gold is removed from both players.
		player_2.gold_dragon_tokens := 0

		-- Players should redraw until they have 7 cards in hand.
		player_one_cards_to_draw := (7 - player_1.get_cards_in_hand.size)
		player_two_cards_to_draw := (7 - player_2.get_cards_in_hand.size)

		player_1.draw (player_one_cards_to_draw)
		player_2.draw (player_two_cards_to_draw)

		check player_1.get_cards_in_hand.size = 7 end
		check player_2.get_cards_in_hand.size = 7 end

	end


	is_card_playable_in_phase(card_id: INTEGER_32; player_object: GT_LOGIC_PLAYER) : BOOLEAN
	--redefines to check if the player can afford the card.
	local
		card_to_play : GT_LOGIC_CARD
		limited_keyword : GT_LOGIC_KEYWORD
		unique_keyword : GT_LOGIC_KEYWORD
		unique_cards_in_play : ARRAYED_LIST[GT_LOGIC_CARD]
		has_failed : BOOLEAN
	do
		create limited_keyword.make ({GT_CONSTANTS}.keyword_limited)
		create unique_keyword.make ({GT_CONSTANTS}.keyword_unique)

		-- Check if the card is playable
		card_to_play := player_object.get_card_by_id (card_id)

		-- Does the player have the card in his hand?
		if (not player_object.get_cards_in_hand.contain (card_id)) then
			has_failed := true
		end

		-- Can the player afford the playing cost of the card?
		if (not is_card_affordable (card_id, player_object)) then
			has_failed := true
		end

		-- Has the player already played a card with the limited keyword?
		if (card_to_play.keywords.has(limited_keyword) and player_object.has_played_limited) then
			has_failed := true
		end

		-- Should not be able to place duplicates of a unique card (see rules)
		if card_to_play.keywords.has (unique_keyword) then
			unique_cards_in_play := player_object.get_cards_in_play.get_cards_by_keyword (unique_keyword)
			if unique_cards_in_play /= void and unique_cards_in_play.count > 0 then
				has_failed := true
			end
		end

		-- If the player violated one of the previous checks, then the card is not playable.
		if not has_failed then
			result := true
		end
	end

feature {NONE} -- Implementation

invariant
	invariant_clause: True -- Your invariant here

end
