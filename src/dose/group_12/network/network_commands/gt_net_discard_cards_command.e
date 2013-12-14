note
	description: "Summary description for {GT_NET_DISCARD_CARDS_COMMAND}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GT_NET_DISCARD_CARDS_COMMAND

	inherit

		GT_NET_COMMAND
		redefine
			command_id, out
		end

	create

		make_discard_cards_command

	feature --initialize

		make_discard_cards_command(a_nr_cards_to_discard : INTEGER)
		do
			nr_cards_to_discard := a_nr_cards_to_discard
		ensure
			nr_cards_to_discard = a_nr_cards_to_discard
		end

	feature --attributes

		command_id : STRING
		once
			Result := "DISCARD_CARDS_COMMAND"
		end

		nr_cards_to_discard : INTEGER

	feature

		out : STRING
		do
			Result := command_id + ": " + nr_cards_to_discard.out
		end
end

