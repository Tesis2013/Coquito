note
	description: "Summary description for {GT_LOGIC_HAND}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GT_LOGIC_HAND[E -> GT_LOGIC_CARD]

inherit
	GT_LOGIC_CARD_COLLECTION[E]

create
	make

feature
	make
	--Create a new empty hand collection
	do
		create deck.make (0)
		size := 0
	end

end
