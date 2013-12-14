note
	description: "Summary description for {GT_GUI_PICK_CARD_WINDOW}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GT_GUI_PICK_CARD_WINDOW

inherit
	EV_HORIZONTAL_BOX
	GT_GUI_CONSTANTS
		export
			{NONE} all
		undefine
			default_create, copy, is_equal
		end

create
	make

feature {NONE}-- Initialization
	player : GT_LOGIC_PLAYER

	make(a_player : GT_LOGIC_PLAYER)
	do
		default_create
		player := a_player
		initialize_component
	end

	initialize_component
		do

			create popup_con
			color_bw(popup_con)
			build_container

			extend(popup_con)

		end



feature {NONE}
	popup_con : EV_FIXED
	a : GT_LOGIC_DECK_PLOT[GT_LOGIC_CARD_PLOT]

	build_container
	local
	do
		a := player.get_cards_in_plot_deck
		select_plot_card(a)
	end

	select_plot_card(plot_deck : GT_LOGIC_DECK_PLOT[GT_LOGIC_CARD_PLOT])
		require
			plot_deck_not_void: plot_deck /= Void
			cards_left: plot_deck.size >= 1
		local
			card_img : EV_PIXMAP
			card1, card2, card3, next_button : EV_BUTTON
			instruction_label : EV_LABEL
			card : GT_LOGIC_CARD_PLOT
			new_deck: ARRAYED_LIST[GT_LOGIC_CARD_PLOT]
		do
			create instruction_label.make_with_text ("Select a plot card for this round:")
			instruction_label.set_minimum_width (1000)
			popup_con.set_minimum_height (600)

			color_bw(instruction_label)
			instruction_label.set_font (STANDARD_FONT)
			create card_img
			create card1
			create card2
			create card3
			create next_button
			card_img.set_with_named_file (file_system.pathname_to_string (gt_img("arrow_right.png", false)))
			next_button.set_pixmap (card_img)
			create new_deck.make (4)
			if plot_deck.size > 0 then
				card := plot_deck.pop
				new_deck.put_front (card)
				card_img := get_image(card.unique_id, false)
				if card_img /= Void then
					card1.set_pixmap (card_img)
					card1.select_actions.extend( agent on_card_selected(card.unique_id))
				end
				popup_con.extend_with_position_and_size (card1, 0, 230, 290, 200)
			end
			if plot_deck.size > 0 then
				card := plot_deck.pop
				new_deck.put_front (card)
				card_img := get_image(card.unique_id, false)
				if card_img /= Void then
					card2.set_pixmap (card_img)
					card2.select_actions.extend( agent on_card_selected(card.unique_id))
				end
				popup_con.extend_with_position_and_size (card2, 290, 230, 290, 200)
			end
			if plot_deck.size > 0 then
				card := plot_deck.pop
				new_deck.put_front (card)
				card_img := get_image(card.unique_id, false)
				if card_img /= Void then
					card3.set_pixmap (card_img)
					card3.select_actions.extend( agent on_card_selected(card.unique_id))
				end
				popup_con.extend_with_position_and_size (card3, 580, 230, 290, 200)
			end
			plot_deck.push_bottom (new_deck)
			next_button.select_actions.extend (agent select_plot_card(plot_deck))
			popup_con.extend_with_position_and_size (next_button, 870, 230, 120, 197)
			popup_con.extend_with_position_and_size (instruction_label, 0, 200, 1000, 30)
			popup_con.show

		end

		on_card_selected(card_id : INTEGER)
		do
			player.play (card_id)
			hide
		end
end
