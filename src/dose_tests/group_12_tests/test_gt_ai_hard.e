note
	description	: "Test class for {TEST_GT_AI_HARD}."
	author		: "RioCuarto2"
	date		: "17/12/2013"
	revision	: "$Revision$"

class
	TEST_GT_AI_HARD

inherit
	EQA_TEST_SET
	rename
		default_create as gt_test_default_create
	redefine
		on_prepare
		select gt_test_default_create
	end

	GT_AI_HARD
		rename
			default_create as gt_ai_hard_default_create,
			make as gt_ai_hard_make
		end
	GT_LOGIC_BOARD
		rename
			default_create as gt_board_default_create,
			make as gt_board_make
		end
	GT_LOGIC_HANDLER_PHASE
		rename
			make as gt_handler_make,
			current_phase as handler_current_phase,
			get_current_phase as handler_get_current_phase
		end

feature {NONE}
	player_ai : GT_LOGIC_PLAYER
	player_human : GT_LOGIC_PLAYER

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

			-- instantiate the AI implementation (hard)
			gt_ai_hard_make (player_ai, current) -- TODO: may be get_logic_board instead.
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

	test_choose_cards_to_recruit
		note
			testing: "cover/{GT_AI}.choose_cards_to_recruit"
			testing: "GT/GT_AI"
			testing: "user/GT"
		local
			correct_phase: BOOLEAN
			phase: STRING
    		do

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
				if phase /= {GT_CONSTANTS}.phase_marshalling then
					player_human.end_turn
					player_ai.end_turn
				else
					correct_phase := True
				end
			end -- end to correct phase
			player_ai.get_cards_in_play.make
			player_ai.get_cards_in_hand.make
	    	player_ai.get_cards_in_hand.add_card (player_ai.get_cards_in_house_deck.get_card_by_id (11)) -- military
			player_ai.get_cards_in_hand.add_card (player_ai.get_cards_in_house_deck.get_card_by_id (6)) -- intrigue and power
			player_ai.get_cards_in_hand.add_card (player_ai.get_cards_in_house_deck.get_card_by_id (8)) -- military and power

			player_ai.get_cards_in_play.add_card (player_ai.get_cards_in_house_deck.get_card_by_id (21)) -- power
			player_ai.get_cards_in_play.add_card (player_ai.get_cards_in_house_deck.get_card_by_id (15))  -- military

			choose_cards_to_recruit

			assert("check card in play", player_ai.get_cards_in_play.contain (6))
		end


	-- Test the the AI is able to make a move that leads the controlled player to be in a state where he is ready to go to the next phase (in this case the setup phase)
	test_make_move_setup_phase
		note
			testing: "covers/{GT_AI}.make_move"
			testing: "GT/GT_AI"
			testing: "user/GT"
		local
			phase: STRING
			correct_phase: BOOLEAN
		do
			-- Set up the initial state of the board
			-- TODO
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
				if phase /= {GT_CONSTANTS}.phase_marshalling then
					player_human.end_turn
					player_ai.end_turn
				else
					correct_phase := True
				end
			end

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
		local
			phase: STRING
			correct_phase: BOOLEAN
		do
			-- Set up the initial state of the board
			-- TODO
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
				if phase /= {GT_CONSTANTS}.phase_marshalling then
					player_human.end_turn
					player_ai.end_turn
				else
					correct_phase := True
				end
			end

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
		local
			correct_phase: BOOLEAN
			phase: STRING
		do
			-- Set up the initial state of the board
			-- TODO
			-- I move until the phase of marshalling
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
				if phase /= {GT_CONSTANTS}.phase_marshalling then
					player_human.end_turn
					player_ai.end_turn
				else
					correct_phase := True
				end
			end

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

	test_filter_character_cards_2
		note
			testing: "cover/{GT_AI}.filter_character_cards_2"
			testing: "GT/GT_AI"
			testing: "user/GT"
		local
			correct_phase: BOOLEAN
			phase: STRING
			cards: ARRAYED_LIST[GT_LOGIC_CARD_CHARACTER]
			i: INTEGER
		do
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
			cards := current.filter_character_cards (player_ai.get_cards_in_hand.to_arrayed_list, {GT_CONSTANTS}.challenge_type_military)

			from
				i := 0
			until
				i >= cards.count
			loop
				assert("card can participen in military challnges", cards.array_item (i).military)
				i := i + 1
			end
		end

	-- Test choose challenge in case that the users have te same cards in play
	test_choose_challenge_p01
		note
			testing: "covers/{GT_AI}.make_move"
			testing: "GT/GT_AI"
			testing: "user/GT"
		local
			correct_phase: BOOLEAN
			phase: STRING
		do
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
			player_ai.get_cards_in_play.make
			player_ai.get_cards_in_hand.make
			-- Put cards in hand
			player_ai.get_cards_in_hand.add_card (player_ai.get_cards_in_house_deck.get_card_by_id (5))
			player_ai.get_cards_in_hand.add_card (player_ai.get_cards_in_house_deck.get_card_by_id (6))
			player_human.get_cards_in_hand.add_card (player_human.get_cards_in_house_deck.get_card_by_id (5))
			player_human.get_cards_in_hand.add_card (player_human.get_cards_in_house_deck.get_card_by_id (6))
			-- Put cards in play
			player_ai.play(5)
			player_ai.play(6)
			player_human.play(5)
			player_human.play(6)

			assert("the same cards in play, No challenge?", choose_challenge = {GT_CONSTANTS}.challenge_type_military)
		end

	test_choose_attack_2
		note
			testing: "cover/{GT_AI}.choose_attack_2"
			testing: "GT/GT_AI"
			testing: "user/GT"
		local
			correct_phase: BOOLEAN
			phase: STRING
		do
			-- Set up the initial state of the board
			-- TODO
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
			if attached {GT_LOGIC_PHASE_CHALLENGES} get_current_phase as current_phase then
				-- The player ai can play all challenges
				assert("can player_ai play military challenges", current_phase.can_player_play_challenge (player_ai, {GT_CONSTANTS}.challenge_type_military))
				assert("can player_ai play intrigue challenges", current_phase.can_player_play_challenge (player_ai, {GT_CONSTANTS}.challenge_type_intrigue))
				assert("can player_ai play power challenges", current_phase.can_player_play_challenge (player_ai, {GT_CONSTANTS}.challenge_type_power))

				-- The player ai performed the attack
				choose_attack({GT_CONSTANTS}.challenge_type_military)

				assert("plays no cards for have strength zero", current_phase.player_one_attackers.is_empty)

				player_ai.end_turn
				assert("Ready for next phase", player_ai.is_player_ready_for_next_phase)
			else
				assert("ERROR", False)
			end
		end

	test_choose_attack
		note
			testing: "cover/{GT_AI}.choose_attack"
			testing: "GT/GT_AI"
			testing: "user/GT"
		local
			correct_phase: BOOLEAN
			phase: STRING
		do
			-- Set up the initial state of the board
			-- TODO
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
			if attached {GT_LOGIC_PHASE_CHALLENGES} get_current_phase as current_phase then
				-- The player ai can play all challenges
				assert("can player_ai play military challenges", current_phase.can_player_play_challenge (player_ai, {GT_CONSTANTS}.challenge_type_military))
				assert("can player_ai play intrigue challenges", current_phase.can_player_play_challenge (player_ai, {GT_CONSTANTS}.challenge_type_intrigue))
				assert("can player_ai play power challenges", current_phase.can_player_play_challenge (player_ai, {GT_CONSTANTS}.challenge_type_power))

				if player_ai.house_card = {GT_CONSTANTS}.house_lannister then
					-- Add character card in play
					if player_ai.get_cards_in_house_deck.contain (37) then
						player_ai.in_play_collection.add_card (player_ai.get_cards_in_house_deck.get_card_by_id (37))
					elseif player_ai.get_cards_in_hand.contain (37) then
						player_ai.in_play_collection.add_card (player_ai.get_cards_in_hand.get_card_by_id (37))
					end

					-- Add character card in play
					if player_ai.get_cards_in_house_deck.contain (40) then
						player_ai.in_play_collection.add_card (player_ai.get_cards_in_house_deck.get_card_by_id (40))
					elseif player_ai.get_cards_in_hand.contain (40) then
						player_ai.in_play_collection.add_card (player_ai.get_cards_in_hand.get_card_by_id (40))
					end

					-- Add character card in play
					if player_ai.get_cards_in_house_deck.contain (42) then
						player_ai.in_play_collection.add_card (player_ai.get_cards_in_house_deck.get_card_by_id (42))
					elseif player_ai.get_cards_in_hand.contain (42) then
						player_ai.in_play_collection.add_card (player_ai.get_cards_in_hand.get_card_by_id (42))
					end

					-- Add character card in play
					if player_ai.get_cards_in_house_deck.contain (43) then
						player_ai.in_play_collection.add_card (player_ai.get_cards_in_house_deck.get_card_by_id (43))
					elseif player_ai.get_cards_in_hand.contain (43) then
						player_ai.in_play_collection.add_card (player_ai.get_cards_in_hand.get_card_by_id (43))
					end

					choose_attack ({GT_CONSTANTS}.challenge_type_military)

					assert("cards attacking (because the player_ai has more strength than the opponent)", current_phase.player_one_attackers.count > 0 )

				elseif player_ai.house_card = {GT_CONSTANTS}.house_stark then
					-- Add character card in play
					if player_ai.get_cards_in_house_deck.contain (5) then
						player_ai.in_play_collection.add_card (player_ai.get_cards_in_house_deck.get_card_by_id (5))
					elseif player_ai.get_cards_in_hand.contain (5) then
						player_ai.in_play_collection.add_card (player_ai.get_cards_in_hand.get_card_by_id (5))
					end

					-- Add character card in play
					if player_ai.get_cards_in_house_deck.contain (16) then
						player_ai.in_play_collection.add_card (player_ai.get_cards_in_house_deck.get_card_by_id (16))
					elseif player_ai.get_cards_in_hand.contain (16) then
						player_ai.in_play_collection.add_card (player_ai.get_cards_in_hand.get_card_by_id (16))
					end

					-- Add character card in play
					if player_ai.get_cards_in_house_deck.contain (12) then
						player_ai.in_play_collection.add_card (player_ai.get_cards_in_house_deck.get_card_by_id (12))
					elseif player_ai.get_cards_in_hand.contain (12) then
						player_ai.in_play_collection.add_card (player_ai.get_cards_in_hand.get_card_by_id (12))
					end

					-- Add character card in play
					if player_ai.get_cards_in_house_deck.contain (23) then
						player_ai.in_play_collection.add_card (player_ai.get_cards_in_house_deck.get_card_by_id (23))
					elseif player_ai.get_cards_in_hand.contain (23) then
						player_ai.in_play_collection.add_card (player_ai.get_cards_in_hand.get_card_by_id (23))
					end

					choose_attack ({GT_CONSTANTS}.challenge_type_military)

					assert("cards attacking (because the player_ai has more strength than the opponent)", current_phase.player_one_attackers.count > 0 )
				end
				player_ai.end_turn
				assert("Ready for next phase", player_ai.is_player_ready_for_next_phase)
			else
				assert("ERROR", False)
			end
		end

	test_permutation
		note
			testing: "cover/{GT_AI}.test_permutation"
			testing: "GT/GT_AI"
			testing: "user/GT"
		local
			cards: ARRAYED_LIST[GT_LOGIC_CARD]
			res: ARRAYED_LIST[ARRAYED_LIST[GT_LOGIC_CARD]]
		do
			create cards.make(0)
			res := permutation (cards)
			assert("Correct Size. Cards with size zero", res.count = 0)

			cards.extend (player_ai.get_cards_in_house_deck.pop)
			res := permutation (cards)
			assert("Correct Size. Cards with size one", res.count = 1)

			cards.extend (player_ai.get_cards_in_house_deck.pop)
			res := permutation (cards)
			assert("Correct Size. Cards with size two", res.count = 3)

			cards.extend (player_ai.get_cards_in_house_deck.pop)
			res := permutation (cards)
			assert("Correct Size. Cards with size three", res.count = 7)

			cards.extend (player_ai.get_cards_in_house_deck.pop)
			res := permutation (cards)
			assert("Correct Size. Cards with size four", res.count = 15)
		end

	test_choose_initial_cards
		note
			testing: "cover/{GT_AI}.choose_initial_cards"
			testing: "GT/GT_AI"
			testing: "user/GT"
		do
			-- Add cards in hand
			player_ai.in_hand.add_card (player_ai.get_cards_in_house_deck.get_card_by_id (16))
			player_ai.in_hand.add_card (player_ai.get_cards_in_house_deck.get_card_by_id (25))
			player_ai.in_hand.add_card (player_ai.get_cards_in_house_deck.get_card_by_id (26))
			player_ai.in_hand.add_card (player_ai.get_cards_in_house_deck.get_card_by_id (27))
			player_ai.in_hand.add_card (player_ai.get_cards_in_house_deck.get_card_by_id (28))
			player_ai.in_hand.add_card (player_ai.get_cards_in_house_deck.get_card_by_id (29))
			player_ai.in_hand.add_card (player_ai.get_cards_in_house_deck.get_card_by_id (30))

			-- Add gold to player_ai
			player_ai.gold_dragon_tokens := 5

			choose_initial_cards  -- call to method

			assert("Player_ai playing the card with id 16 because is the best", player_ai.get_cards_in_play.contain (16))
		end
end
