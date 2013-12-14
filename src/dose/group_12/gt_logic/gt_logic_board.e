note
	description: "Summary description for {GT_LOGIC_BOARD}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GT_LOGIC_BOARD

inherit MUTEX
	rename
		make as make_mutex
	end

create
	make

feature {ANY} -- initialization
	make(first_player: GT_LOGIC_PLAYER; second_player: GT_LOGIC_PLAYER)
	require
		first_player /= void
		second_player /= void

	once
		player_one := first_player
		player_two := second_player
		player_one.set_game_board_and_initialize_cards (current)
		player_two.set_game_board_and_initialize_cards (current)

		treasury := 100
		power_pool := 100

		create phase_handler.make (player_one, player_two, current)
		create text_effect_handler.make(current)

		make_mutex

		-- give the players a reference to the board
		player_one.set_phase_handler (phase_handler)
		player_two.set_phase_handler (phase_handler)

	ensure
		-- TODO: Make this work
		-- phase_handler.get_current_phase.get_phase_identifer = "setup"
		player_one /= void
		player_two /= void
		treasury > 0
		power_pool > 0
	end

feature {NONE} -- variables
	power_pool : INTEGER
	treasury : INTEGER
	--ai : GT_AI moved to player

	phase_handler : GT_LOGIC_HANDLER_PHASE
	text_effect_handler : GT_LOGIC_TEXT_EFFECT_HANDLER

	player_one : GT_LOGIC_PLAYER
	player_two : GT_LOGIC_PLAYER

	gui : GT_GUI_BOARD_WINDOW


feature -- Queries
	-- How many gold dragon tokens are in the treasury?
	get_treasury_count : INTEGER

	-- How many power tokens are in the power pool?
	get_power_pool_count : INTEGER

	-- Is it this player's turn?
	is_player_turn(player : GT_LOGIC_PLAYER) : BOOLEAN
	require
	do
		result := player.is_player_turn
	ensure
	end

	-- Can I have player one?
	get_player_one : GT_LOGIC_PLAYER
	do
		result := player_one
	end

	-- Can I have player two?
	get_player_two : GT_LOGIC_PLAYER
	do
		result := player_two
	end

	-- What is the current phase?
	get_current_phase : GT_LOGIC_PHASE
	do
		result := phase_handler.get_current_phase
	end

	-- Can I have an instance of the board?
	get_logic_board : GT_LOGIC_BOARD
	do
		result := current
	end

	-- Can i get a player with this id?
	get_player_from_id(id:INTEGER) : GT_LOGIC_PLAYER
	require
		id > 0
	do
		if(player_one.player_id = id)then
			Result := player_one
		elseif(player_two.player_id = id) then
			Result := player_two
		else
			result := void
		end
	end

	is_player_ready_for_next_phase(player_id : INTEGER) : BOOLEAN
	require
		get_player_from_id (player_id) /= void
	do
		if(player_id = 1) then
			result := player_one.is_player_ready_for_next_phase
		else if player_id = 2 then
			result := player_two.is_player_ready_for_next_phase
			else
				-- TODO: Something went wrong, wrong player ID supplied	
				check false end
			end
		end
	end



feature -- Commands
	-- Give the specified player a gold dragon token
	give_gold_dragon_token(player_id: INTEGER; amount_to_give : INTEGER)
	require
		amount_to_give >= 0
	local
		player_in_question : GT_LOGIC_PLAYER
		gold : INTEGER
	do
		-- Ensure that the pool does not get negative
		if  treasury < amount_to_give then
			treasury := treasury + amount_to_give
		end

		player_in_question := get_player_from_id (player_id)
		gold := player_in_question.gold_dragon_tokens
		gold := gold + amount_to_give
		player_in_question.gold_dragon_tokens := gold
		treasury := treasury - amount_to_give
	ensure
		treasury > 0
	end

	take_gold_dragon_token(player_id: INTEGER; amount_to_take : INTEGER)
	require
		amount_to_take >= 0
		amount_to_take <= get_player_from_id (player_id).gold_dragon_tokens -- you can't take more gold than the player has
	local
		player_in_question : GT_LOGIC_PLAYER
		gold : INTEGER
	do
		player_in_question := get_player_from_id (player_id)
		gold := player_in_question.gold_dragon_tokens
		gold := gold - amount_to_take
		player_in_question.gold_dragon_tokens := gold
		treasury := treasury + amount_to_take
	ensure
		treasury > 0
	end

--	set_ai(input_ai: GT_AI)
--	--sets the ai object.
--	do
--		ai:=input_ai
--	end

	set_gui(input_gui: GT_GUI_BOARD_WINDOW)
	do
		gui := input_gui
	end


	gui_update
	-- Tell the gui that changes have been made in the players
	do
		-- Only update if a GUI has been attached.
		if gui /= void then
			gui.lock_update
			gui.update_players
			gui.unlock_update
		end
	end

	gui_show_phase(a_phase : GT_LOGIC_PHASE)
	-- Tell the gui that a new phase has started
	do
		-- Only update if a GUI has been attached.
		if gui /= void then
			gui.lock_update
			gui.show_phase (a_phase)
			gui.unlock_update
		end
	end

	gui_open_plot_selection_window
	-- Tell the GUI to show the plot selection window
	do
		-- Only update if a GUI has been attached.
		if gui /= void then
			gui.lock_update
			gui.open_plot_selection_window
			gui.unlock_update
		end
	end

	give_power_token(player_id: INTEGER; amount_to_give : INTEGER)
	-- Give the specified player x power tokens
	require
		power_pool >= 1
		amount_to_give >= 0
	local
		player_in_question : GT_LOGIC_PLAYER
		power_amount : INTEGER
	do
		-- Ensure that the pool does not get negative
		if power_pool < amount_to_give then
			power_pool := power_pool + amount_to_give
		end

		player_in_question := get_player_from_id (player_id)
		power_amount := player_in_question.power_tokens
		power_amount := power_amount + amount_to_give
		player_in_question.power_tokens := power_amount
		power_pool := power_pool - amount_to_give

		if player_in_question.power_tokens >= 15 then
			player_wins(player_in_question)
		end

	ensure
		power_pool > 0
	end

	end_turn(player_id : INTEGER)
	-- End the turn for the current player -- This will send a command over the network
	require
		get_player_from_id (player_id) /= void
	do
		-- one player ended turn so it is the other's player turn now
		if player_id = 1 then
			get_player_from_id (2).set_is_player_turn(true)
		elseif player_id = 2 then
			get_player_from_id (1).set_is_player_turn(true)
		end

		-- Only start the next phase
		if player_one.is_player_ready_for_next_phase and player_two.is_player_ready_for_next_phase then
				phase_handler.move_to_next_phase
			end

		gui_update -- need to update phase button
	end

	move_next_phase
	do
		-- Only start the next phase
		if player_one.is_player_ready_for_next_phase and player_two.is_player_ready_for_next_phase then
				phase_handler.move_to_next_phase
			end

		gui_update -- need to update phase button
	end

	kill_character(player_id, character_card_id_to_be_killed: INTEGER)
	-- Tell the GUI
	local
		player : GT_LOGIC_PLAYER
		character_killed : GT_LOGIC_CARD
	do
		player := get_player_from_id (player_id)
		character_killed := player.get_cards_in_play.remove_card_by_id (character_card_id_to_be_killed)
		player.get_cards_in_dead_pile.add_card (character_killed)
	end
	-- called from the gui with the id of which character to kill

	choose_character_to_kill_on_gui(number_of_characters_to_kill:INTEGER)
	local
		index : INTEGER
	do
		from
			index := 0
		until
			index = number_of_characters_to_kill
		loop
			gui.open_kill_characters_window
			index := index + 1
		end
	end

	discard_cards(player_id, number_of_cards_to_discard:INTEGER)
	local
		number_of_cards_on_hand : INTEGER
		loop_variant : INTEGER
		player_hand : GT_LOGIC_HAND[GT_LOGIC_CARD]
		appearently_not_so_useless_variable : GT_LOGIC_CARD
		random : RANDOM
		random_index : INTEGER
		time : TIME
	do
		create time.make_now
		create random.set_seed (time.milli_second)
		random.start
		random_index := random.item
		loop_variant := number_of_cards_to_discard

		player_hand := get_player_from_id (player_id).get_cards_in_hand
		number_of_cards_on_hand := player_hand.to_arrayed_list.count
		if number_of_cards_on_hand <= number_of_cards_to_discard then
			across player_hand.to_arrayed_list as card
			loop
				appearently_not_so_useless_variable := player_hand.remove_card_by_id(card.item.unique_id)
				get_player_from_id (player_id).get_cards_in_discard_pile.add_card (appearently_not_so_useless_variable)
			end
		else
			from
			until
				loop_variant = 0
			loop
				random_index := random.item \\ player_hand.to_arrayed_list.count
				appearently_not_so_useless_variable := player_hand.remove_card_by_id (player_hand.to_arrayed_list.at (random_index).unique_id)
				get_player_from_id (player_id).get_cards_in_discard_pile.add_card (appearently_not_so_useless_variable)
				random.forth
				loop_variant := loop_variant - 1
			end
		end
	end

	steal_power_tokens(receiving_player_id, robbed_player_id, amount_of_tokens_to_be_stolen : INTEGER)
	require
		amount_of_tokens_to_be_stolen >= 0
		get_player_from_id (robbed_player_id).power_tokens >= 0
		get_player_from_id (receiving_player_id).power_tokens >= 0
	local
		thief : GT_LOGIC_PLAYER
		victim : GT_LOGIC_PLAYER
	do
		thief := get_player_from_id (receiving_player_id)
		victim := get_player_from_id (robbed_player_id)
		if victim.power_tokens <amount_of_tokens_to_be_stolen then
			thief.power_tokens := thief.power_tokens + victim.power_tokens
			victim.power_tokens := 0
		else
			thief.power_tokens := thief.power_tokens + amount_of_tokens_to_be_stolen
			victim.power_tokens := victim.power_tokens - amount_of_tokens_to_be_stolen
		end

		--Check if the thief now has 15 or more power tokens, which is the win condition.
		if thief.power_tokens >= 15 then
			player_wins(thief)
		end
	end

	player_wins(winner: GT_LOGIC_PLAYER)
		--call this when a player wins. Should update the GUI.
		do
			--TODO When GUI has made a feature for this - call it.
		end

	set_starting_player(starting_player : GT_LOGIC_PLAYER)
	require
		starting_player /= void
	do
		if starting_player.player_id = 1 then
			player_one.set_is_player_turn (true)
		else if starting_player.player_id = 2 then
			player_two.set_is_player_turn (true)
			else
				check invalid_player_id : false end
			end
		end
		
		-- send network command
		player_one.set_starting_player (starting_player)


	end

feature {NONE} -- Implementation

invariant
	invariant_clause: True -- Your invariant here
	power_pool >= 0
	treasury >= 0

end
