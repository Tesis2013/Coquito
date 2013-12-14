note
	description: "Summary description for {GT_NET_CHOOSE_DEFENDER_COMMAND}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GT_NET_CHOOSE_DEFENDER_COMMAND

	inherit
		GT_NET_COMMAND
		redefine
			command_id, out
		end

	create

		make_choose_defender_command

	feature

		make_choose_defender_command(a_card_id : INTEGER)
		do
			card_id := a_card_id
		end

	feature

		command_id : STRING
		once
			Result := "CHOOSE_DEFENDER_COMMAND"
		end

		out : STRING
		do
			Result := command_id + "; card_id = " + card_id.out
		end

		card_id : INTEGER

end
