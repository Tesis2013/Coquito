note
	description: "Summary description for {GT_GUI_SELECT_TYPE_CHALLENGE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GT_GUI_SELECT_TYPE_CHALLENGE

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
	cont : EV_FIXED
	label : EV_LABEL
	intrigue, power, military : EV_BUTTON
	board: GT_LOGIC_BOARD

	make(a_board : GT_LOGIC_BOARD)
	do
		default_create
		board := a_board
		initialize_component
	end

	initialize_component
			-- Initialize `Current'.
		do
			create cont
			color_bw(cont)
			extend(cont)
			cont.set_minimum_size (1000, 600)

			create label.make_with_text("Please select a type of challenge:")
			color_bw(label)

			create military.make_with_text_and_action ("Military", agent on_selected({GT_CONSTANTS}.CHALLENGE_TYPE_MILITARY))
			create intrigue.make_with_text_and_action ("Intrigue", agent on_selected({GT_CONSTANTS}.CHALLENGE_TYPE_INTRIGUE))
			create power.make_with_text_and_action ("Power", agent on_selected({GT_CONSTANTS}.CHALLENGE_TYPE_POWER))
			cont.extend_with_position_and_size(military, 230, 230, 180, 40)
			cont.extend_with_position_and_size(intrigue, 410, 230, 180, 40)
			cont.extend_with_position_and_size (power, 590, 230, 180, 40)
			label.set_font (STANDARD_FONT)
			cont.extend_with_position_and_size(label, 0, 200, 1000, 20)
		end

		on_selected(type : STRING)
		do
			hide
			board.get_player_one.choose_challenge_type(type)
		--- notify the other player about the attack
		end

end
