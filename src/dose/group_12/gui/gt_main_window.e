note
	description: "Summary description for {GT_GUI_MAIN_WINDOW}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GT_MAIN_WINDOW

inherit
	EV_TITLED_WINDOW
		redefine
			initialize
		end

	GT_GUI_CONSTANTS
		export
			{NONE} all
		undefine
			default_create, copy
		end

create
	make

feature {NONE}
	main_ui: MAIN_WINDOW
	logic_initializer : GT_LOGIC_INITIALIZER
	board_window: GT_GUI_BOARD_WINDOW
	pick_card_window: GT_GUI_PICK_CARD_WINDOW

	main_container: EV_FIXED
	new_game_button: EV_BUTTON
	join_game_button: EV_BUTTON
	quit_button: EV_BUTTON
	stark_card_container: EV_VERTICAL_BOX
	lannister_card_container: EV_VERTICAL_BOX
	back_button: EV_BUTTON
	options_box : EV_VERTICAL_BOX
	play_ai_button_easy : EV_BUTTON
	play_ai_button_hard : EV_BUTTON
	host_button : EV_BUTTON
	or_label, ip_label, select_label, name_label, wait_label: EV_LABEL
	ip_textbox: EV_TEXT_FIELD
	ip_box: EV_HORIZONTAL_BOX
	name_textbox: EV_TEXT_FIELD
	name_box: EV_HORIZONTAL_BOX
	join_button, stark_button, lannister_button : EV_BUTTON
	current_house : STRING
	stark_img: EV_PIXMAP
	lannister_img: EV_PIXMAP

	Window_title: STRING = "Game of Thrones: The Card Game"
	window_width: INTEGER = 1000
	window_height: INTEGER = 600

	pix_background: EV_PIXMAP
		once
			create Result
			Result.set_with_named_file (file_system.pathname_to_string (gt_img("background.png", false)))
		end

	make(a_main_ui_window: MAIN_WINDOW)
		do
			main_ui := a_main_ui_window
			make_with_title (Window_title)
			disable_user_resize
			create logic_initializer
		end

	initialize
		do
			Precursor {EV_TITLED_WINDOW}

			build_main_container
			extend (main_container)
			create back_button.make_with_text_and_action ("Back to start", agent go_back)
			main_container.extend_with_position_and_size (back_button, 810, 550, 180, 40)
			back_button.hide

			create select_label.make_with_text("Please select a house:")
			create lannister_img
			create stark_img
			lannister_img.set_with_named_file(file_system.pathname_to_string (gt_img({GT_CONSTANTS}.HOUSE_LANNISTER + ".png", false)))
			stark_img.set_with_named_file(file_system.pathname_to_string (gt_img({GT_CONSTANTS}.HOUSE_STARK + ".png", false)))

			create stark_button
			stark_button.set_pixmap (stark_img)

			create lannister_button
			lannister_button.set_pixmap (lannister_img)

			close_request_actions.extend (agent request_close_window)
		end

	request_close_window
		local
			question_dialog: EV_CONFIRMATION_DIALOG
		do
			create question_dialog.make_with_text (Label_confirm_close_window)
			question_dialog.show_modal_to_window (Current)

			if question_dialog.selected_button.is_equal ((create {EV_DIALOG_CONSTANTS}).ev_ok) then
					if attached main_ui then
						main_ui.restore
						main_ui.remove_reference_to_game_window (Current)
					end
				destroy
			end
		end

	select_house
		require
			main_container_created: main_container /= Void
		do
			if lannister_button = Void and stark_button = Void then
				color_bw(select_label)
				select_label.set_font (STANDARD_FONT)
				main_container.extend_with_position_and_size (select_label, 390, 160, 150, 30)

	            main_container.extend_with_position_and_size (stark_button, 210, 200, 100, 150)
	            main_container.extend_with_position_and_size (lannister_button, 512, 200, 100, 150)

	            stark_button.select_actions.extend (agent start_new_game({GT_CONSTANTS}.HOUSE_STARK))
	            lannister_button.select_actions.extend (agent start_new_game({GT_CONSTANTS}.HOUSE_LANNISTER))
				else
					lannister_button.show
					stark_button.show
					back_button.show
					select_label.show
				end
			join_game_button.hide
			new_game_button.hide
			back_button.show

		end

	hide_feature(an_item: EV_WIDGET)
	do
		if an_item /= Void then
			an_item.hide
		end
	end

	go_back
	do
		hide_feature(back_button)
		hide_feature(play_ai_button_easy)
		hide_feature(play_ai_button_hard)
		hide_feature(host_button)
		hide_feature(or_label)
		hide_feature(ip_label)
		hide_feature(ip_textbox)
		hide_feature(ip_box)
		hide_feature(name_label)
		hide_feature(name_textbox)
		hide_feature(name_box)
		hide_feature(join_button)
		hide_feature(lannister_button)
		hide_feature(stark_button)
		hide_feature(select_label)
		hide_feature(wait_label)
		join_game_button.show
		new_game_button.show

	end


	start_new_game(house: STRING)
		do
			if current_house /= Void then
				host_button.destroy
				or_label.destroy
				play_ai_button_easy.destroy
				play_ai_button_hard.destroy
			end
				current_house := house
				create play_ai_button_easy.make_with_text_and_action ("Play against computer easy", agent start_game_with_ai(house, true))
				create play_ai_button_hard.make_with_text_and_action ("Play against computer hard", agent start_game_with_ai(house, false))
				create host_button.make_with_text_and_action ("Host a game", agent start_game_as_server(house))
				create or_label.make_with_text ("or")
				color_bw(or_label)
				or_label.set_font (STANDARD_FONT)
				if house = {GT_CONSTANTS}.HOUSE_STARK then
					main_container.extend_with_position_and_size (host_button, 520, 290, 180, 40)
					main_container.extend_with_position_and_size (or_label, 735, 300, 20, 20)
					main_container.extend_with_position_and_size (play_ai_button_easy, 780, 260, 180, 40)
					main_container.extend_with_position_and_size (play_ai_button_hard, 780, 320, 180, 40)
					lannister_button.hide
					else
						main_container.extend_with_position_and_size (host_button, 20, 290, 180, 40)
						main_container.extend_with_position_and_size (or_label, 235, 300, 20, 20)
						main_container.extend_with_position_and_size (play_ai_button_easy, 300, 260, 180, 40)
						main_container.extend_with_position_and_size (play_ai_button_hard, 300, 320, 180, 40)
						stark_button.hide
				end
			back_button.show
			select_label.hide

		end


	start_game
		require
			main_container_created: main_container /= Void
		local
			l_bg: EV_PIXMAP
			button_color: EV_COLOR
		do
			create l_bg
			l_bg.set_with_named_file (file_system.pathname_to_string (gt_img("start_screen_background.png", false)))

			create button_color.default_create
			button_color.set_rgb (1, 1, 1)
			main_container.extend_with_position_and_size (l_bg, 0, 0, 780, 780)

			--new_game_button.select_actions.extend (agent select_house)
			new_game_button.select_actions.extend (agent start_new_game({GT_CONSTANTS}.HOUSE_STARK))
			new_game_button.set_background_color (button_color)
			main_container.extend_with_position_and_size (new_game_button, 10, 450, 180, 40)


			join_game_button.select_actions.extend (agent show_join_screen)
			join_game_button.set_background_color (button_color)
			main_container.extend_with_position_and_size (join_game_button, 10, 500, 180, 40)

			quit_button.select_actions.extend (agent request_close_window)
			quit_button.set_background_color (button_color)
			main_container.extend_with_position_and_size (quit_button, 10, 550, 180, 40)

		end

start_game_with_ai(house : STRING; is_easy : BOOLEAN)
	require
		main_container_created: main_container /= Void
	local
		a_l : ARRAYED_LIST[GT_LOGIC_KEYWORD]
		board : GT_LOGIC_BOARD
	do
		if is_easy then
			board := logic_initializer.start_game_with_ai(house, true)
		else
			board := logic_initializer.start_game_with_ai(house, false)
		end
		create board_window.make(main_ui, board)
		board.lock
		board.set_gui(board_window)
		board.unlock
		board_window.show
		destroy
	end

	popup_con : EV_FIXED


	show_join_screen
		require
			main_container_created: main_container /= Void
		do
			if ip_label = Void then

				create name_label.make_with_text ("  Enter your name:  ")
				name_label.set_font (STANDARD_FONT)
				name_label.set_minimum_width (300)
				color_bw(name_label)
				create name_textbox
				name_textbox.set_minimum_width (200)
				create name_box
				name_box.extend (name_label)
				name_box.extend (name_textbox)
				name_textbox.set_font(STANDARD_FONT)
				main_container.extend_with_position_and_size (name_box, 200, 250, 250, 40)

				create ip_label.make_with_text ("  Enter an IP address:  ")
				ip_label.set_minimum_width (300)
				ip_label.set_font (STANDARD_FONT)
				color_bw(ip_label)
				create ip_textbox
				ip_textbox.set_minimum_width (200)
				create ip_box
				ip_box.extend (ip_label)
				ip_box.extend (ip_textbox)
				ip_textbox.set_font (STANDARD_FONT)
				main_container.extend_with_position_and_size (ip_box, 200, 320, 250, 40)

				create join_button.make_with_text_and_action ("Join game", agent start_game_as_client(ip_textbox.text))
				main_container.extend_with_position_and_size (join_button, 520, 390, 180, 40)
			else
				ip_label.show
				ip_box.show
				name_textbox.show
				name_box.show
				name_label.show
				ip_textbox.show
				join_button.show
			end
			new_game_button.hide
			join_game_button.hide
			back_button.show

		end

	start_game_as_server(house : STRING)
	local
		board : GT_LOGIC_BOARD
	do
		if wait_label = Void then
			create wait_label.make_with_text("Please wait")
			color_bw(wait_label)
			main_container.extend_with_position_and_size (wait_label, 0, 0, 100, 30)
		end
		wait_label.show
		create logic_initializer
		board := logic_initializer.start_game_as_server(house)
		create board_window.make(main_ui, board)
		board.lock
		board.set_gui(board_window)
		board.unlock
		board_window.show
		destroy
	end

	start_game_as_client(ip : STRING)
		require
			ip /= Void
		local
			address : INET_ADDRESS
			factory : INET_ADDRESS_FACTORY
			board : GT_LOGIC_BOARD
		do
			if ip /= Void then
				create factory
				address := factory.create_from_name (ip)
				board := logic_initializer.start_game_as_client(address)
			end
			create board_window.make(main_ui, board)
			board.lock
			board.set_gui(board_window)
			board.unlock
			board_window.show
			destroy
		end

	build_main_container
		require
			--main_container_not_yet_created: main_container = Void
		local
			l_bg: EV_PIXMAP
			l_bg_pic: EV_MODEL_PICTURE
		do
			create main_container
			main_container.set_minimum_size (window_width, window_height)
			color_bw(main_container)
			create new_game_button.make_with_text ("Start Game")
			create join_game_button.make_with_text ("Join Game")
			create quit_button.make_with_text ("Quit")

			start_game

		ensure
			main_container_created: main_container /= Void
		end

	area: EV_DRAWING_AREA

	open_card_dialog
	local
		a_dialog: EV_INFORMATION_DIALOG
	do
		create a_dialog
		a_dialog.set_width (1000)
		a_dialog.set_height (600)
		a_dialog.set_text ("")
		a_dialog.set_pixmap (get_image(161, false))
		a_dialog.show_modal_to_window (Current)
	end
end
