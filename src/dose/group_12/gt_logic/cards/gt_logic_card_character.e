note
	description: "Summary description for {GT_LOGIC_CARD_CHARACTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GT_LOGIC_CARD_CHARACTER

inherit
	GT_LOGIC_CARD

create
	make

feature {ANY} -- initialization
	make(i_unique_id, i_cost, i_STR, i_gold_modifier : INTEGER;
	i_title, i_house, i_text : STRING;
	i_text_effect : GT_LOGIC_TEXT_EFFECT;
	i_military, i_intrigue, i_power : BOOLEAN;
	i_crests, i_traits : LIST[STRING];
	i_keywords : LIST[GT_LOGIC_KEYWORD])
	do
		unique_id := i_unique_id
		cost := i_cost
		base_strength := i_STR
		strength_modifier := 0
		gold_modifier := i_gold_modifier
		title := i_title
		house := i_house
		text := i_text
		text_effect := i_text_effect
		military := i_military
		intrigue := i_intrigue
		power := i_power
		crests := i_crests
		traits := i_traits
		keywords := i_keywords
	end

feature -- Queries
	-- What is my base strength? (no attachments or effects)
	base_strength : INTEGER

	-- What is my strength modifier? (from attachments or effects)
	strength_modifier : INTEGER assign set_strength_modifier

	-- What is my Strength value?
	strength : INTEGER
	do
		Result := base_strength + strength_modifier
	end
	-- Invariant: Non-negative

	-- Can I participate in a military challenge?
	military : BOOLEAN

	-- Can I participate in an intrigue challenge?
	intrigue : BOOLEAN

	-- Can I participate in a power challenge?
	power : BOOLEAN

	-- Which are my crests?
	crests: LIST[STRING]

feature {NONE}

	set_strength_modifier(modifier_amount:INTEGER)
	do
		strength_modifier := modifier_amount
	end

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
