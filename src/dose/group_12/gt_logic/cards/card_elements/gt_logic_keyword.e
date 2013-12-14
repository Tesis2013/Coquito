note
	description: "Summary description for {GT_LOGIC_KEYWORD}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GT_LOGIC_KEYWORD

create
	make

feature {ANY} -- initialization
	make(input: STRING)
	do
		keyword := input
	end

feature -- Queries
	keyword : STRING
	-- What is my text?

feature {NONE} -- Implementation

invariant
	invariant_clause: True -- Your invariant here

end
