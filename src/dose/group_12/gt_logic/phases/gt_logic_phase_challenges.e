note
	description: "[
					{GT_LOGIC_PHASE_CHALLENGES}. Handles the challenges implementation. This phase is after the drawing phase and precedes the dominance phase. 
					This phase uses subphases to keep track of where in the phase the players are currently. In the beginning the setup subphase is used to choose attackers and defenders
					for a specific challenge type. The event subphase is then played, which allows players to play event cards, after both players are done playing event cards,
					the phase moves to the resolve subphase, where the challenge result is resolved. The phase then proceeds back to the setup phase for each challenge type selected.
					]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GT_LOGIC_PHASE_CHALLENGES

inherit
	GT_LOGIC_PHASE
	redefine
		is_card_playable_in_phase, make, play, choose_attacker, choose_defender, start_phase
	end

create
	make

feature -- Creation
	make (player_one : GT_LOGIC_PLAYER; player_two : GT_LOGIC_PLAYER; board : GT_LOGIC_BOARD)
	--called from the phase handler. This initiates any needed variables.
	do
		player_1 := player_one
		player_2 := player_two
		game_board := board
		phase := {GT_CONSTANTS}.phase_challenges

	end


feature -- Queries


	challenge_type : STRING assign set_challenge_type
	-- Which challenge type are we currently playing through?

	current_subphase : STRING assign set_subphase
	--which subphase is this

	is_card_playable_in_phase(card_id: INTEGER_32; player_object: GT_LOGIC_PLAYER) : BOOLEAN
	--checks if the card can be played in this phase.

	local
		card: GT_LOGIC_CARD

	do
		card := player_object.get_card_by_id(card_id) --gets the card.
		if  attached {GT_LOGIC_CARD_CHARACTER} card and player_1_made_inbetween_move=TRUE and player_2_made_inbetween_move=TRUE and card.kneeling=false then
				result := TRUE
		end
		if  attached {GT_LOGIC_CARD_EVENT} card then --event cards can be played. TODO check if gui knows when to choose attackers.
			if player_object.player_id = 1 and player_1_made_inbetween_move=FALSE then
				result:=TRUE
			end
			if player_object.player_id = 2 and player_2_made_inbetween_move=FALSE then
				result:=TRUE
			end
		end

	end

	is_winner_determined : BOOLEAN
	-- Has the winner of the challenges phase been determined?


	win_count(player_id: INTEGER) : INTEGER
	-- How many challenges did the specified player win?
	do
	end


	total_strength(player_id: INTEGER) : INTEGER
	-- What is the total strength of the specified player's units?
	local
		player : GT_LOGIC_PLAYER
		cards_in_play : ARRAYED_LIST[GT_LOGIC_CARD_CHARACTER]
		strength_sum : INTEGER
	do
		if(player_id = 1) then
			player := player_1
		else
			player := player_2
		end

		cards_in_play := player.get_cards_in_play.get_character_cards

		across cards_in_play as card
		loop
			strength_sum := strength_sum + card.item.strength
			check card.item.strength >= 0 end
		end

		result := strength_sum
	end

	choose_attacker(card_id : INTEGER; player_object : GT_LOGIC_PLAYER)
	-- Specify the given card as an attacking character for the player.
	local
		attack_card : GT_LOGIC_CARD
	do
		attack_card := player_object.get_cards_in_play.get_card_by_id (card_id)
		if ATTACHED {GT_LOGIC_CARD_CHARACTER} attack_card as character_card then
			player_one_attackers.extend (character_card)
		else
			check card_was_not_character_type : false end -- TODO: something went wrong.
		end
	end

	choose_defender(card_id : INTEGER; player_object : GT_LOGIC_PLAYER)
	-- Specify the given card as an attacking character for the player
	local
		defend_card : GT_LOGIC_CARD
	do
		defend_card := player_object.get_cards_in_play.get_card_by_id (card_id)
		if ATTACHED {GT_LOGIC_CARD_CHARACTER} defend_card as character_card then
			player_one_defenders.extend (character_card)
		else
			check card_was_not_character_type : false end -- TODO: something went wrong.
		end
	end



	cards_killed(player_id: INTEGER) : ARRAYED_LIST[GT_LOGIC_CARD]
	-- Which cards were killed during the challenge phase?
	do

	end

	cards_attacking(player_id: INTEGER) : ARRAYED_LIST[GT_LOGIC_CARD_CHARACTER]
	-- Which cards are in the attacking position for this player?
	do

	end

	cards_defending(player_id: INTEGER) : ARRAYED_LIST[GT_LOGIC_CARD_CHARACTER]
	-- Which cards are in the defending position for this player?
	do

	end

feature -- Commands
	start_phase
	-- Start the phase -> determine the starting player based on initiative
	do
		if player_1.get_active_plot_card.initiative > player_2.get_active_plot_card.initiative then
			starting_player := player_1
			other_player := player_2
		else
			starting_player := player_2
			other_player := player_1
		end
		start_challenge_procedure
	end

	start_challenge_procedure
	local
		string_input : CHARACTER
		string : STRING
	do
		if starting_player.player_id = 1 and player_1.get_active_plot_card.initiative > player_2.get_active_plot_card.initiative then
			io.put_string ("Select challenge type (M: for military, I: for intrigue P: for power)")
			io.new_line
			io.read_character
			string_input := io.last_character

			if string_input = 'M' then
				challenge_type := {GT_CONSTANTS}.challenge_type_military
			elseif string_input = 'I' then
				challenge_type := {GT_CONSTANTS}.challenge_type_intrigue
			elseif string_input = 'P' then
				challenge_type := {GT_CONSTANTS}.challenge_type_power
			end

			io.put_string ("Choose attacker, avalible characters")
			across starting_player.get_cards_in_hand.get_character_cards as card
			loop
				if starting_player.is_card_playable (card.item.unique_id) then
					io.put_string(card.item.title + " [" + card.item.unique_id.out + "], ")
				end
			end
			io.new_line
			io.read_line
			string := io.last_string

		end
		--to do
		--should control the flow of the challenge phase
		--start setup
		--first call gui to ask current player to choose challenge type


		-- then ask gui to make attacker choose attacking characters
		-- ask gui to make defender choose defending characters

	 	-- start event
	 	-- give option to play events (may not be made)

	 	--start resolve
	end


	end_action(player_id : INTEGER)
	-- and the current action for the player and move to the next subphase
	do
		if current_subphase /= {GT_CONSTANTS}.challenge_subphase_type_resolve then
			move_to_next_subphase
		else
			current_subphase := {GT_CONSTANTS}.challenge_subphase_type_setup
		end
	end

	play (card_id: INTEGER_32; player_object: GT_LOGIC_PLAYER)
	-- Play the specific card in the challenge phase
		--keep track of inbetween moves. IE. Give the player the ability to play event cards
		do
			if player_object.player_id = 1 and attached {GT_LOGIC_CARD_EVENT} player_object.get_card_by_id (card_id) then
				player_1_made_inbetween_move:=TRUE
			end
			if player_object.player_id = 2 and attached {GT_LOGIC_CARD_EVENT} player_object.get_card_by_id (card_id) then
				player_2_made_inbetween_move:=TRUE
			end
		end

	move_to_next_subphase
	-- Proceed to the next subphase.
	do
		if current_subphase = {GT_CONSTANTS}.CHALLENGE_SUBPHASE_TYPE_SETUP then
			current_subphase := {GT_CONSTANTS}.CHALLENGE_SUBPHASE_TYPE_EVENTS
		elseif current_subphase = {GT_CONSTANTS}.CHALLENGE_SUBPHASE_TYPE_EVENTS then
			current_subphase := {GT_CONSTANTS}.CHALLENGE_SUBPHASE_TYPE_RESOLVE
		else
			current_subphase := {GT_CONSTANTS}.CHALLENGE_SUBPHASE_TYPE_RESOLVE
		end
	end
	-- Changes this phase to it's nex subphase

	can_player_play_challenge (player : GT_LOGIC_PLAYER; challenge:STRING) : BOOLEAN
	-- check if a player can play the specific challenge type
	do
		-- Go through each player and check the accompanying boolean indicating whether or not the player has played a specific challenge already.
		if get_current_attacking_player.player_id = player.player_id then
			if player.player_id = 1 then
				if challenge = {GT_CONSTANTS}.challenge_type_military and not player_one_military_done then
					Result := true
				elseif challenge = {GT_CONSTANTS}.challenge_type_intrigue and not player_one_intrigue_done then
					Result := true
				elseif challenge = {GT_CONSTANTS}.challenge_type_power and not player_one_power_done then
					Result := true
				else
					Result := false
				end
			elseif player.player_id = 2 then
				if challenge = {GT_CONSTANTS}.challenge_type_military and not player_two_military_done then
					Result := true
				elseif challenge = {GT_CONSTANTS}.challenge_type_intrigue and not player_two_intrigue_done then
					Result := true
				elseif challenge = {GT_CONSTANTS}.challenge_type_power and not player_two_power_done then
					Result := true
				else
					Result := false
				end
			end
		else
			Result := true
		end
	end
	-- Checks if it is legal for a player to play a specific challenge

	get_current_attacking_player : GT_LOGIC_PLAYER
	do
		if is_starting_player_finished then
			Result := get_opposing_player (starting_player.player_id)
		else
			Result := starting_player
		end
	end

	resolve
	--resolve the challenge
	require
		can_player_play_challenge(player_1, challenge_type)
		can_player_play_challenge(player_2, challenge_type)
	local
		player_attacker : GT_LOGIC_PLAYER
		player_defender : GT_LOGIC_PLAYER
		attacking_cards : ARRAYED_LIST[GT_LOGIC_CARD_CHARACTER]
		defending_cards : ARRAYED_LIST[GT_LOGIC_CARD_CHARACTER]
		attacking_str : INTEGER
		defending_str : INTEGER
		claim_value : INTEGER
	do
		-- Figure out who the attacker is
		player_attacker := get_current_attacking_player

		-- Set collections appropriately and set challenge played
		if player_attacker.player_id = 1 then
			attacking_cards := player_one_attackers
			defending_cards := player_two_defenders
			if challenge_type = {GT_CONSTANTS}.challenge_type_military then
				player_one_military_done := true
			elseif challenge_type = {GT_CONSTANTS}.challenge_type_intrigue then
				player_one_intrigue_done := true
			elseif challenge_type = {GT_CONSTANTS}.challenge_type_power then
				player_one_power_done := true
			end
		else if player_attacker.player_id = 2 then
			attacking_cards := player_two_attackers
			defending_cards := player_one_defenders
			if challenge_type = {GT_CONSTANTS}.challenge_type_military then
				player_two_military_done := true
			elseif challenge_type = {GT_CONSTANTS}.challenge_type_intrigue then
				player_two_intrigue_done := true
			elseif challenge_type = {GT_CONSTANTS}.challenge_type_power then
				player_two_power_done := true
			end
		end

		-- accumulate str for attacker and defender
		across attacking_cards as card
		loop
			attacking_str := attacking_str + card.item.strength
		end

		across defending_cards as card_def
		loop
			defending_str := defending_str + card_def.item.strength
		end

		-- Determine who wins
		if attacking_str >= defending_str then
			claim_value := player_attacker.get_active_plot_card.claim

			if  challenge_type = {GT_CONSTANTS}.challenge_type_military then
				-- Force the other player to kill as many characters as claim value says
				game_board.choose_character_to_kill_on_gui (claim_value)
			end

			if 	challenge_type = {GT_CONSTANTS}.challenge_type_power then
				game_board.discard_cards (player_defender.player_id, claim_value)
			end

			if challenge_type = {GT_CONSTANTS}.challenge_type_intrigue then
				-- force player to discard, call board
				game_board.steal_power_tokens (player_attacker.player_id, player_defender.player_id, claim_value)
			end

			-- If the challenge was unopposed then the attacker receives one free power token. (see rules)
			if defending_str = 0 then
				game_board.give_power_token (player_attacker.player_id, 1)
			end
		end
	end
	--clean up the values for next challenge
	player_one_attackers.make (0)
	player_two_attackers.make (0)
	player_one_defenders.make (0)
	player_two_defenders.make (0)
end



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
	player_one_attackers : ARRAYED_LIST[GT_LOGIC_CARD_CHARACTER]
	player_two_attackers : ARRAYED_LIST[GT_LOGIC_CARD_CHARACTER]

	player_one_defenders : ARRAYED_LIST[GT_LOGIC_CARD_CHARACTER]
	player_two_defenders : ARRAYED_LIST[GT_LOGIC_CARD_CHARACTER]

	player_one_killed_cards : ARRAYED_LIST[GT_LOGIC_CARD_CHARACTER]
	player_two_killed_cards : ARRAYED_LIST[GT_LOGIC_CARD_CHARACTER]


	player_one_military_done : BOOLEAN
	player_one_intrigue_done : BOOLEAN
	player_one_power_done : BOOLEAN

	player_two_military_done : BOOLEAN
	player_two_intrigue_done : BOOLEAN
	player_two_power_done : BOOLEAN


	player_1_made_inbetween_move : BOOLEAN
	player_2_made_inbetween_move : BOOLEAN

	set_subphase(subphase :STRING)
	do
		current_subphase := subphase
	end

	set_challenge_type (type:STRING)
	do
		challenge_type := type
	end

	starting_player : GT_LOGIC_PLAYER
	other_player : GT_LOGIC_PLAYER

	is_starting_player_finished : BOOLEAN

	get_opposing_player(player_id : INTEGER) : GT_LOGIC_PLAYER
	do
		if player_id = player_1.player_id then
			result := player_2
		else if player_id = player_2.player_id then
			result := player_1
			else
				check invalid_player_id : false end
			end
		end
	end

invariant
	invariant_clause: True -- Your invariant here

end
