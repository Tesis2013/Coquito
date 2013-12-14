note
	description: "Summary description for {GT_LOGIC_DECK_HOUSE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GT_LOGIC_DECK_HOUSE[E -> GT_LOGIC_CARD]

inherit
	GT_LOGIC_DECK[E]

create
	make,
	make_stark,
	make_lannister

feature -- Commands

	make
	--Create an empty house deck
	do
		create deck.make (0)
		size := 0
	end

	make_stark --Think this should be removed
	--Give me a house deck for the house of Stark!
	do

	end


	make_lannister --Think this should be removed
	--Give me a house deck for the house of Lannister!
	do

	end

	shuffle
	--Shuffle the deck
	require
		size > 0
	local
		rng : RANDOM
		i : INTEGER
		time : TIME
		next_random : INTEGER
		tmp : E
	do
		create time.make_now
		create rng.set_seed (time.milli_second)
		rng.start
		deck.start
		from
			i := 1
		until
			i > deck.count
		loop
			next_random := rng.item \\ deck.count
			if
				next_random /= 0
			then
				tmp := deck.at (i)
				deck.i_th (i) := deck.i_th (next_random)
				deck.i_th (next_random) := tmp
			end
			i := i + 1
			rng.forth
		end
	ensure
		same_size: size = old size
	end

end
