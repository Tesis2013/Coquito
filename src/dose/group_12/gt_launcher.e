note
	description: "Summary description for {G12_LAUNCHER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class GT_LAUNCHER

inherit
	LAUNCHER

feature

	launch (main_ui_window: MAIN_WINDOW)
		local
			window: GT_MAIN_WINDOW

		do
			create window.make (main_ui_window)
			window.show
			window.set_position (0, 0)

			main_ui_window.add_reference_to_game (window)
		end

end

