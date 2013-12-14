note
	description: "Summary description for {GT_LOGIC_PILE_DISCARD}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GT_LOGIC_PILE_DISCARD[E -> GT_LOGIC_CARD]

inherit
	GT_LOGIC_PILE[E]

create
	make

feature -- Commands
	make
	--Create a new empty "Discard pile"
	do
		create deck.make (0)
		size := 0
	end

	-- Don't think we need this
	--make_int(i : INTEGER)
	--do
	--	create deck.make (i)
	--end

end
