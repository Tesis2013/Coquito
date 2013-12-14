note
	description: "Summary description for {GT_LOGIC_DECK}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	GT_LOGIC_DECK[E -> GT_LOGIC_CARD]

inherit
	GT_LOGIC_CARD_COLLECTION[E]

feature {NONE}
	cards_not_visible : BOOLEAN
	local
		i : INTEGER
		visibility : BOOLEAN
	do
		visibility := false
		from
			i := 1
		until
			i > deck.count OR visibility
		loop
			if
				deck.at (i).visible (1) OR deck.at (i).visible (2)
			then
				visibility := true
			end
		end
		result := visibility
	end

feature {ANY}
	get_card_order: ARRAYED_LIST[INTEGER]
	local
		order_list : ARRAYED_LIST[INTEGER]
		cardtype :GT_LOGIC_CARD
	do
		create order_list.make (0)
		across deck as card loop
			cardtype ?= card
			order_list.extend(cardtype.unique_id)
		end
		Result := order_list
	end
	--What is the order of my cards?
invariant
	--all_cards_not_visible: cards_not_visible = false
	--All cards in decks are not visible to any player
end
