note
	description: "Summary description for {GT_LOGIC_HANDLER_PHASE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GT_LOGIC_HANDLER_PHASE

create
	make

feature {NONE}
	--these are the different phases
	current_phase: GT_LOGIC_PHASE
	phase_setup: GT_LOGIC_PHASE_SETUP
	phase_plot: GT_LOGIC_PHASE_PLOT
	phase_draw: GT_LOGIC_PHASE_DRAW
	phase_challenges: GT_LOGIC_PHASE_CHALLENGES
	phase_marshalling: GT_LOGIC_PHASE_MARSHALLING
	phase_standing: GT_LOGIC_PHASE_STANDING
	phase_taxation: GT_LOGIC_PHASE_TAXATION
	phase_dominance: GT_LOGIC_PHASE_DOMINANCE

	player_1 : GT_LOGIC_PLAYER
	player_2 : GT_LOGIC_PLAYER

feature {ANY} -- iniialization
	make(player_one : GT_LOGIC_PLAYER; player_two : GT_LOGIC_PLAYER; board : GT_LOGIC_BOARD)
		--instantiates all the phases
		do
			game_board := board

			create phase_setup.make(player_one, player_two, board)
			create phase_plot.make(player_one, player_two, board)
			create phase_draw.make(player_one, player_two, board)
			create phase_challenges.make(player_one, player_two, board)
			create phase_marshalling.make(player_one, player_two, board)
			create phase_standing.make(player_one, player_two, board)
			create phase_taxation.make(player_one, player_two, board)
			create phase_dominance.make(player_one, player_two, board)

			current_phase := phase_setup --since this is the make, the phase will be set to the setup phase.

			-- Give each player a reference to the current phase object.
			player_one.set_phase_handler(current)
			player_two.set_phase_handler(current)

			player_1 := player_one
			player_2 := player_two
		end

	get_current_phase: GT_LOGIC_PHASE
	do
		result := current_phase
	end

	clean_phases
	local
		starting_player : GT_LOGIC_PLAYER
	do
		if player_1.get_active_plot_card /= void and player_2.get_active_plot_card /= void then
			if player_1.get_active_plot_card.initiative + player_1.get_active_plot_card.initiative_bonus >= player_2.get_active_plot_card.initiative + player_2.get_active_plot_card.initiative_bonus then
				starting_player := player_1
				player_2.set_is_player_turn (false)
			else
				starting_player := player_2
				player_1.set_is_player_turn (false)
			end
		else
			starting_player := player_1
			player_2.set_is_player_turn (false)
		end
		player_1.ready_for_next_phase := false
		player_2.ready_for_next_phase := false

		check no_starting_player : starting_player /= void end

		game_board.set_starting_player(starting_player)
	ensure
		not player_1.ready_for_next_phase
		not player_2.ready_for_next_phase
	end

	next_phase: GT_LOGIC_PHASE
	--returns the next phase object.
	do
		if current_phase = phase_setup then
				result := phase_plot
			end
			if current_phase = phase_plot then
				result := phase_draw
			end
			if current_phase = phase_draw then
				result := phase_marshalling
			end
			if current_phase = phase_marshalling then
				result := phase_challenges
			end
			if current_phase = phase_challenges then
				result := phase_dominance
			end
			if current_phase = phase_dominance then
				result := phase_standing
			end
			if current_phase = phase_standing then
				result := phase_taxation
			end
			if current_phase = phase_taxation then
				result := phase_plot
			end

	end

	move_to_next_phase
	require
		game_board.get_player_one.is_player_ready_for_next_phase and game_board.get_player_two.is_player_ready_for_next_phase
	-- changes the current phase to the next one. TODO clean the phase you just left
		do
			current_phase.end_phase
			clean_phases
			current_phase := current.next_phase
			game_board.gui_show_phase(current_phase)
			current_phase.start_phase
		end

feature {NONE}
	game_board : GT_LOGIC_BOARD
end
