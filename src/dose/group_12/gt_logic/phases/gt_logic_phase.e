note
	description: "[
					Summary description for {GT_LOGIC_PHASE}.
					]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	GT_LOGIC_PHASE

feature {NONE}
	phase: STRING

feature
	make(player_one : GT_LOGIC_PLAYER; player_two : GT_LOGIC_PLAYER; board : GT_LOGIC_BOARD)
	require
		player_one /= void
		player_two /= void
	do

		player_1 := player_one
		player_2 := player_two
		game_board := board

	ensure
		player_one /= void
		player_two /= void
	end

feature --commands
	play(card_id: INTEGER_32; player_object: GT_LOGIC_PLAYER)
	-- Play the specified card for the selected player, the phase will handle specific variables such as gold and power tokens and certain phase rules when playing the card
	require
		is_card_playable_in_phase(card_id, player_object)
		player_object /= void
		card_id > 0 -- TODO: make "is valid id method"
	do

	end

	play_attachment(attachment_id: INTEGER; card_attached_to_id : INTEGER; player_object : GT_LOGIC_PLAYER)
	-- Attach the selected card to the specified card, for the specified player.
	require
		attached {GT_LOGIC_CARD_ATTACHMENT} player_object.get_card_by_id (attachment_id) -- The card type should be attachment
		player_object /= void
	do

	end

	play_plot_card(card_id: INTEGER; player_object : GT_LOGIC_PLAYER)
	-- Play the specified plot card (only available in the plot phase
	require
		is_card_playable_in_phase(card_id, player_object)
		player_object /= void
		attached {GT_LOGIC_PHASE_PLOT} current -- should only be called during the plot phase
	do

	end


	choose_attacker(card_id : INTEGER; player_object : GT_LOGIC_PLAYER)
	-- Choose the specific card to be an attacker for the selected player
	require
		attached {GT_LOGIC_CARD_CHARACTER} player_object.get_card_by_id (card_id)
		player_object /= void
	do

	end

	choose_defender(card_id : INTEGER; player_object : GT_LOGIC_PLAYER)
	-- Choose the specific card to be a defender for the selected player.
	require
		attached {GT_LOGIC_CARD_CHARACTER} player_object.get_card_by_id (card_id)
		player_object /= void
	do
	end

	start_phase
	-- Start the current phase, this should only be called by the phase handler
	do

	end

	end_phase
	-- Ends the current phase, this should only be called by the phase handler
	require
		player_1.is_player_ready_for_next_phase and player_2.is_player_ready_for_next_phase
	do

	ensure
		-- TODO: Maybe ensure that player_ready_for_next_phase = false?
	end









feature -- Queries
	-- Which cards are playable for the specified player? DEPRECATED: REMOVE THIS FEATURE.
	--playable_cards(player_id: INTEGER) : COLLECTION [GT_LOGIC_CARD]
	--do

	--end
	-- This is where we then ask what current_phase is, so we can call the corresponding method in the subclass



	is_card_playable_in_phase(card_id: INTEGER; player_object: GT_LOGIC_PLAYER): BOOLEAN
	-- Is this card playable in the current phase?
	require
		player_object /= void
	do
	end

	get_phase_identifer : STRING
	-- What phase am I currently in?
	do
		result := phase
	end

	is_card_affordable(card_id: INTEGER; player_object: GT_LOGIC_PLAYER): BOOLEAN
	-- can the player afford to play this card?
	require
		player_object /= void
		-- card_id
	local
		gold : INTEGER
		card_to_play : GT_LOGIC_CARD
		card_cost : INTEGER
	do
		gold := player_object.gold_dragon_tokens
		card_to_play := player_object.get_card_by_id (card_id)

		if
			attached {GT_LOGIC_CARD_CHARACTER} card_to_play as card_c
		then
			if
				card_c.house = player_object.house_card
			then
				if
					card_c.cost - player_object.reducedcost >= 0
				then
					card_cost := card_c.cost - player_object.reducedcost
				else
					card_cost := 0
				end
			end
		else
			card_cost := card_to_play.cost
		end

		if (gold < card_cost) then
			result := false
		else
			result := true
		end

	end

feature {NONE} -- Implementation

player_1 : GT_LOGIC_PLAYER
player_2 : GT_LOGIC_PLAYER
game_board : GT_LOGIC_BOARD

invariant
	invariant_clause: True -- Your invariant here

end
