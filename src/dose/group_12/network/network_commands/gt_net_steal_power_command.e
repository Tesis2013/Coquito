note
	description: "Summary description for {GT_NET_STEAL_POWER_COMMAND}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GT_NET_STEAL_POWER_COMMAND

	inherit

		GT_NET_COMMAND
		redefine
			command_id, out
		end

	create

		make_steal_power_command

	feature --initialize

		make_steal_power_command(a_nr_tokens_to_steal : INTEGER)
		do
			nr_tokens_to_steal := a_nr_tokens_to_steal
		ensure
			nr_tokens_to_steal = a_nr_tokens_to_steal
		end

	feature --attributes

		command_id : STRING
		once
			Result := "STEAL_POWER_TOKENS_COMMAND"
		end

		nr_tokens_to_steal : INTEGER

	feature

		out : STRING
		do
			Result := command_id + ": " + nr_tokens_to_steal.out
		end
end
