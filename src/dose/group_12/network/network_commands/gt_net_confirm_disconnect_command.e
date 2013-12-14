note
	description: "Summary description for {GT_NET_DONE_COMMAND}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GT_NET_CONFIRM_DISCONNECT_COMMAND

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
			Result := "CONFIRM_DISCONNECT_COMMAND"
		end

	feature

		out : STRING
		once
			Result := command_id
		end

end
