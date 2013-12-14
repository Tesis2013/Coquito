note
	description: "Summary description for {GT_LOGIC_CARD_COLLECTION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"
	definition: "A GT_LOGIC_CARD_COLLECTION is modelled as a deck of cards. The first card added will be at the bottom of the deck"

deferred class
	GT_LOGIC_CARD_COLLECTION[E -> GT_LOGIC_CARD]

feature {NONE} -- variables, only visible to Deck and subclasses.
	deck: ARRAYED_LIST[E]

feature {ANY} -- Queries
	size: INTEGER
	--How many cards do I contain?

feature -- Commands
	pop : E
	--Remove the top card of the collection
	require
		size > 0
	local
		card_to_remove: E
	do
		card_to_remove := deck.at (deck.count)
		deck.finish
		deck.remove
		deck.finish
		size := size - 1
		result := card_to_remove
	ensure
		element_removed: size = old size - 1
	end


	add_card(card: E)
	--Add the card to the top of the collection
	require
		card /= void
	do
		deck.extend (card)
		size := size + 1
	ensure
		size_increased: size = old size + 1
		new_card_top: deck.at (deck.count) = card
	end

	push(cards: ARRAYED_LIST[E])
	--Add a list of cards to the top of the deck
	require
		cards /= void
		cards.count > 0
	do
		size := size + cards.count
		deck.finish
		deck.merge_right (cards)

	ensure
		size_increased: size = old size + old cards.count
		new_card_top: deck.at (deck.count) = old cards.at (cards.count)
		--New card on top of the collection
		same_card_buttom: deck @ (1) = old deck @ (1)
		--Same card on buttom of the collection
	end

	push_bottom(cards: ARRAYED_LIST[E])
	--Add a list of cards to bottom of the deck
	require
		cards /= void
		cards.count >= 0
	do
		size := size + cards.count
		deck.start
		deck.merge_left (cards)

	ensure
		element_added: size = old size + old cards.count
		new_card_buttom: deck.at (1) = old cards.at (1) --Should be object equality
		--New card on the buttom of the collection
		same_card_top: deck @ (deck.count) = old deck @ (deck.count)
		--Same card on top of the collection

	end

	peek_cards(cards_to_peek: INTEGER) : ARRAYED_LIST[E]
	--Show me the "cards_to_peek" top cards of the collection
	require
		size >= cards_to_peek
	local
		cards_to_return: ARRAYED_LIST[E]
		i : INTEGER
		card : E
	do
		create cards_to_return.make(cards_to_peek)
		from
			i := 0
		until
			i >= cards_to_peek
		loop
			card := deck.at (deck.count - i)
			cards_to_return.force (card)
			i := i + 1
 		end
 		Result := cards_to_return
	ensure
		same_size: size = old size
		same_order: deck.is_equal (old deck)
		--The collection is in the same order as before
		correct_number_returned: Result.count = cards_to_peek
	end

	contain(card_id: INTEGER) : BOOLEAN
	--Does this collection contain the card specified by "card_id"
	require
		--card_id /= void
	local
		i : INTEGER
		contains_card : BOOLEAN
	do
		contains_card := false
		from
			i := 1
		until
			i > deck.count OR contains_card
		loop
			if
				deck.at (i).unique_id = card_id
			then
				contains_card := true
			end
			i := i + 1
		end
		result := contains_card
	ensure

	end

	get_card_by_id(card_id: INTEGER) : E
	--Get the card specified by the "card_id"
	require
		contain(card_id) = true
	local
		i : INTEGER
		contains : BOOLEAN
		card_to_return : E
	do
		contains := false
		from
			i := 1
		until
			i > deck.count OR contains
		loop
			if
				deck.at (i).unique_id = card_id
			then
				card_to_return := deck.at (i)
				contains := true
			end
			i := i + 1
		end
		result := card_to_return

	ensure
		card_still_there: current.contain (card_id) = true
		--Card still in the collection
	end

	remove_card_by_id(card_id: INTEGER) : E
	--Get the card specified by the "card_id", and remove that card from the collection
	require
		contain(card_id) = true
	local
		i : INTEGER
		a : INTEGER
		contains : BOOLEAN
		card_to_return : E
	do
		contains := false
		from
			i := 1
		until
			i > deck.count OR contains
		loop
			if
				deck.at (i).unique_id = card_id
			then
				a := i
			end
			i := i + 1
		end
		card_to_return := deck.at (a)
		deck.go_i_th (a)
		deck.remove
		size := size - 1
		result := card_to_return

	ensure
		size_changed: size = old size - 1
		--Size one less
		card_removed: current.contain (card_id) = false
		--Card got removed from deck
	end

	to_Arrayed_List : ARRAYED_LIST[E]
	--Returns an arrayed list containing the cards in this collection
	local
		cards : ARRAYED_LIST[E]
		i : INTEGER
	do
		create cards.make (0)
		from
			i := 1
		until
			i > deck.count
		loop
			cards.extend (deck.at (i))
			i := i + 1
		end
		result := cards
	end

	get_cards_by_keyword (keyword : GT_LOGIC_KEYWORD) : ARRAYED_LIST[E]
	--Returns the cards who has the given keyword
	local
		cards : ARRAYED_LIST[E]
		card : E
		i : INTEGER
	do
		create cards.make (0)
		from
			i := 1
		until
			i > deck.count
		loop
			card := deck.at (i)
			if
				card.keywords.has(keyword)
			then
				cards.extend(card)
			end
			i := i + 1
		end
		result := cards
	end

	get_character_cards : ARRAYED_LIST[GT_LOGIC_CARD_CHARACTER]
	--Returns all character cards in this collection
	local
		cards : ARRAYED_LIST[GT_LOGIC_CARD_CHARACTER]
		card : E
		i : INTEGER
	do
		create cards.make (0)
		from
			i := 1
		until
			i > deck.count
		loop
			card := deck.at (i)
			if
				attached {GT_LOGIC_CARD_CHARACTER} card as card_c
			then
				cards.extend (card_c)
			end
			i := i +1
		end
		result := cards
	end

invariant
	correct_size: size = deck.count
	--Size equal to the number of cards in collection

end
