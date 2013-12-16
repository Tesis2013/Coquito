note
	description: "Test class for {GT_AI_TEST}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TEST_GT_AI_EASY


inherit
	EQA_TEST_SET
	rename
		default_create as gt_test_default_create
	redefine
		on_prepare
		select gt_test_default_create
	end



	GT_LOGIC_BOARD
		rename
			default_create as gt_board_default_create,
			make as gt_board_make
		end
	GT_AI_EASY
		rename
			default_create as gt_ai_easy_default_create,
			make as gt_ai_easy_make
		end
	GT_LOGIC_HANDLER_PHASE
		rename
			make as gt_handler_make,
			current_phase as handler_current_phase,
			get_current_phase as handler_get_current_phase
		end

--	GT_LOGIC_PLAYER
--		rename
--			default_create as gt_default_create_player,
--			make as make_player
--	end



feature {NONE}
	player_ai : GT_LOGIC_PLAYER
	player_human : GT_LOGIC_PLAYER
	house_deck_stark : STRING

feature
	-- For each tests we set up the logic state, such that the AI is able to make valid moves.
	on_prepare
		do
			-- Create a house deck (stark) to be given to both players (each will have their own identical house deck)


			-- (Instantiate player as AI, with house Stark)
			create player_ai.make(FALSE, {GT_CONSTANTS}.house_stark, TRUE)

			-- (Instantiate player as human, with house Stark)
			create player_human.make(TRUE, {GT_CONSTANTS}.house_stark, FALSE)

			-- Use this instance as the board and set players.
			-- used on current, since we need access to private fields
			gt_board_make(player_ai, player_human)

			-- instantiate the AI implementation (easy)
			gt_ai_easy_make (player_ai, current) -- TODO: maybe get_logic_board instead.
		end


-- Test to make sure that the player is correctly set in the AI.
feature
	test_set_player
	note
		testing: "covers/{GT_AI}.set_player"
		testing: "GT/GT_AI"
		testing: "user/GT"
	do
			-- Set the player of the AI
			set_player (player_ai)

			-- Make sure that the player is correctly retrieved.
			assert("The player was not correctly set", get_player = player_ai)
	end

	test_set_board
	note
		testing: "covers/{GT_AI}.set_board"
		testing: "GT/GT_AI"
		testing: "user/GT"
	do
		-- Set the player of the AI
		set_board (current)

		-- Make sure that the player is correctly retrieved.
		assert("The board was not correctly set", get_board = current)
	end

	test_change_initial_card
    	note
    	testing: "cover/{GT_AI}.change_initial_card"
		testing: "GT/GT_AI"
		testing: "user/GT"
    	do
    		assert("phase setup", get_current_phase.get_phase_identifer = {GT_CONSTANTS}.phase_setup)
    		-- cards are then loaded this phase. Error of logic
			assert("in the interval" , change_initial_card.item = True or change_initial_card.item = False)
    	end

	test_choose_draw_deck
	note
		testing: "cover/{GT_AI}.choose_draw_deck"
		testing: "GT/GT_AI"
		testing: "user/GT"
	do
	end

	test_choose_plot_card
	note
		testing: "cover/{GT_AI}.choose_plot_card"
		testing: "GT/GT_AI"
		testing: "user/GT"
	local
		old_size : INTEGER
	do
		-- Check the state of the plot deck
		assert("Complete plot deck", ai_player.get_cards_in_plot_deck.size = 7)

		assert("phase setup", phase_handler.get_current_phase.get_phase_identifer = {GT_CONSTANTS}.phase_setup)

		player_human.end_turn

		player_ai.end_turn
		assert("plot phase", phase_handler.get_current_phase.get_phase_identifer = {GT_CONSTANTS}.phase_plot)
		old_size := player_ai.get_cards_in_plot_deck.size
		make_move

		assert("The used plot pile should be empty", player_ai.get_cards_in_used_plot_pile.size = 0)

		assert("Plot deck size", player_ai.get_cards_in_plot_deck.size = old_size - 1)

		assert("The plot deck not contain the plot card used for ai_player", not ai_player.get_cards_in_plot_deck.contain (ai_player.get_active_plot_card.unique_id))

	end

	test_choose_defense
	note
		testing: "cover/{GT_AI}.choose_defense"
		testing: "GT/GT_AI"
		testing: "user/GT"
	do
		-- set up the logic state
		handler_current_phase:= phase_challenges

	end

	test_choose_attack
	note
		testing: "cover/{GT_AI}.choose_attack"
		testing: "GT/GT_AI"
		testing: "user/GT"
	do

		-- Set up the logic state:
		handler_current_phase := phase_challenges


		-- Make sure that it is indeed the AI-players turn to attack

	end

	test_choose_cards_to_recruit
	note
		testing: "cover/{GT_AI}.choose_cards_to_recruit"
		testing: "GT/GT_AI"
		testing: "user/GT"
	do

		-- set up the logic state: give gold, cards, set phase etc.
		handler_current_phase := phase_marshalling

		-- Assert that cards are recruited

	end


	-- Test the the AI is able to make a move that leads the controlled player to be in a state where he is ready to go to the next phase (in this case the setup phase)
	test_make_move_setup_phase
	note
		testing: "covers/{GT_AI}.make_move"
		testing: "GT/GT_AI"
		testing: "user/GT"
	do
		-- Set up the initial state of the board
		-- TODO
		handler_current_phase := phase_setup

		-- Make a move
		make_move

		-- assert that the move has been made (ie. the AI player is ready for next phase)
		assert("The AI was not ready for the next phase", is_player_ready_for_next_phase(player_ai.player_id))
	end

	-- Test the the AI is able to make a move that leads the controlled player to be in a state where he is ready to go to the next phase (in this case the plot phase)
	test_make_move_plot_phase
	note
		testing: "covers/{GT_AI}.make_move"
		testing: "GT/GT_AI"
		testing: "user/GT"
	do
		-- Set up the initial state of the board
		-- TODO
		handler_current_phase := phase_plot

		-- Make a move
		make_move


		-- assert that the move has been made (ie. the AI player is ready for next phase)
		assert("The AI was not ready for the next phase", is_player_ready_for_next_phase(player_ai.player_id))
	end

	-- Test the the AI is able to make a move that leads the controlled player to be in a state where he is ready to go to the next phase (in this case the draw phase)
	test_make_move_draw_phase
	note
		testing: "covers/{GT_AI}.make_move"
		testing: "GT/GT_AI"
		testing: "user/GT"
	do
		-- Set up the initial state of the board
		-- TODO
		handler_current_phase := phase_draw

		-- Make a move
		make_move


		-- assert that the move has been made (ie. the AI player is ready for next phase)
		assert("The AI was not ready for the next phase", is_player_ready_for_next_phase(player_ai.player_id))
	end

	-- Test the the AI is able to make a move that leads the controlled player to be in a state where he is ready to go to the next phase (in this case the marshalling phase)
	test_make_move_marshalling_phase
	note
		testing: "covers/{GT_AI}.make_move"
		testing: "GT/GT_AI"
		testing: "user/GT"
	do
		-- Set up the initial state of the board
		-- TODO
		handler_current_phase := phase_marshalling


		-- Make a move
		make_move



		-- assert that the move has been made (ie. the AI player is ready for next phase)
		assert("The AI was not ready for the next phase", is_player_ready_for_next_phase(player_ai.player_id))
	end

	-- Test the the AI is able to make a move that leads the controlled player to be in a state where he is ready to go to the next phase (in this case the challenges phase)
	test_make_move_challenges_phase
	note
		testing: "covers/{GT_AI}.make_move"
		testing: "GT/GT_AI"
		testing: "user/GT"
	local
		size : INTEGER
		correct_phase : BOOLEAN
		phase : STRING
	do
		-- Set up the initial state of the board
		-- TODO
		-- I move until the phase of challenge
		from
			correct_phase := False
		until
			correct_phase
		loop
			phase := get_current_phase.get_phase_identifer
			if phase = {GT_CONSTANTS}.phase_plot then
				player_human.play_plot_card (player_human.get_cards_in_plot_deck.to_arrayed_list.array_item (0).unique_id)
				player_ai.play_plot_card (player_ai.get_cards_in_plot_deck.to_arrayed_list.array_item (0).unique_id)
			end
			if phase /= {GT_CONSTANTS}.phase_challenges then
				player_human.end_turn
				player_ai.end_turn
			else
				correct_phase := True
			end
		end

		-- Make a move
		make_move

		-- assert that the move has been made (ie. the AI player is ready for next phase)
		assert("The AI was not ready for the next phase", player_ai.is_player_ready_for_next_phase)
	end




	-- Test the the AI is able to make a move that leads the controlled player to be in a state where he is ready to go to the next phase (in this case the dominance phase)
	test_make_move_dominance_phase
	note
		testing: "covers/{GT_AI}.make_move"
		testing: "GT/GT_AI"
		testing: "user/GT"
	do
		-- Set up the initial state of the board
		-- TODO
		handler_current_phase := phase_dominance

		-- Make a move
		make_move


		-- assert that the move has been made (ie. the AI player is ready for next phase)
		assert("The AI was not ready for the next phase", is_player_ready_for_next_phase(player_ai.player_id))
	end

	-- Test the the AI is able to make a move that leads the controlled player to be in a state where he is ready to go to the next phase (in this case the standing phase)
	test_make_move_standing_phase
	note
		testing: "covers/{GT_AI}.make_move"
		testing: "GT/GT_AI"
		testing: "user/GT"
	do
		-- Set up the initial state of the board
		-- TODO
		handler_current_phase := phase_standing

		-- Make a move
		make_move


		-- assert that the move has been made (ie. the AI player is ready for next phase)
		 assert("The AI was not ready for the next phase", is_player_ready_for_next_phase(player_ai.player_id))
	end

	-- Test the the AI is able to make a move that leads the controlled player to be in a state where he is ready to go to the next phase (in this case the taxation phase)
	test_make_move_taxation_phase
	note
		testing: "covers/{GT_AI}.make_move"
		testing: "GT/GT_AI"
		testing: "user/GT"
	do
		-- Set up the initial state of the board
		-- TODO

		handler_current_phase := phase_taxation

		-- Make a move
		make_move


		-- assert that the move has been made (ie. the AI player is ready for next phase)
		 assert("The AI was not ready for the next phase", is_player_ready_for_next_phase(player_ai.player_id))
	end
end
