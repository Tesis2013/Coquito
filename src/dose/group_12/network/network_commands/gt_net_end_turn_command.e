note
	description: "Summary description for {GT_NET_END_TURN_COMMAND}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GT_NET_END_TURN_COMMAND

	inherit

		GT_NET_COMMAND
		redefine
			command_id, out
		end

	create
		default_create

	feature --attributes

		command_id : STRING
		once
			Result := "END_TURN_COMMAND"
		end

	feature

		out : STRING
		once
			Result := command_id
		end

end
