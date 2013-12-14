note
	description: "Summary description for {GT_NET_DRAW_COMMAND}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GT_NET_DRAW_COMMAND

	inherit

		GT_NET_COMMAND
		redefine
			command_id, out
		end

	create
	
		make_draw_command

	feature --initialization

		make_draw_command(a_number_of_cards_to_draw: INTEGER)
		require
			positive_number_of_cards : a_number_of_cards_to_draw > 0
		do
			number_of_cards_to_draw := a_number_of_cards_to_draw
		end

	feature --attributes

		command_id : STRING
		once
			Result := "DRAW_COMMAND"
		end

		number_of_cards_to_draw : INTEGER

	feature

		out : STRING
		do
			Result := command_id + ": # Cards = " + number_of_cards_to_draw.out
		end

	invariant positive_number_of_cards : number_of_cards_to_draw > 0

end
