note
	description: "Summary description for {GT_NET_SET_STARTING_PLAYER_COMMAND}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GT_NET_SET_STARTING_PLAYER_COMMAND

	inherit

		GT_NET_COMMAND
		redefine
			command_id, out
		end

	create
		make_set_starting_player_command

	feature --initialize

		make_set_starting_player_command(a_starting_player_id : INTEGER)
		require
			valid_player_id : a_starting_player_id = 1 or a_starting_player_id = 2
		do
			starting_player_id := a_starting_player_id
		ensure
			starting_player_id = a_starting_player_id
		end

	feature --attributes

		command_id : STRING
		once
			Result := "SET_STARTING_PLAYER_COMMAND"
		end

		starting_player_id : INTEGER

	feature

		out : STRING
		do
			Result := command_id + "; starting player = " + starting_player_id.out
		end
end
