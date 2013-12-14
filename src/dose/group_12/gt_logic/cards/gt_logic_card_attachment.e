note
	description: "Summary description for {GT_LOGIC_CARD_ATTACHMENT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GT_LOGIC_CARD_ATTACHMENT

inherit
	GT_LOGIC_CARD

create
	make

feature {ANY} -- initialization
	make(i_unique_id, i_cost : INTEGER;
	i_title, i_house, i_text : STRING;
	i_text_effect : GT_LOGIC_TEXT_EFFECT;
	i_traits : LIST[STRING];
	i_keywords : LIST[GT_LOGIC_KEYWORD])
	do
		unique_id := i_unique_id
		cost := i_cost
		title := i_title
		house := i_house
		text := i_text
		text_effect := i_text_effect
		traits := i_traits
		keywords := i_keywords
	end

feature -- Access

feature -- Measurement

feature -- Status report

feature -- Status setting

feature -- Cursor movement

feature -- Element change

feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion

feature -- Duplication

feature -- Miscellaneous

feature -- Basic operations

feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

invariant
	invariant_clause: True -- Your invariant here

end
