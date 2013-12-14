note
	description: "Summary description for {GT_LOGIC_PILE_PLOT_USED}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GT_LOGIC_PILE_PLOT_USED[E -> GT_LOGIC_CARD]

inherit
	GT_LOGIC_PILE[E]

create
	make

feature
	make
	--Create a new empty "Used plot pile"
	do
		create deck.make (0)
		size := 0
	end

	-- Don't think this is needed
	--make_int(i : INTEGER)
	--do
	--	create deck.make (i)
	--end
end
