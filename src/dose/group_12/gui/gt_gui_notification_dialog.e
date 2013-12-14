note
	description: "Summary description for {GT_GUI_NOTIGICATION_DIALOG}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GT_GUI_NOTIFICATION_DIALOG

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
	ok_button : EV_BUTTON

	make
	do
		default_create
		initialize_component
	end

	initialize_component
			-- Initialize `Current'.
		do
			create cont
			color_bw(cont)
			extend(cont)
			cont.set_minimum_size (1000, 600)

			create label
			color_bw(label)
			create ok_button.make_with_text_and_action("OK", agent hide)

			label.set_font (STANDARD_FONT)

			cont.extend_with_position_and_size(label, 0, 200, 1000, 20)
			cont.extend_with_position_and_size (ok_button, 410, 230, 180, 40)

		end

feature {ANY}

	update_message(a_message : STRING)
	do
		if not a_message.is_empty then
			label.set_text (a_message)
		end
	end

end


