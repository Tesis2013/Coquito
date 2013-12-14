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
		last_used_plot_card : GT_LOGIC_CARD_PLOT -- TODO this should be a plot card, how?.
		initial_plot_deck : GT_LOGIC_DECK_PLOT[GT_LOGIC_CARD_PLOT]
		chosen_plot_card : GT_LOGIC_CARD_PLOT
	do
		-- Check the state of the plot deck
		initial_plot_deck := player_ai.get_cards_in_plot_deck
		last_used_plot_card := initial_plot_deck.pop

		-- Go from Setup phase to -> plot phase
		phase_handler.move_to_next_phase

		assert("Not in the plot phase!", phase_handler.get_current_phase.get_phase_identifer = {GT_CONSTANTS}.phase_plot)

		-- Let the AI choose a plot card
		chosen_plot_card := choose_plot_card

		-- Assert that a new card has been selected as the plot card
		assert("The plot card was the same as before", chosen_plot_card.unique_id /= last_used_plot_card.unique_id)
		assert("The used plot pile should be empty", player_ai.get_cards_in_used_plot_pile.size = 0)

		-- Since the player hasn't chosen a plot card yet, the size of the plot deck should be exactly 7
		assert("Plot deck size invalid", player_ai.get_cards_in_plot_deck.size = 7)

		assert("The plot card was not taken from the plot deck!!!", initial_plot_deck.peek_cards (7).has (chosen_plot_card))

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
	do
		-- Set up the initial state of the board
		-- TODO
		handler_current_phase := phase_challenges

		-- Make a move
		make_move


		-- assert that the move has been made (ie. the AI player is ready for next phase)
		assert("The AI was not ready for the next phase", is_player_ready_for_next_phase(player_ai.player_id))
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
