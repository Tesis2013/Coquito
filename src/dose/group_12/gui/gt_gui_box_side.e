note
	description: "Summary description for {GT_GUI_BOX_SIDE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GT_GUI_BOX_SIDE
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

feature {NONE} --Access
	box_side, box_side_top_player_labels, box_side_top_player_values : EV_VERTICAL_BOX
	box_side_top_player, box_side_middle_cards : EV_HORIZONTAL_BOX
	label_gold, label_power, label_side_top_player_name, label_side_top_player_gold_value, label_side_top_player_power_value : EV_LABEL
	flip_cards_in_play : GT_GUI_FLIP_VIEW
	label_side_middle_cards, label_side_bottom_plotcard : EV_LABEL
	pixmap_side_bottom_plotcard : EV_PIXMAP
feature {ANY}
make(board : GT_LOGIC_BOARD; is_player_one : BOOLEAN)
	do
		default_create
		set_background_color (create {EV_COLOR}.make_with_8_bit_rgb (0, 0, 0))

			create box_side_top_player
			create label_side_top_player_name
			create box_side_top_player_labels
			create box_side_top_player_values
			create label_side_top_player_gold_value
			create label_side_top_player_power_value
			create label_side_middle_cards
			create box_side_middle_cards
			create label_side_bottom_plotcard
			create pixmap_side_bottom_plotcard
			create label_gold
			create label_power

			if is_player_one then
				label_side_top_player_name.set_text("Player 1")
				label_side_middle_cards.set_text ("Your cards in play")
				label_side_bottom_plotcard.set_text("Your plot card")
				create flip_cards_in_play.make (board.get_player_one.get_cards_in_play,  {GT_CONSTANTS}.IN_PLAY_STR, board.get_player_one)
				flip_cards_in_play.set_btn_card_select_actions(agent play_card (board))
			else
				label_side_top_player_name.set_text("Player 2")
				label_side_middle_cards.set_text ("Player 2's cards in play")
				label_side_bottom_plotcard.set_text("Player 2's plot card")
				create flip_cards_in_play.make (board.get_player_two.get_cards_in_play,  {GT_CONSTANTS}.IN_PLAY_STR, board.get_player_two)
				-- no action for enemy's cards
			end

			label_gold.set_text("Gold")
			color_bw(label_gold)
			label_power.set_text("Power Tokens")
			color_bw(label_power)

			set_minimum_width (250)

			label_side_top_player_name.set_minimum_height(30)
			label_side_top_player_name.set_font (STANDARD_FONT)

			color_bw(label_side_top_player_name)
			extend (label_side_top_player_name)

			box_side_top_player.set_minimum_height(105)
			box_side_top_player_labels.extend (label_gold)
			box_side_top_player_labels.extend (label_power)
			box_side_top_player.extend(box_side_top_player_labels)

			color_bw(label_side_top_player_gold_value)
			box_side_top_player_values.extend (label_side_top_player_gold_value)

			color_bw(label_side_top_player_power_value)
			box_side_top_player_values.extend (label_side_top_player_power_value)
			box_side_top_player.extend(box_side_top_player_values)

			extend (box_side_top_player)

			label_side_middle_cards.set_minimum_height (20)
			color_bw(label_side_middle_cards)
			label_side_middle_cards.set_font (BOLD_FONT)
			extend (label_side_middle_cards)
			box_side_middle_cards.set_minimum_height(250)
			box_side_middle_cards.extend (flip_cards_in_play)
			extend (box_side_middle_cards)

			label_side_bottom_plotcard.set_minimum_height (20)
			color_bw(label_side_bottom_plotcard)
			label_side_bottom_plotcard.set_font (BOLD_FONT)
			extend (label_side_bottom_plotcard)
			pixmap_side_bottom_plotcard.set_minimum_height (175)
			color_bw(pixmap_side_bottom_plotcard)
			extend (pixmap_side_bottom_plotcard)
	end

	get_flip_cards_in_play : GT_GUI_FLIP_VIEW
	do
		Result := flip_cards_in_play
	end

	set_power_value(power_value : INTEGER)
	do
		label_side_top_player_power_value.set_text (power_value.out)
	end

	set_gold_value(gold_value : INTEGER)
	do
		label_side_top_player_gold_value.set_text (gold_value.out)
	end

	get_pixmap_plotcard : EV_PIXMAP
	do
		Result := pixmap_side_bottom_plotcard
	end

	play_card(board : GT_LOGIC_BOARD)
	local
		card_id : INTEGER_32
	do
		card_id := flip_cards_in_play.get_current_card_id
		if card_id /= 0 then
			board.get_player_one.play(card_id)
		end
	end
end
