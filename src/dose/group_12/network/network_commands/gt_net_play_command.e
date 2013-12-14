note
	description: "Summary description for {GT_NET_PLAY_COMMAND}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GT_NET_PLAY_COMMAND

	inherit

		GT_NET_COMMAND
		redefine
			command_id, out
		end

	create

		make_one_card, make_two_cards

	feature --initialization

		make_one_card(a_card_number : INTEGER)
		do
			card_number := a_card_number
		end

		make_two_cards(a_card_number, a_extra_card_number : INTEGER)
		do
			make_one_card(a_card_number)
			has_extra_card_number := True
			extra_card_number := a_extra_card_number
		end

	feature --attributes

		command_id : STRING
		once
			Result := "PLAY_COMMAND"
		end

		card_number : INTEGER

		has_extra_card_number : BOOLEAN

		extra_card_number : INTEGER

	feature

		out : STRING
		do
			Result := command_id + ": 1st card = " + card_number.out
			if
				has_extra_card_number
			then
				Result := Result + "; 2nd card = " + extra_card_number.out
			end
		end

end
