note
	description: "Summary description for {GT_NET_CHAT_COMMAND}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GT_NET_CHAT_COMMAND

	inherit

		GT_NET_COMMAND
		redefine
			command_id, out
		end

	create
	
		make_chat_command

	feature --initialize

		make_chat_command(a_message : STRING)
		require
			message_not_void : a_message /= Void
		do
			message := a_message
		ensure
			message = a_message
		end

	feature --attributes

		command_id : STRING
		once
			Result := "CHAT_COMMAND"
		end

		message : STRING

	feature

		out : STRING
		do
			Result := command_id + ": " + message
		end
end
