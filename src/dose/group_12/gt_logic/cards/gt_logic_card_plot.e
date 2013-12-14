note
	description: "Summary description for {GT_LOGIC_CARD_PLOT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GT_LOGIC_CARD_PLOT

inherit
	GT_LOGIC_CARD

create
	make

feature {ANY} -- initialization
	make(i_unique_id, i_income, i_initiative, i_claim : INTEGER;
	i_title, i_text : STRING;
	i_text_effect : GT_LOGIC_TEXT_EFFECT;
	i_keywords : LIST[GT_LOGIC_KEYWORD])
	do
		unique_id := i_unique_id
		income := i_income
		initiative := i_initiative
		claim := i_claim
		title := i_title
		text := i_text
		text_effect := i_text_effect
		keywords := i_keywords
	end

feature -- Queries
	-- What is my income?
	income : INTEGER
	-- Invariant: Non-negative

	-- What is my initiative value?
	initiative : INTEGER
	-- Invariant: Non-negative

	-- What is my claim value?
	claim : INTEGER
	-- Invariant: Non-negative

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
	invariant_cost: cost = 0 -- Plot cards do not have cost, they have income.

end
