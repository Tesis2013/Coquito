note
	description: "Summary description for {GT_NET_SYNCHRONIZE_COMMAND}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GT_NET_SYNCHRONIZE_COMMAND

	inherit

		GT_NET_COMMAND
		redefine
			command_id, out
		end

	create

		make_synchronize_command

	feature --initialization

		make_synchronize_command(a_deck: GT_LOGIC_DECK[GT_LOGIC_CARD])
		do
			deck := a_deck
		end

	feature --attributes

		command_id : STRING
		once
			Result := "SYNCHRONIZE_COMMAND"
		end

		deck : GT_LOGIC_DECK[GT_LOGIC_CARD]

	feature

		out : STRING
		local
			i : INTEGER
		do
			Result := command_id
			--TODO loop over cards
		end
end
