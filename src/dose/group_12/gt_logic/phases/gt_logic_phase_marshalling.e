note
	description: "Summary description for {GT_LOGIC_PHASE_MARSHALLING}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GT_LOGIC_PHASE_MARSHALLING

inherit
	GT_LOGIC_PHASE
	redefine is_card_playable_in_phase, make, play
		end

create
	make

feature {ANY}

	make(player_one : GT_LOGIC_PLAYER ; player_two : GT_LOGIC_PLAYER; board : GT_LOGIC_BOARD)
	--called from the phase handler. This initiates any needed variables.
	do
		Precursor(player_one, player_two, board)
		phase := {GT_CONSTANTS}.phase_marshalling
	end


	play(card_id:INTEGER_32; player_object: GT_LOGIC_PLAYER)
	--this method should count how much gold each player have spent.
	require else
		player_object.is_player_turn = true



-- TODO: Something like this check to be sure to use the reducedCost		
--		if
--			attached {GT_LOGIC_CARD_CHARACTER} card_to_play as card_c
--		then
--			if
--				card_c.house = player_object.house_card
--			then
--				if
--					card_c.cost - player_object.reducedcost >= 0
--				then
--					card_cost := card_c.cost - player_object.reducedcost
--				else
--					card_cost := 0
--				end
--			else
--				reducedCost := 0
--			end
--		else
--		end
	local
		cost : INTEGER
	do
		cost := player_object.get_card_by_id (card_id).cost
		game_board.take_gold_dragon_token (player_object.player_id, cost)
	end

	is_card_playable_in_phase(card_id: INTEGER_32; player_object: GT_LOGIC_PLAYER) : BOOLEAN
	--redefines to check if the player
	local
		has_failed : BOOLEAN
		card_to_play : GT_LOGIC_CARD
		limited_keyword : GT_LOGIC_KEYWORD
	do
		create limited_keyword.make ({GT_CONSTANTS}.KEYWORD_LIMITED)
		if not is_card_affordable (card_id, player_object) then
			has_failed := true
		end
		if (not player_object.get_cards_in_hand.contain (card_id)) then
			has_failed := true
		end

		-- Has the player already played a card with the limited keyword?
		if (player_object.get_card_by_id (card_id).keywords.has(limited_keyword) and player_object.has_played_limited) then
			has_failed := true
		end

		if not has_failed then
			result := true
		end
	end

feature {NONE} -- Implementation

invariant
	invariant_clause: True -- Your invariant here

end
