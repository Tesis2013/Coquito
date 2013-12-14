note
	description: "Summary description for {GT_NET_DONE_COMMAND}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GT_NET_HOUSE_COMMAND

	inherit

		GT_NET_COMMAND
		redefine
			command_id, out
		end

		GT_CONSTANTS
		undefine
			out
		end

	create
		make_house_command

	feature --initialization

		make_house_command(a_house : STRING)
		require
			a_house.is_equal (house_lannister) or a_house.is_equal (house_stark)
		do
			house := a_house
		ensure
			house = a_house
		end

	feature --attributes

		command_id : STRING
		once
			Result := "HOUSE_COMMAND"
		end

		house : STRING

	feature

		out : STRING
		once
			Result := command_id
		end

end
