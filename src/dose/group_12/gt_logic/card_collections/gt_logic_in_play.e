note
	description: "Summary description for {GT_LOGIC_IN_PLAY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GT_LOGIC_IN_PLAY[E -> GT_LOGIC_CARD]

inherit
	GT_LOGIC_CARD_COLLECTION[E]

create
	make

feature
	make
	--Create a new empty "In play" collection
	do
		create deck.make (0)
		size := 0
	end

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
			i > deck.count
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
