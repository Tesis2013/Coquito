note
	description: "Summary description for {GT_GUI_Board_WINDOW}."
	author: "Mattia Fabio"
	date: "$Date: 2010-12-22 10:39:24 -0800 (Wed, 22 Dec 2010) $"
	revision: "$Revision: 85202 $"

class
	GT_GUI_BOARD_WINDOW
inherit
	EV_TITLED_WINDOW
	GT_GUI_CONSTANTS
  export
   {NONE} all
  undefine
   default_create, copy
  end
create
	make

feature {NONE}-- Initialization
	main_ui: MAIN_WINDOW
	board: GT_LOGIC_BOARD
	box_main : EV_FIXED
	box_middle : GT_GUI_BOX_CENTER
	box_left, box_right : GT_GUI_BOX_SIDE
	select_plot_card_window : GT_GUI_PICK_CARD_WINDOW
	notification_screen : GT_GUI_NOTIFICATION_DIALOG
	challenge_button, done_button, pass_button : EV_BUTTON
	select_type : GT_GUI_SELECT_TYPE_CHALLENGE

	make(a_main_ui_window : MAIN_WINDOW; a_board : GT_LOGIC_BOARD)
	do
		main_ui := a_main_ui_window
		make_with_title ("Game of Thrones - The Card Game")
		board := a_board

		initialize_window

		update_players
		show_phase(board.get_current_phase)
	end

feature

	frozen initialize_window
		do
			create box_main
			extend(box_main)

			create box_left.make(board, true)
			box_main.extend_with_position_and_size (box_left, 0, 0, 250, 600)

			create box_middle.make(board)
			box_main.extend_with_position_and_size (box_middle, 250, 0, 500, 600)

			create box_right.make(board, false)
			box_main.extend_with_position_and_size (box_right, 750, 0, 250, 600)

			create challenge_button.make_with_text("Initiate challenge")
			create pass_button.make_with_text("Pass")
			create done_button.make_with_text("Done")
			color_bw(challenge_button)
			color_bw(pass_button)
			color_bw(done_button)
			box_main.extend_with_position_and_size (challenge_button, 0, 400, 130, 20)
			box_main.extend_with_position_and_size (pass_button, 130, 400, 60, 20)
			box_main.extend_with_position_and_size (done_button, 190, 400, 60, 20)

			create select_plot_card_window.make (board.get_player_one)
			box_main.extend_with_position_and_size (select_plot_card_window, 0, 0, 1000, 600)
			select_plot_card_window.hide

			create notification_screen.make
			box_main.extend_with_position_and_size (notification_screen, 0, 0, 1000, 600)
			notification_screen.hide

			create select_type.make(board)
			box_main.extend_with_position_and_size (select_type, 0, 0, 1000, 600)
			select_type.hide

			set_minimum_width (1000)
			set_minimum_height (600)
			set_title ("A Game of Thrones: The Card Game")
			close_request_actions.extend (agent destroy_and_exit_if_last)
			disable_user_resize
			set_position (0, 0)
		end

feature {ANY}

	pass
	do
		if board.get_player_one.is_player_turn then
			board.get_player_one.end_turn
		end
	end

	new_challenge
	do
		select_type.show
	end

	update_players
	do
		box_middle.refresh_now
			if board.get_player_one.is_player_turn then
				box_middle.enable_proceed_button
			else
				box_middle.disable_proceed_button
			end

			box_left.set_gold_value (board.get_player_one.gold_dragon_tokens)
			box_left.set_power_value (board.get_player_one.power_tokens)
			box_middle.get_flip_cards_in_hand.update_card
			box_middle.get_flip_cards_in_challenge_player1.update_card
			box_left.get_flip_cards_in_play.update_card
			if(board.get_player_one.get_active_plot_card /= Void) then
				box_left.get_pixmap_plotcard.set_with_named_file(file_system.pathname_to_string (gt_img(board.get_player_one.get_active_plot_card.unique_id.out + ".png", false)))
				box_left.get_pixmap_plotcard.stretch (250, 175)
			end

			box_right.set_gold_value (board.get_player_two.gold_dragon_tokens)
			box_right.set_power_value (board.get_player_two.power_tokens)
			box_middle.get_flip_cards_in_hand.update_card
			box_middle.get_flip_cards_in_challenge_player2.update_card
			box_right.get_flip_cards_in_play.update_card
			if(board.get_player_two.get_active_plot_card /= Void) then
				box_right.get_pixmap_plotcard.set_with_named_file(file_system.pathname_to_string (gt_img(board.get_player_two.get_active_plot_card.unique_id.out + ".png", false)))
				box_right.get_pixmap_plotcard.stretch (250, 175)
			end

		if board.get_current_phase.get_phase_identifer = {GT_CONSTANTS}.phase_challenges then
			challenge_button.select_actions.extend (agent new_challenge)
			pass_button.select_actions.extend (agent pass)
			done_button.select_actions.extend (agent done)
			challenge_button.set_foreground_color (create {EV_COLOR}.make_with_8_bit_rgb (255, 192, 0))
			pass_button.set_foreground_color (create {EV_COLOR}.make_with_8_bit_rgb (255, 192, 0))
			done_button.set_foreground_color (create {EV_COLOR}.make_with_8_bit_rgb (255, 192, 0))

		end
		if board.get_current_phase.get_phase_identifer = {GT_CONSTANTS}.phase_dominance then
			challenge_button.select_actions.wipe_out
			pass_button.select_actions.wipe_out
			done_button.select_actions.wipe_out
			color_bw(challenge_button)
			color_bw(pass_button)
			color_bw(done_button)

		end

	end

	done
	do
		board.get_player_one.end_action
	end

	show_phase(a_phase : GT_LOGIC_PHASE)
	do
		box_middle.set_current_phase_text(board.get_current_phase.get_phase_identifer)
	end

	open_plot_selection_window
	do
		select_plot_card_window.show
	end

	open_kill_characters_window
	local

	do

	end
end   --end of class
