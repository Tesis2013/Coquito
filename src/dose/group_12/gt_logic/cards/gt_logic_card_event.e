note
	description: "Summary description for {GT_LOGIC_CARD_EVENT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GT_LOGIC_CARD_EVENT

inherit
	GT_LOGIC_CARD

create
	make

feature {ANY} -- initialization
	make(i_unique_id : INTEGER;
	i_title, i_text : STRING;
	i_text_effect : GT_LOGIC_TEXT_EFFECT;
	i_keywords : LIST[GT_LOGIC_KEYWORD])
	do
		unique_id := i_unique_id
		title := i_title
		text := i_text
		text_effect := i_text_effect
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
