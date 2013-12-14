note
	description: "Class {VD_LAUNCHER} is used to launch the Vision demo application."
	author: "haches"
	date: "$Date$"
	revision: "$Revision$"

class
	VD_LAUNCHER

inherit
	LAUNCHER

feature	-- Implementation

	launch (main_ui_window: MAIN_WINDOW)
			-- lunch the application
		local
			window: VD_MAIN_WINDOW
		do
				-- creates the vision_demo window
				-- gives the main_ui as argument so we can restore when vision_demo closes
			create window.make (main_ui_window)
			window.show

				-- we inform the Main-UI about the game window; otherwise, the game window might get garbage collected
			main_ui_window.add_reference_to_game (window)
		end

end
