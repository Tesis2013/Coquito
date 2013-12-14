note
	description: "Summary description for {GT_LOGIC_PHASE_PLOT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GT_LOGIC_PHASE_PLOT

inherit
	GT_LOGIC_PHASE
		redefine
			is_card_playable_in_phase, make, play_plot_card, start_phase, end_phase
		end

create
	make

feature {ANY}
	make (player_one : GT_LOGIC_PLAYER; player_two : GT_LOGIC_PLAYER; board : GT_LOGIC_BOARD)
	--called from the phase handler. This initiates any needed variables.
	do
		Precursor(player_one, player_two, board)
		phase := {GT_CONSTANTS}.phase_plot
	end

	start_phase
	do
		game_board.gui_open_plot_selection_window
	end

	play_plot_card(card_id: INTEGER_32; player_object: GT_LOGIC_PLAYER)
	--
	local
		chosen_plot_card : GT_LOGIC_CARD_PLOT
		old_active_plot_card : GT_LOGIC_CARD_PLOT
		tuple : TUPLE[GT_LOGIC_CARD, GT_LOGIC_TEXT_EFFECT]
	do
		chosen_plot_card := player_object.get_active_plot_card -- The card has already been selected by the player -- TODO clean up plot card code
		game_board.give_gold_dragon_token (player_object.player_id, chosen_plot_card.income)
		check player_object.gold_dragon_tokens = chosen_plot_card.income end -- The player should only have the income gold from the plot card at this point

		-- Asserts that the old plot card is moved correctly.
		if(old_active_plot_card /= void) then
				check old_active_plot_card /= chosen_plot_card end
				check player_object.get_cards_in_used_plot_pile.contain (old_active_plot_card.unique_id) end
		end
		if(player_object.get_active_plot_card /= void) then
			-- Assert that the chosen plot card is the active plot card.
			check player_object.get_active_plot_card.unique_id = card_id end
		end

		tuple := player_object.contains_text_effect ("L57")
		if
			tuple /= void
		then
			if
				attached {GT_LOGIC_CARD} tuple.item (1) as card AND attached {GT_LOGIC_TEXT_EFFECT} tuple.item (2) as text
			then
				text.play_simple (card, player_object)
			end
		end
	end


	is_card_playable_in_phase(card_id: INTEGER_32; player_object: GT_LOGIC_PLAYER) : BOOLEAN
	--redefines to look through the plot_deck. Only plot decks can be played from during this phase.
	local
		has_failed : BOOLEAN
	do

		if player_object.player_id = 1 then
			if
				player_one_has_played_plot_card = true
			then
				has_failed := true
			end
		else if player_object.player_id = 2 then
			if
				player_two_has_played_plot_card = true
			then
				has_failed := true
			end
		else
			check invalid_player_id : false end
			end
		end

		-- has_failed := not player_object.get_cards_in_plot_deck.contain (card_id) -- It has already been removed in the player code.

		result := not has_failed -- If nothing has failed so far, card is playable
	end

	end_phase
	local
		total_gold_modifier_player_one : INTEGER
		total_gold_modifier_player_two : INTEGER
		player_one_cards_in_play : ARRAYED_LIST[GT_LOGIC_CARD]
		player_two_cards_in_play : ARRAYED_LIST[GT_LOGIC_CARD]
	do
		-- calculate the gold for each player at this point in the game.
		player_1.gold_dragon_tokens := player_1.get_active_plot_card.income
		player_2.gold_dragon_tokens := player_2.get_active_plot_card.income

		player_one_cards_in_play := player_1.get_cards_in_play_as_arrayed_list
		player_two_cards_in_play := player_2.get_cards_in_play_as_arrayed_list

		across
			player_one_cards_in_play as card
		loop
			total_gold_modifier_player_one := total_gold_modifier_player_one + card.item.gold_modifier
		end

		across
			player_two_cards_in_play as card
		loop
			total_gold_modifier_player_two := total_gold_modifier_player_two + card.item.gold_modifier
		end

		player_1.gold_dragon_tokens := player_1.gold_dragon_tokens + total_gold_modifier_player_one
		player_2.gold_dragon_tokens := player_2.gold_dragon_tokens + total_gold_modifier_player_two

		-- Now decide the starting player
		if player_1.get_active_plot_card.initiative >= player_2.get_active_plot_card.initiative then
			player_1.set_is_player_turn(true)
		else
			player_2.set_is_player_turn(true)
		end
	end

feature {NONE} -- Implementation
	player_one_has_played_plot_card : BOOLEAN
	player_two_has_played_plot_card : BOOLEAN

invariant
	invariant_clause: True -- Your invariant here

end
