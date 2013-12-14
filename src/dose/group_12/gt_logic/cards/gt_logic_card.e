note
	description: "Summary description for {GT_LOGIC_CARD}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	GT_LOGIC_CARD

feature {NONE}
	set_kneeling (bool : BOOLEAN)
	do
		kneeling := bool
	end

feature -- Queries
	-- Queries for all types of card
	-- What is my unique ID?
	unique_id : INTEGER

	-- What is my title?
	title: STRING

	-- What is my text?
	text : STRING

	-- What is my text effect?
	text_effect : GT_LOGIC_TEXT_EFFECT

	-- What House do I belong to?
	house : STRING -- The possibilities are: NEUTRAL, STARK, LANNISTER

	-- Queries useful only for some types of card
	-- What does it cost to play me?
	cost : INTEGER -- Plot cards do not have it so it will 0 by default

	-- Which keywords do I have?
	keywords : LIST [GT_LOGIC_KEYWORD]

	-- Am I kneeling? Only characters, location and attachments can kneel
	kneeling : BOOLEAN assign set_kneeling

	-- Am I visible to this player?
	visible(player_ID: INTEGER) : BOOLEAN
		do

		end

	-- What state am I in?
	state : STRING
	do
	-- The possibilities of this string: IN A PLOT DECK, IN A HOUSE DECK, IN PLAY, IN A HAND, DISCARDED, DEAD, BANISHED, USED, DUPLICATE
	end

	-- What is my classification ID?
	classification_id : INTEGER

	-- What is my gold modifier?
	gold_modifier : INTEGER
	-- Only Location and Characters have it

	-- What are my traits?
	traits: LIST[STRING]
	-- Only Location, Character and attachment

	-- What is my initiative bonus?
	initiative_bonus : INTEGER

feature {NONE} -- Implementation

invariant
	invariant_clause: True -- Your invariant here

end
