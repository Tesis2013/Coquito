note
	description: "Summary description for {GT_LOGIC_TEXT_EFFECT_HANDLER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GT_LOGIC_TEXT_EFFECT_HANDLER

create
	make

feature {ANY} -- Initialization

	make(board :GT_LOGIC_BOARD)
			-- Initialization for `Current'.
		do
			game_board := board
		end

feature {NONE} -- Variables

	game_board : GT_LOGIC_BOARD

feature -- Text effect switch

	apply_text_effect(text_effect_id:STRING; current_player_id, current_card_id:INTEGER)
	do
		if text_effect_id = "S11" then
		  shaggydog_s11 (current_player_id, current_card_id)
		elseif text_effect_id = "S25" then
		  -- text effect for 'Winterfell Castle'
		elseif text_effect_id = "S32" then
		  -- text effect for 'Godswood'
		elseif text_effect_id = "B99" then
		  -- text effect for 'Narrow Sea'
		elseif text_effect_id = "S177" then
		  -- text effect for 'Distinct Mastery'
		elseif text_effect_id = "L49" then
		  -- text effect for 'Qyburn's Informers'
		elseif text_effect_id = "L57" then
		  -- text effect for 'Golden Tooth Mines'
		elseif text_effect_id = "L64" then
		  -- text effect for 'Hall of Heroes'
		elseif text_effect_id = "L65" then
		  -- text effect for 'Sunset Sea'
		elseif text_effect_id = "L162" then
		  -- text effect for 'The Lion's Will'
		end
	end

feature {NONE} -- Text effects
	-- Naming Convention here is <the name of the card>_<text effect id>

	shaggydog_S11(current_player_id, current_card_id:INTEGER)
	local
		current_card : GT_LOGIC_CARD_CHARACTER
	do
		-- counts the number of cards on players hand with the trait "Lord"
		if count_cards_on_board_with_this_trait("Lord", current_player_id) >= 1 then
			-- if the number is equal or higher than one, then the effect is active and gives the shaggydog a STR+3 modifier
			current_card ?= game_board.get_player_from_id (current_player_id).get_cards_in_play.get_card_by_id (current_card_id)
			current_card.strength_modifier := current_card.strength_modifier + 3
		end
	end

	winterfell_castle_S25(current_player_id, current_card_id:INTEGER)
	local
		current_card : GT_LOGIC_CARD_CHARACTER
	do
		across game_board.get_player_from_id (current_player_id).get_cards_in_play_as_arrayed_list as card
		loop
			if card.item.house = {GT_CONSTANTS}.house_stark then
--				if {GT_LOGIC_CARD_CHARACTER} ?:= card.item. then
--					current_card ::= card
--					current_card.strength_modifier := current_card.strength_modifier + 1
--				end
			end
		end
	end

feature {NONE} -- Auxiliary functions

	count_cards_on_board_with_this_trait(trait : STRING; current_player_id:INTEGER) : INTEGER
	local
		count : INTEGER
	do
		count := 0
		across game_board.get_player_from_id (current_player_id).get_cards_in_play_as_arrayed_list as card
		loop
			if card.item.traits.occurrences (trait) >= 1 then
				count := count +1
			end
		end
		Result := count
	end

feature {NONE} -- Implementation

invariant
	invariant_clause: True -- Your invariant here

end
