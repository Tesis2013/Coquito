note
	description: "Summary description for {G12_LAUNCHER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class GT_CMD_LAUNCHER

	inherit LAUNCHER

feature

	launch (main_ui_window : MAIN_WINDOW)
		local
			logic_initializer : GT_LOGIC_INITIALIZER
			board : GT_LOGIC_BOARD
			factory : INET_ADDRESS_FACTORY
		do
			create logic_initializer
			print("client or server?%N")
			io.read_line
			if io.last_string.is_equal ("client") then
				print("IP address?%N")
				create factory
				io.read_line
				board := logic_initializer.start_game_as_client (factory.create_from_name (io.last_string))
			elseif io.last_string.is_equal ("server") then
				board := logic_initializer.start_game_as_server ({GT_CONSTANTS}.house_lannister)
			end
		end

end
