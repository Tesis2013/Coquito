note
	description: "Summary description for {GT_NET_KILL_CHARACTERS_COMMAND}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GT_NET_KILL_CHARACTERS_COMMAND

	inherit

		GT_NET_COMMAND
		redefine
			command_id, out
		end

	create

		make_kill_characters_command

	feature --initialize

		make_kill_characters_command(a_nr_characters_to_kill : INTEGER)
		do
			nr_characters_to_kill := a_nr_characters_to_kill
		ensure
			nr_characters_to_kill = a_nr_characters_to_kill
		end

	feature --attributes

		command_id : STRING
		once
			Result := "KILL_CHARACTERS_COMMAND"
		end

		nr_characters_to_kill : INTEGER

	feature

		out : STRING
		do
			Result := command_id + ": " + nr_characters_to_kill.out
		end
end
