note
	description	: "Artificial Inteligence of Game of Thones card game"
	author		: "RioCuarto2"
	date		: "11/12/2013"
	revision	: ""

deferred class
	GT_AI

feature -- Initialization

	make(player:GT_LOGIC_PLAYER; board:GT_LOGIC_BOARD)
			-- Constructor of the AI
		require
				initialized_player: player/=Void
				initialized_board: board/=Void
		deferred

		ensure
			player=ai_player and ai_board=board
		end

feature -- Play

	make_move
			--this method defines the player's actions depending the game state
		require
				initialized_player: ai_player/=Void
				initialized_board: ai_board/=Void
		do
			if  (attached {GT_LOGIC_PHASE_PLOT} ai_board.get_current_phase  as plot_phase) then
				-- Actions in the plot phase
				ai_player.play_plot_card (choose_plot_card.unique_id)
				-- if ("Have iniciative" method of Logic) then
					-- choose_cede_initiative	
			    -- end
			elseif (attached {GT_LOGIC_PHASE_DRAW} ai_board.get_current_phase as draw_phase) then
				-- Actions in the draw phase
			elseif (attached {GT_LOGIC_PHASE_CHALLENGES} ai_board.get_current_phase as challenges_phase) then
				-- Actions in the challenges phase
				if ai_player.is_player_turn then
					if choose_challenge="military" then
						military_challenge_used := True
						ai_player.choose_challenge_type ({GT_CONSTANTS}.challenge_type_military)
						choose_attack({GT_CONSTANTS}.challenge_type_military)
					elseif choose_challenge="intrigue" then
						intrigue_challenge_used := True
						ai_player.choose_challenge_type ({GT_CONSTANTS}.challenge_type_intrigue)
						choose_attack({GT_CONSTANTS}.challenge_type_intrigue)
					elseif choose_challenge="power" then
						power_challenge_used := True
						ai_player.choose_challenge_type ({GT_CONSTANTS}.challenge_type_power)
						choose_attack({GT_CONSTANTS}.challenge_type_power)
					elseif choose_challenge="no challenge" then
	                    ai_player.end_action
					end
				else
					choose_defense (challenges_phase)
				end
			elseif (attached {GT_LOGIC_PHASE_DOMINANCE} ai_board.get_current_phase as dominance_phase) then
				-- Actions in the dominace phase
			elseif (attached {GT_LOGIC_PHASE_MARSHALLING} ai_board.get_current_phase as marshalling_phase) then
				-- Actions in the marshalling phase
			elseif (attached {GT_LOGIC_PHASE_SETUP} ai_board.get_current_phase as setup_phase) then
				-- Actions in the setup phase
				if 	change_initial_card then
					-- Call method to change for others 7 cards
				end
				choose_initial_cards
			elseif (attached {GT_LOGIC_PHASE_STANDING} ai_board.get_current_phase as standing_phase) then
				-- Actions in the standing phase
			elseif (attached {GT_LOGIC_PHASE_TAXATION} ai_board.get_current_phase as taxation_phase) then
				-- Actions in the taxation phase
				military_challenge_used := False
				intrigue_challenge_used := False
				power_challenge_used := False
			else
				-- If incorrect phase intelligent player does nothing, lets move on to the next phase
				ai_player.end_action
			end
			ai_player.end_turn
		end

feature {NONE} -- Attributes

	ai_player: GT_LOGIC_PLAYER
		-- A reference to the player managed by the AI
	ai_board: GT_LOGIC_BOARD
		-- A reference to actual state of the game

	military_challenge_used: BOOLEAN
		--Whether in round and this type of challenge was performed
	intrigue_challenge_used: BOOLEAN
		--Whether in round and this type of challenge was performed
	power_challenge_used: BOOLEAN
		--Whether in round and this type of challenge was performed

feature -- Random

	random_integer(n: INTEGER) : INTEGER
			-- Return a random number between 1 and n
		require
			n > 1
		local
			l_time: TIME
			l_seed: INTEGER
		do
			create l_time.make_now
			l_seed := l_time.hour
			l_seed := l_seed * 60 + l_time.minute
			l_seed := l_seed * 60 + l_time.second
			l_seed := l_seed * 1000 + l_time.milli_second
			create random_sequence.set_seed (l_seed)
			random_sequence.forth
			Result := random_sequence.item \\ n + 1
		ensure
			Result <= n and Result > 0
		end

feature {NONE} -- Implementation

	random_sequence: RANDOM
		-- Random sequence

feature -- Access

	get_player: GT_LOGIC_PLAYER
			-- return player
		do
			Result := ai_player
		ensure
			Result = ai_player
		end

	get_board: GT_LOGIC_BOARD
			-- return board
		do
			Result := ai_board
		ensure
			Result = ai_board
		end

feature -- Element change

	set_player(player:GT_LOGIC_PLAYER)
			-- change player
		require
			initialized_player: player/=Void
		do
			ai_player := player
		ensure
			player = ai_player
		end

	set_board(board:GT_LOGIC_BOARD)
			-- change board
		require
			initialized_board: board /= Void
		do
			ai_board := board
		ensure
			board = ai_board
		end

feature -- Deferred methods

	change_initial_card: BOOLEAN
		require
			cards_in_hand: ai_player.get_cards_in_hand.size > 0
			appropriate_phase: attached {GT_LOGIC_PHASE_SETUP} ai_board.get_current_phase
			-- Not have changed the cards before
		deferred
		end

	choose_plot_card : GT_LOGIC_CARD_PLOT
		require
			appropiate_phase: attached {GT_LOGIC_PHASE_PLOT} ai_board.get_current_phase
		deferred
		ensure
			ai_player.get_cards_in_plot_deck.contain (Result.unique_id)
		end

	choose_attack (challenge: STRING)
			-- Choose attack cards
		require
			appropriate_phase: attached {GT_LOGIC_PHASE_CHALLENGES} ai_board.get_current_phase
			correct_challenge: 	challenge = {GT_CONSTANTS}.challenge_type_intrigue or
								challenge = {GT_CONSTANTS}.challenge_type_military or
								challenge = {GT_CONSTANTS}.challenge_type_power
			-- ai_player is attacker
		deferred
		end

	choose_defense (phase: GT_LOGIC_PHASE_CHALLENGES)
			-- Choose defense cards
		require
			appropriate_phase: attached {GT_LOGIC_PHASE_CHALLENGES} ai_board.get_current_phase
			-- ai_player is defender
		deferred
		end

	choose_cards_to_recruit
			-- Choose cards to rescuit in Marshalling Phase
		require
			ai_player.get_cards_in_hand.size > 0
			appropriate_phase: attached {GT_LOGIC_PHASE_MARSHALLING} ai_board.get_current_phase
		deferred
		end

	choose_initial_cards
			-- Choose initial cards to put in play
		require
			count_dragon_gold: ai_player.gold_dragon_tokens = 5
			appropriate_phase: attached {GT_LOGIC_PHASE_SETUP} ai_board.get_current_phase
		deferred
		end

	choose_cede_initiative
			-- Decides whether or not the initiative gives
		require
			-- Have won the initiative.
			appropriate_phase: attached {GT_LOGIC_PHASE_PLOT} ai_board.get_current_phase
		deferred
		end

	choose_challenge: STRING
			--choose that challenges do
		require
			appropriate_phase: attached {GT_LOGIC_PHASE_CHALLENGES} ai_board.get_current_phase
		deferred
		ensure
			correct_challenge: Result = "no challenge" or Result = {GT_CONSTANTS}.challenge_type_intrigue or Result = {GT_CONSTANTS}.challenge_type_military or Result = {GT_CONSTANTS}.challenge_type_power
		end

	choose_cards_to_kill
		--choose that cards kill
	require
		appropriate_phase: attached {GT_LOGIC_PHASE_CHALLENGES} ai_board.get_current_phase
	deferred
	ensure
		old ai_player.get_cards_in_play.size > ai_player.get_cards_in_play.size
	end

invariant
	initialized_player: ai_player/=Void
	initialized_board: ai_board/=Void

end -- class GT_AI
