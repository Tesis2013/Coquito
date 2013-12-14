note
	description: "Summary description for {GT_LOGIC_DECK_PLOT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GT_LOGIC_DECK_PLOT[E -> GT_LOGIC_CARD_PLOT]

inherit
	GT_LOGIC_DECK[E]

create
	make

feature
	make
	--Create a new empty plot deck
	do
		create deck.make (0)
		size := 0
	end


feature -- Queries
	-- Which plot cards can I choose from?
	playable_plot_cards: ARRAYED_LIST[E]
	do
		result := deck
	end

invariant
	invariant_clause: True -- Your invariant here
	size <= 7 and size >= 0   -- Not sure, it was supposed to be always 7 MFM

end
