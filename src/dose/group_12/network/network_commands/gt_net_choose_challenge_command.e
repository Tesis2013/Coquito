note
	description: "Summary description for {GT_NET_CHOOSE_CHALLENGE_TYPE_COMMAND}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GT_NET_CHOOSE_CHALLENGE_COMMAND

	inherit

		GT_NET_COMMAND
		redefine
			command_id, out
		end

	create
	
		make_challenge_command

	feature --initialization

		make_challenge_command(a_challenge_type : STRING)
		do
			challenge_type := a_challenge_type
		end

	feature --attributes

		command_id : STRING
		once
			Result := "CHOOSE_CHALLENGE_TYPE_COMMAND"
		end

		challenge_type : STRING

	feature

		out : STRING
		do
			Result := command_id + ": " + challenge_type
		end

end
