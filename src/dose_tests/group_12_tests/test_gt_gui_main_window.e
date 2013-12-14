note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	TEST_GT_GUI_MAIN_WINDOW

inherit
	EQA_TEST_SET

feature -- Test routines


--	test_make_main_window
		--
--		note
--			testing:  "covers/{GT_MAIN_WINDOW}.make",
--			          "covers/{GT_MAIN_WINDOW}.is_in_default_state"
--		local
--			new_window : GT_MAIN_WINDOW
--			a_main_ui_window : MAIN_WINDOW
--		do
--			create new_window.make (a_main_ui_window)
--			assert ("is in default state because it was just created", new_window.is_in_default_state)
				-- modifying the state is_in_default_state should be false
--		end




--	test_request_close_window
--		note testing:  "covers/e{GT_MAIN_WINDOW}.request_close_window"
--		local
--			new_window : GT_MAIN_WINDOW
--			a_main_ui_window : MAIN_WINDOW
--		do
--			create new_window.make (a_main_ui_window)
--			new_window.request_close_window
--			assert ("the window has been delted", new_window.is_destroyed)
--		end




end


