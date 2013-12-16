note
	description: "Summary description for {GT_GUI_FLIP_VIEW}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GT_GUI_FLIP_VIEW

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

feature {NONE}
	card_counter : INTEGER
	card_pile: GT_LOGIC_CARD_COLLECTION[GT_LOGIC_CARD]
	card : GT_LOGIC_CARD
	player : GT_LOGIC_PLAYER

	btn_arrow_up, btn_arrow_down, btn_card : EV_BUTTON
	vbox_controls : EV_VERTICAL_BOX
	pixmap_card, pixmap_arrow_up, pixmap_arrow_down: EV_PIXMAP
	feature_type : STRING

	make(a_card_pile : GT_LOGIC_CARD_COLLECTION[GT_LOGIC_CARD]; type : STRING; a_player : GT_LOGIC_PLAYER)
		do
			default_create
			card_pile := a_card_pile
			feature_type := type
			player := a_player
			initialize_component
		end

	initialize_component
	do
		card_counter := 1

		set_minimum_width(250)
		set_minimum_height(250)

		--widgets
		create vbox_controls
		create btn_arrow_up
		create btn_arrow_down
		create btn_card

		--actions
		btn_arrow_up.select_actions.extend(agent scroll_up)
		btn_arrow_down.select_actions.extend(agent scroll_down)

		--arrows
		create pixmap_arrow_up
		pixmap_arrow_up.set_with_named_file(file_system.pathname_to_string (gt_img("arrow_up.png", false)))
		pixmap_arrow_up.stretch (50, 100)
		btn_arrow_up.set_pixmap(pixmap_arrow_up)
		color_bw(btn_arrow_up)

		create pixmap_arrow_down
		pixmap_arrow_down.set_with_named_file(file_system.pathname_to_string (gt_img("arrow_down.png", false)))
		pixmap_arrow_down.stretch (50, 100)
		btn_arrow_down.set_pixmap(pixmap_arrow_down)
		color_bw(btn_arrow_down)

		--general structure
		vbox_controls.set_minimum_width(75)
		vbox_controls.extend(btn_arrow_up)
		vbox_controls.extend(btn_arrow_down)
		extend(vbox_controls)

		--card
		btn_card.set_minimum_width (175)
		btn_card.set_minimum_height (250)
		color_bw(btn_card)
		extend(btn_card)

		update_card
	end

feature {NONE}
	scroll_up
	do
		if card_counter < card_pile.size then
			card_counter := card_counter + 1
		else
			card_counter := 1
		end
		update_card
	end

	scroll_down
	do
		if card_counter - 1 > 0 then
			card_counter := card_counter - 1
		else
			card_counter := card_pile.size
		end
		update_card
	end

feature {ANY}
	update_card
	local
	   num : INTEGER
	do
		num := card_pile.size
		if num > 0 then
			if feature_type = {GT_CONSTANTS}.IN_HAND_STR then
				card := card_pile.peek_cards (num).at (card_counter)
				if not player.is_card_playable (card.unique_id) then
					pixmap_card := get_image(card.unique_id, true)
				else
					pixmap_card := get_image(card.unique_id, false)
				end
			pixmap_card.stretch(175, 250)
			btn_card.set_pixmap (pixmap_card)
			end
		end
	end

	set_btn_card_select_actions(v : PROCEDURE [ANY, TUPLE])
	do
		btn_card.select_actions.extend (v)
	end

	get_current_card_id : INTEGER_32
	do
		if card_pile.size > 0 then
			Result := card_pile.to_arrayed_list.array_item (card_counter).unique_id
		else
			Result := 0
		end
	end

	set_current_card(counter : INTEGER)
	do
		card_counter := counter
	end

	get_current_card : INTEGER
	do
		Result := card_counter
	end
end
