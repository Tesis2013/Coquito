note
	description: "Summary description for {GT_GUI_BOX_CENTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GT_GUI_BOX_CENTER
inherit
	EV_VERTICAL_BOX
	GT_GUI_CONSTANTS
	export
		{NONE} all
	undefine
	default_create, copy, is_equal
	end
create
	make

feature
	box_center_top_challenge_area, box_center_spacer, box_center_bottom, box_center_bottom_hand, box_center_bottom_spacer : EV_HORIZONTAL_BOX
	box_center_bottom_house, box_center_bottom_cards, box_cards_in_challenge_player1, box_cards_in_challenge_player2 : EV_VERTICAL_BOX
	pixmap_center_bottom_house : EV_PIXMAP
	flip_cards_in_challenge_player1, flip_cards_in_challenge_player2, flip_cards_in_hand : GT_GUI_FLIP_VIEW
	label_center_header_phase, label_center_bottom_house, label_center_bottom_cards, label_cards_in_challenge_player1, label_cards_in_challenge_player2 : EV_LABEL
	btn_center_bottom : EV_BUTTON
	board : GT_LOGIC_BOARD

	make(a_board : GT_LOGIC_BOARD)
	do
		default_create
		board := a_board
		create label_center_header_phase
		create box_center_top_challenge_area
		--TODO: Show cards in challenge
		create box_cards_in_challenge_player1
		create label_cards_in_challenge_player1.make_with_text ("Your challenge cards")
		create flip_cards_in_challenge_player1.make (board.get_player_one.get_cards_in_hand,  {GT_CONSTANTS}.IN_CHALLENGE_STR, board.get_player_one)
		create box_cards_in_challenge_player2
		create label_cards_in_challenge_player2.make_with_text ("Player 2's challenge cards")
		create flip_cards_in_challenge_player2.make (board.get_player_two.get_cards_in_hand,  {GT_CONSTANTS}.IN_CHALLENGE_STR, board.get_player_two)
		create box_center_spacer
		create box_center_bottom
		create box_center_bottom_house
		create label_center_bottom_house.make_with_text ("Your house card")
		create pixmap_center_bottom_house
		create box_center_bottom_spacer
		create box_center_bottom_cards
		create label_center_bottom_cards.make_with_text ("Your cards in hand")
		create flip_cards_in_hand.make (board.get_player_one.get_cards_in_hand, {GT_CONSTANTS}.IN_HAND_STR, board.get_player_one)
		create btn_center_bottom

		set_minimum_width (500)

		label_center_header_phase.set_minimum_height (30)
		label_center_header_phase.set_font(STANDARD_FONT)
		color_bw(label_center_header_phase)
		extend(label_center_header_phase)

		box_center_top_challenge_area.set_minimum_height (270)
		color_bw(label_cards_in_challenge_player1)
		label_cards_in_challenge_player1.set_font (BOLD_FONT)
		box_cards_in_challenge_player1.extend(label_cards_in_challenge_player1)
		box_cards_in_challenge_player1.extend(flip_cards_in_challenge_player1)
		box_center_top_challenge_area.extend(box_cards_in_challenge_player1)

		color_bw(label_cards_in_challenge_player2)
		label_cards_in_challenge_player2.set_font (BOLD_FONT)
		box_cards_in_challenge_player2.extend(label_cards_in_challenge_player2)
		box_cards_in_challenge_player2.extend(flip_cards_in_challenge_player2)
		box_center_top_challenge_area.extend(box_cards_in_challenge_player2)
		extend (box_center_top_challenge_area)

		box_center_bottom.set_minimum_height (270)

		color_bw(label_center_bottom_cards)
		label_center_bottom_cards.set_font (BOLD_FONT)
		box_center_bottom_cards.extend(label_center_bottom_cards)
		flip_cards_in_hand.set_btn_card_select_actions (agent action_play_card)
		box_center_bottom_cards.extend(flip_cards_in_hand)
		box_center_bottom.extend(box_center_bottom_cards)
		extend (box_center_bottom)

		box_center_bottom_spacer.set_minimum_width (75)
		color_bw(box_center_bottom_spacer)
		box_center_bottom.extend (box_center_bottom_spacer)

		pixmap_center_bottom_house.set_minimum_width(175)
		pixmap_center_bottom_house.set_minimum_height(250)
		pixmap_center_bottom_house.set_with_named_file (file_system.pathname_to_string (gt_img(board.get_player_one.house_card + ".png", false)))
		pixmap_center_bottom_house.stretch (175, 250)

		color_bw(label_center_bottom_house)
		label_center_bottom_house.set_font(BOLD_FONT)
		box_center_bottom_house.extend(label_center_bottom_house)
		box_center_bottom_house.extend(pixmap_center_bottom_house)
		box_center_bottom.extend(box_center_bottom_house)

		btn_center_bottom.set_minimum_height(34)
		btn_center_bottom.set_font (STANDARD_FONT)
		color_bw(btn_center_bottom)
		extend (btn_center_bottom)
	end

	action_end_turn
	do
		if board.get_player_one.is_player_turn then
			board.get_player_one.end_turn
		end
	end

	action_play_card
	do
		if board.get_player_one.is_player_turn then
			if board.get_player_one.is_card_playable (flip_cards_in_hand.get_current_card_id) then
			print("play card " + flip_cards_in_hand.get_current_card_id.out)
				board.get_player_one.play (flip_cards_in_hand.get_current_card_id)
				flip_cards_in_hand.set_current_card(flip_cards_in_hand.get_current_card_id - 1)
				print("card in play: " + board.get_player_one.get_cards_in_play.size.out)
			end
		end
	end

feature {ANY} -- public
	disable_proceed_button
	do
		btn_center_bottom.set_text("Not your turn")
		btn_center_bottom.set_foreground_color (create {EV_COLOR}.make_with_8_bit_rgb (64, 64, 64))
		btn_center_bottom.select_actions.wipe_out
	end

	enable_proceed_button
	do
		btn_center_bottom.set_text("Proceed to next phase")
		btn_center_bottom.set_foreground_color (create {EV_COLOR}.make_with_8_bit_rgb (255, 192, 0))
		btn_center_bottom.select_actions.extend(agent action_end_turn)
	end

	set_current_phase_text(a_string : STRING)
	do
		label_center_header_phase.set_text(a_string)
	end

	get_flip_cards_in_hand : GT_GUI_FLIP_VIEW
	do
		Result := flip_cards_in_hand
	end

	get_flip_cards_in_challenge_player2 : GT_GUI_FLIP_VIEW
	do
		Result := flip_cards_in_challenge_player1
	end

	get_flip_cards_in_challenge_player1 : GT_GUI_FLIP_VIEW
	do
		Result := flip_cards_in_challenge_player1
	end
end
