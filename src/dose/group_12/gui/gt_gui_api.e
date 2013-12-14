note
	description: "Summary description for {GT_GUI_API}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GT_GUI_API

feature
	    update_active_player(player : GT_LOGIC_PLAYER)
	    do

	    end

        update_player(player : GT_LOGIC_PLAYER) -- updates all player associated attributes like cards, gold and so on
		do

		end

        start_phase(phase : GT_LOGIC_PHASE) -- opens "phase screen"
		do

		end

        choose_from_hand(cards : INTEGER[]) : INTEGER[] -- returns chosen card IDs
        do

        end

        choose_from_game_cards(cards : INTEGER[]) : INTEGER[] -- returns chosen card IDs
        do

        end

        choose_from(cards : INTEGER[]) : INTEGER[] -- returns chosen card IDs (used for house, agenda, plot cards)
        do

        end

        notify_message(text : STRING) -- just shows a string message
        do

        end

        -- add more notify methods

        notify_dominance_winner(player : GT_LOGIC_PLAYER)
        do

        end
end
