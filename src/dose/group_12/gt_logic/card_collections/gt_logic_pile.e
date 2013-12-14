note
	description: "Summary description for {GT_LOGIC_PILE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	GT_LOGIC_PILE[E -> GT_LOGIC_CARD]

inherit
	GT_LOGIC_CARD_COLLECTION[E]

feature {NONE}
	cards_all_visible : BOOLEAN
	local
		i : INTEGER
		visibility : BOOLEAN
	do
		visibility := true
		from
			i := 1
		until
			i > deck.count OR NOT visibility
		loop
			if
				NOT deck.at (i).visible (1) OR NOT deck.at (i).visible (2)
			then
				visibility := false
			end
		end
		result := visibility
	end

invariant
	--all_cards_visible: cards_all_visible = true
	--All cards in piles are visible to all players

end
