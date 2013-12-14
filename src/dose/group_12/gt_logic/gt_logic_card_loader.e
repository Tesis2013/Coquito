note
	description: "Summary description for {GT_LOGIC_CARD_LOADER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GT_LOGIC_CARD_LOADER

create
	make

feature {NONE} -- Initialization

	make(house: STRING; server : BOOLEAN; board: GT_LOGIC_BOARD)
		local
			i: INTEGER
			-- Initialization for `Current'. is_server indicates if the player is the host, which will determine the order of the unique ids.
		do
			is_player_server := server -- Is the player a host or client?
			load_cards(house, board)
		end

feature {ANY} -- Variables

	house_deck : GT_LOGIC_DECK_HOUSE[GT_LOGIC_CARD]
	plot_deck : GT_LOGIC_DECK_PLOT[GT_LOGIC_CARD_PLOT]
	is_player_server : BOOLEAN

	-- Load cards from a house
	load_cards(house: STRING; board : GT_LOGIC_BOARD)
	require
		house.is_equal ({GT_CONSTANTS}.HOUSE_STARK) or house.is_equal ({GT_CONSTANTS}.HOUSE_LANNISTER)
	local
		i,c : INTEGER
		a_path : STRING
		input_file : PLAIN_TEXT_FILE
		card_character : GT_LOGIC_CARD_CHARACTER
		card_attachment : GT_LOGIC_CARD_ATTACHMENT
		card_event : GT_LOGIC_CARD_EVENT
		card_location : GT_LOGIC_CARD_LOCATION
		card_plot : GT_LOGIC_CARD_PLOT
		line : LIST[STRING]
		ID: INTEGER
		title: STRING
		type: STRING
		house_card: STRING
		cost: INTEGER
		STR: INTEGER
		challenge_military: BOOLEAN
		challenge_intrigue: BOOLEAN
		challenge_power: BOOLEAN
		crests: LIST[STRING]
		initiative: INTEGER
		claim: INTEGER
		income: INTEGER
		gold_modifier: INTEGER
		influence: INTEGER
		traits: LIST[STRING]
		keywords_string: LIST[STRING]
		keywords_list: ARRAYED_LIST[GT_LOGIC_KEYWORD]
		keyword:  GT_LOGIC_KEYWORD
		text: STRING
		text_effect_id: STRING
		text_effect: GT_LOGIC_TEXT_EFFECT
		player_unique_id: INTEGER
	do
		-- load the right file with the cards for that house
		if house.is_equal({GT_CONSTANTS}.HOUSE_STARK) then
			create a_path.make_from_string (".\dose\group_12\resources\stark.csv")
		elseif house.is_equal({GT_CONSTANTS}.HOUSE_LANNISTER) then
			create a_path.make_from_string (".\dose\group_12\resources\lannister.csv")
		else
			create a_path.make_from_string ("") --FIX ME
		end

		-- set the player_unique_id, 100 for the server, 200 for the client
--		if is_player_server then
--			player_unique_id := 100
--		else
--			player_unique_id := 200
--		end

		create input_file.make_open_read (a_path)
		create house_deck.make
		create plot_deck.make


		from
			input_file.read_line --first line of the doc with id, title, etc.
		until
			input_file.exhausted
		loop
			-- TODO: re-initialize card realted variables
			ID := 0; cost := 0; STR := 0; initiative := 0; claim := 0; income :=0; gold_modifier :=0; influence :=0;  -- player_unique_id := 0 -- TODO THis is probably wrong //Simon
			title := ""; type :=""; house_card :=""; text := "";create keywords_list.make (0);

			challenge_military := false; challenge_intrigue := false; challenge_power := False

			-- read the whole line
			input_file.read_line
			-- split line in a collection of strings
			line := input_file.last_string.split (';')
			-- read ID: first element and if integer
			if line.at (1).is_integer then
				ID := line.at (1).to_integer + player_unique_id
			end
			-- read tile
			title := line.at (2)
			-- read type
			type := line.at (3).as_upper
			-- read house: NEUTRAL, STARK, LANNISTER
			house_card := line.at (4).as_upper  -- TO DO: should we check that is only NEUTRAL, STARK, LANNISTER?
			-- read cost: is an integer and if char, att, loc assign as cost
			-- if plot as income.
			if line.at (5).is_integer then
				if type.is_equal ({GT_CONSTANTS}.CARD_CHARACTER_CONSTANT) or
				   type.is_equal ({GT_CONSTANTS}.CARD_ATTACHMENT_CONSTANT) or
				   type.is_equal ({GT_CONSTANTS}.CARD_LOCATION_CONSTANT) then
					cost := line.at (5).to_integer
				elseif type.is_equal ({GT_CONSTANTS}.CARD_PLOT_CONSTANT) then
					income := line.at (5).to_integer
				end
			end
			-- read STR: is integer and if Character
			if line.at (6).is_integer and type.is_equal ({GT_CONSTANTS}.CARD_CHARACTER_CONSTANT) then
				str := line.at (6).to_integer
			end
			-- read Military challenge: if 1 and if Character
			if line.at (7).is_equal ("1") and type.is_equal ({GT_CONSTANTS}.CARD_CHARACTER_CONSTANT) then
				challenge_military := true
			end
			-- read Intrigue challenge: if 1 and if Character
			if line.at (8).is_equal ("1") and type.is_equal ({GT_CONSTANTS}.CARD_CHARACTER_CONSTANT) then
				challenge_intrigue := true
			end
			-- read Power challenge: if 1 and if Character
			if line.at (9).is_equal ("1") and type.is_equal ({GT_CONSTANTS}.CARD_CHARACTER_CONSTANT) then
				challenge_power := true
			end
			-- read Crests: if Character. returns list of strings
			if (not line.at (10).is_empty) and type.is_equal ({GT_CONSTANTS}.CARD_CHARACTER_CONSTANT) then --TO DO: how do you check if string not empty
				crests := line.at (10).split ('.')
			end
			-- read Initiative: if integer and if Plot card
			if line.at (11).is_integer and type.is_equal ({GT_CONSTANTS}.CARD_PLOT_CONSTANT) then
				initiative := line.at (11).to_integer
			end
			-- read Claim: if integer and if Plot card
			if line.at (12).is_integer and type.is_equal ({GT_CONSTANTS}.CARD_PLOT_CONSTANT) then
				claim := line.at (12).to_integer
			end
			-- read Influence: if integer and if Location (only locations have influence)
			if line.at (13).is_integer and type.is_equal ({GT_CONSTANTS}.CARD_LOCATION_CONSTANT) then
				influence := line.at (13).to_integer
			end
			-- read Gold Modifier: if integer and if Location or Character
			if line.at (14).is_integer and (type.is_equal ({GT_CONSTANTS}.CARD_LOCATION_CONSTANT) or type.is_equal ({GT_CONSTANTS}.CARD_CHARACTER_CONSTANT)) then
				gold_modifier := line.at (14).to_integer
			end
			-- read Traits: if location, character or attachment
			if (not line.at (15).is_empty) and (type.is_equal ({GT_CONSTANTS}.CARD_LOCATION_CONSTANT) or
			    type.is_equal ({GT_CONSTANTS}.CARD_CHARACTER_CONSTANT) or type.is_equal ({GT_CONSTANTS}.CARD_ATTACHMENT_CONSTANT)) then
				traits := line.at (15).split ('.')
			end
			-- read Keywords
			if (not line.at (16).is_empty) then
				keywords_string := line.at (16).split ('.')
				c := keywords_string.count
				from --TODO: check if this loop makes sense
					i := 1
				until
					i > c
				loop
					keywords_string.at (i).trim
					create keyword.make(keywords_string.at (i) )
					keywords_list.extend (keyword)
					i := i+1
				end
			end
			-- read Text and text effect id
			if (not line.at (17).is_empty) then
				text := line.at (17).to_string_8
				text.trim
				if not line.at (18).is_empty then
					text_effect_id := line.at (18).to_string_8
					text_effect_id.trim
				end
				create text_effect.make(text, text_effect_id,board) --TODO: Text effect ID should be parsed and added here:
			end

			-- create card			
			if type.is_equal ({GT_CONSTANTS}.CARD_CHARACTER_CONSTANT) then
				create card_character.make (ID, cost, STR, gold_modifier, title, house_card, text, text_effect, challenge_military, challenge_intrigue, challenge_power, crests, traits, keywords_list)
			elseif type.is_equal ({GT_CONSTANTS}.CARD_LOCATION_CONSTANT) then
				create card_location.make (ID, cost, influence, gold_modifier, title, house_card, text, text_effect, traits, keywords_list)
			elseif type.is_equal ({GT_CONSTANTS}.CARD_ATTACHMENT_CONSTANT) then
				create card_attachment.make (ID, cost, title, house_card, text, text_effect, traits, keywords_list)
			elseif type.is_equal ({GT_CONSTANTS}.CARD_PLOT_CONSTANT) then
				create card_plot.make (ID, income, initiative, claim, title, text, text_effect, keywords_list)
			elseif type.is_equal ({GT_CONSTANTS}.CARD_EVENT_CONSTANT) then
				create card_event.make (ID, title, text, text_effect, keywords_list)
			end

			-- add it to the decks
			if type.is_equal ({GT_CONSTANTS}.CARD_CHARACTER_CONSTANT) then
				house_deck.add_card(card_character)
			elseif type.is_equal ({GT_CONSTANTS}.CARD_LOCATION_CONSTANT) then
				house_deck.add_card(card_location)
			elseif type.is_equal ({GT_CONSTANTS}.CARD_ATTACHMENT_CONSTANT) then
				house_deck.add_card(card_attachment)
			elseif type.is_equal ({GT_CONSTANTS}.CARD_EVENT_CONSTANT) then
				house_deck.add_card(card_event)
			elseif type.is_equal ({GT_CONSTANTS}.CARD_PLOT_CONSTANT) then
				plot_deck.add_card(card_plot)
			end
		end

	end

feature {NONE} -- Implementation

invariant
	invariant_clause: True -- Your invariant here

end
