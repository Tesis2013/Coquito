note
	description: "Summary description for {GT_LOGIC_PLAYER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GT_LOGIC_PLAYER

create
	make

feature {NONE} --this make feature starts the player code.
	make(human : BOOLEAN; house: STRING; server : BOOLEAN)
	do
		-- Set variables
		is_human := human
		is_server := server
		house_card := house
		gold_dragon_tokens := 0
		power_tokens := 0

		if is_server then
			player_id := 1
			is_player_turn := true
		else
			player_id := 2
			is_player_turn := false
		end



		-- Initialization of collections
		create in_play_collection.make
		create in_hand.make
		create dead_pile.make
		create discard_pile.make
		create plot_deck_used.make
		create in_play_collection.make
		create active_text_effects.make (0)

	end


feature {NONE} -- private
	game_board : GT_LOGIC_BOARD
	-- The game board

	AI: GT_AI

	network_component : GT_NET_HOST
	-- the network component for the player

	GUI: GT_GUI_BOARD_WINDOW
	-- Reference to main GUI board window

	is_human : BOOLEAN
	-- Is this player a human or AI?

	is_server: BOOLEAN
	-- Is this player the server?

	has_mulligan : BOOLEAN
	-- Has this player already done a mulligan (do-over)? This should only be able to be set once

	set_gold (amount : INTEGER)
	-- Set the amount of gold the player has
	do
		gold_dragon_tokens := amount
	end

	set_power (amount : INTEGER)
	-- set the amount of power the player has
	do
		power_tokens := amount
	end

	set_is_ready_for_next_phase (input_boolean : BOOLEAN)
	do
		ready_for_next_phase := input_boolean
	end

	set_played_limited (value : BOOLEAN)
	-- Set if the player has played a limited card or not.
	require
	do
		has_played_limited := value
	end

	set_reducedCost (amount : INTEGER)
	do
		reducedCost := amount
	end

feature {NONE} --decks and piles
	in_play_collection: GT_LOGIC_IN_PLAY[GT_LOGIC_CARD]
	house_deck: GT_LOGIC_DECK_HOUSE[GT_LOGIC_CARD]
	in_hand: GT_LOGIC_HAND[GT_LOGIC_CARD]
	active_plot_card : GT_LOGIC_CARD_PLOT
	dead_pile: GT_LOGIC_PILE_DEAD[GT_LOGIC_CARD]
	discard_pile: GT_LOGIC_PILE_DISCARD[GT_LOGIC_CARD]
	plot_deck: GT_LOGIC_DECK_PLOT[GT_LOGIC_CARD_PLOT]
	plot_deck_used: GT_LOGIC_PILE_PLOT_USED[GT_LOGIC_CARD_PLOT]

	-- Reference to phase handler
	phase_handler : GT_LOGIC_HANDLER_PHASE


feature { ANY } -- queries
	reducedCost : INTEGER assign set_reducedCost
	-- Reduced cost on next House specific character card

	reset_reducedCost
	do
		reducedCost := 0
	end

	active_text_effects : ARRAYED_LIST[TUPLE[GT_LOGIC_CARD, GT_LOGIC_TEXT_EFFECT]]
	-- The currently active text effects for this player

	contains_text_effect (id : STRING) : TUPLE[GT_LOGIC_CARD, GT_LOGIC_TEXT_EFFECT]
	local
		tuple : TUPLE[GT_LOGIC_CARD, GT_LOGIC_TEXT_EFFECT]
		return_tuple : TUPLE[GT_LOGIC_CARD, GT_LOGIC_TEXT_EFFECT]
		i : INTEGER
	do
		from
			i := 1
		until
			i > active_text_effects.count
		loop
			tuple := active_text_effects.at (i)
			if
				attached {GT_LOGIC_TEXT_EFFECT} tuple.item (2) as text_effect
			then
				if
					text_effect.id = id
				then
					return_tuple := tuple
				end
			end
		end
		result := return_tuple
	end

	ready_for_next_phase : BOOLEAN assign set_is_ready_for_next_phase
	-- is the player ready for the next phase?

	house_card : STRING
	-- Which house am I playing?

	is_player_turn : BOOLEAN
	-- is it the player's turn?

	player_id : INTEGER
	-- What is the player's ID?

	is_player_server: BOOLEAN
	-- Is the player the server?
	do
		result := is_server
	end

	gold_dragon_tokens : INTEGER assign set_gold
	-- The amount of gold dragon tokens the player has

	power_tokens : INTEGER assign set_power
	-- The amount of power tokens the player has

	has_played_limited : BOOLEAN assign set_played_limited
	-- Has the player played a limited card this round?

	-- CARDS
	get_visible_cards_in_play: GT_LOGIC_IN_PLAY[GT_LOGIC_CARD]
	-- Which of my cards are currently in play on the board (visible)? -- TODO: This should be removed, since all of this players cards should be visible. TODO: add get visible cards in play to the board
	local
		visible_cards : GT_LOGIC_IN_PLAY[GT_LOGIC_CARD]
	do
		create visible_cards.make

		across in_play_collection.to_arrayed_list as card
		loop
			if(true) then
				-- Add only cards that are visible (pending iterative collection implementation)
				visible_cards.add_card (card.item)
			end
		end
		result := in_play_collection
	end

	get_visible_cards_in_piles: GT_LOGIC_PILE[GT_LOGIC_CARD] --What is this?
	-- Which cards are currently visible in my piles?
		do
		end


	get_cards_in_hand : GT_LOGIC_HAND [GT_LOGIC_CARD]
	-- Which cards are in the players' hand?
	require
		do
			result := in_hand
		ensure
			-- ensures (for each Card c in collection, c.state = "in hand").
		end

	get_cards_in_plot_deck : GT_LOGIC_DECK_PLOT[GT_LOGIC_CARD_PLOT]
	-- Which cards are in the player's plot deck?
	require
		plot_deck /= void
	do
		result := plot_deck
	end


	get_cards_in_discard_pile : GT_LOGIC_PILE_DISCARD [GT_LOGIC_CARD]
	-- Which cards are in the player's discard pile?
	do
		result := discard_pile
	end

	get_cards_in_dead_pile : GT_LOGIC_PILE_DEAD [GT_LOGIC_CARD]
	-- Which cards are in the player's dead pile?

	get_cards_in_house_deck : GT_LOGIC_DECK_HOUSE [GT_LOGIC_CARD]
	-- Which cards are in the player's house deck?
	-- The player shouldn't be able to see the cards in his house deck?
	do
		result := house_deck
	end

	get_cards_in_used_plot_pile : GT_LOGIC_PILE_PLOT_USED[GT_LOGIC_CARD_PLOT]
	-- Which cards are in the player's used plot pile?
	require
		plot_deck_used /= void
	do
		result := plot_deck_used
	end

	get_cards_in_play : GT_LOGIC_IN_PLAY[GT_LOGIC_CARD]
	-- which cards are in the in play collection?
	require
		in_play_collection /= void
	do
		result := in_play_collection
	end


	get_cards_in_play_as_arrayed_list : ARRAYED_LIST[GT_LOGIC_CARD]
	-- Returns the cards in play as an arrayed list
	require
		in_play_collection /= void
	do
		result := in_play_collection.to_arrayed_list
	end

	get_active_plot_card : GT_LOGIC_CARD_PLOT
	-- returns the active plot card, void if non plot card has been played
	do
		result := active_plot_card
	end

	set_active_plot_card(card : GT_LOGIC_CARD_PLOT)
	do
		active_plot_card := card
	end

	is_card_playable(card_id: INTEGER_32): BOOLEAN
	--this checks if the card can be played by this player.
	local
		playable_in_phase: BOOLEAN
		card_to_check: GT_LOGIC_CARD
	do
		--Check that the card can be played in the current phase.
		playable_in_phase := phase_handler.get_current_phase.is_card_playable_in_phase (card_id, CURRENT)

		--get current card, to check if kneeling
		card_to_check := get_card_by_id (card_id)

		--Check that the player has the card in play or hand. If both are true, then the card can be played.	
		if get_cards_in_play.contain (card_id) or get_cards_in_hand.contain (card_id) then
			if playable_in_phase = TRUE and card_to_check.kneeling=FALSE then
				result := TRUE
			end
		end
	end

	set_AI(input_ai: GT_AI)
		do
			AI := input_ai
		end

	get_ai : GT_AI
	require
		ai /= void
	do
		result := ai
	end

	get_card_by_id(unique_id: INTEGER_32) : GT_LOGIC_CARD
	-- what card is represented by this unique id? Will cause errors if called with a card the player does not have.

	do
		if get_cards_in_play.contain (unique_id) then result := get_cards_in_play.get_card_by_id (unique_id)
		end

		if get_cards_in_hand.contain (unique_id) then result := get_cards_in_hand.get_card_by_id (unique_id)
		end

		if get_cards_in_discard_pile.contain (unique_id) then result := get_cards_in_discard_pile.get_card_by_id (unique_id)
		--TODO check the naming
		end

		if get_cards_in_plot_deck.contain (unique_id) then result := get_cards_in_plot_deck.get_card_by_id (unique_id)

		end

		if get_cards_in_house_deck.contain (unique_id) then result := get_cards_in_house_deck.get_card_by_id (unique_id)

		end
	end

	get_is_human : BOOLEAN
	do
		result := is_human
	end

	get_phase_handler : GT_LOGIC_HANDLER_PHASE
	do
		result := phase_handler
	end

	is_player_ready_for_next_phase : BOOLEAN
	do
		result := ready_for_next_phase
	end

feature -- Commands

	draw(number_of_cards: INTEGER)
	-- Draw the specified amounts of card
	require
		number_of_cards >= 0
		house_deck.size >= number_of_cards
	local
		popped_card : GT_LOGIC_CARD
		count : INTEGER
		command : GT_NET_DRAW_COMMAND
	do
		from count := 0
		until count = number_of_cards
		loop
			popped_card := house_deck.pop
			in_hand.add_card (popped_card)
			count := count + 1
		end
		if
			network_component /= Void and number_of_cards > 0
		then
			create command.make_draw_command (number_of_cards)
			network_component.send (command)
		end

		game_board.gui_update
	ensure
		in_hand.size = old in_hand.size + number_of_cards
		house_deck.size = old house_deck.size - number_of_cards
	end

	play(card_id: INTEGER_32)
	-- Put this card into play
	require
		phase_handler.get_current_phase.is_card_playable_in_phase (card_id, current)
	local
		card: GT_LOGIC_CARD
		limited_keyword : GT_LOGIC_KEYWORD
		defer_to_play_plot_card_feature : BOOLEAN
		command : GT_NET_PLAY_COMMAND
	do
		-- If the card is a plot card, then we should use the play plot card feature instead
		if attached {GT_LOGIC_CARD_PLOT} get_card_by_id (card_id) and attached {GT_LOGIC_PHASE_PLOT} phase_handler.get_current_phase then
			defer_to_play_plot_card_feature := true

			play_plot_card (card_id)
		end

		if in_play_collection.contain (card_id) then  --if the card is in play, this means that the card should be activated.

		end

		-- If the card has already been handled in another feature, don't do anything.

		if not defer_to_play_plot_card_feature then

			card := get_cards_in_hand.get_card_by_id (card_id) --create a local reference to the card
			card := get_cards_in_hand.remove_card_by_id (card_id) --remove the reference in the in_hand
			get_cards_in_play.add_card(card) --add the card to the in_play
			--gold_dragon_tokens := gold_dragon_tokens - card.cost
			if
				network_component /= void
			then
				create command.make_one_card (card_id)
				network_component.send (command)
			end
			--TODO on play effects
		end
			--
			create limited_keyword.make ({GT_CONSTANTS}.KEYWORD_LIMITED)
			if card /= void AND card.keywords.has (limited_keyword) then
				has_played_limited := TRUE
			end
			game_board.gui_update


	end
		--TODO ensures

	play_attachment(attachment_id: INTEGER; card_attached_to_id : INTEGER)
	-- Attach this card to the specified card
	require
		attachment_id /= card_attached_to_id
		attached {GT_LOGIC_CARD_ATTACHMENT} get_card_by_id (attachment_id) -- The attachment should be of type attachment card
	do

	ensure
	end

	remove_text_effect (id : STRING)
	-- Finds the specified text effect and removes it from the active play
	local
		tuple : TUPLE[GT_LOGIC_CARD, GT_LOGIC_TEXT_EFFECT]
		i : INTEGER
		a : INTEGER
	do
		a := 0
		from
			i := 1
		until
			i > active_text_effects.count
		loop
			tuple := active_text_effects.at (i)
			if
				attached {GT_LOGIC_TEXT_EFFECT} tuple.item (2) as text_effect
			then
				if
					text_effect.id = id
				then
					a := i
				end
			end
		end
		active_text_effects.go_i_th (a)
		active_text_effects.remove
	end

	play_plot_card(plot_card_id: INTEGER)
	-- Mange the collections and move the plot card into the active plot card. Then call the phase handler and initiate its play method. Also dispatch network event.
	require
		plot_deck.contain (plot_card_id)
	local
		command : GT_NET_PLAY_COMMAND
		plot_card : GT_LOGIC_CARD_PLOT
	do
		-- Add the active plot card into the equation
		if active_plot_card /= void then
			plot_deck_used.add_card (active_plot_card)
			active_plot_card := void
		end

		if
			-- All plot cards have been played, reset the plot deck
			plot_deck.size = 0
		then
			shuffle_plot_cards
		end

		-- Manage collections (Remove the selected card from the plot deck), and give it to the handler to play
		plot_card := plot_deck.remove_card_by_id (plot_card_id)
		set_active_plot_card (plot_card)

		phase_handler.get_current_phase.play_plot_card (plot_card_id, current)

		if	network_component /= void
			then
				create command.make_one_card (plot_card_id)
				network_component.send (command)
			end


		-- Update the GUI
		game_board.gui_update

	ensure
		plot_deck.contain (plot_card_id) = false
		plot_deck.size = old plot_deck.size - 1
		-- plot_deck_used.size = old plot_deck_used.size + 1 -- TODO: This is not the case since if it is the first card to be played, then no card goes from active to used.
	end

	choose_challenge_type(type : STRING)
	-- Specify if the player will initiate a power, military or intrigue challenge.
	require
	do
		if attached {GT_LOGIC_PHASE_CHALLENGES} phase_handler.get_current_phase as challenge_phase then

			if type = {GT_CONSTANTS}.challenge_type_power then
				challenge_phase.challenge_type := {GT_CONSTANTS}.challenge_type_power
			else if type = {GT_CONSTANTS}.challenge_type_military  then
				challenge_phase.challenge_type := {GT_CONSTANTS}.challenge_type_military
			else if type = {GT_CONSTANTS}.challenge_type_intrigue then
				challenge_phase.challenge_type := {GT_CONSTANTS}.challenge_type_intrigue
					end
				end
			end
		end

	end

	choose_attacker(card_id : INTEGER)
	-- Choose the specified as an attacker
	require
		-- Requires that card_id.Type = character card?
		attached {GT_LOGIC_PHASE_CHALLENGES} phase_handler.get_current_phase as challenge_phase
		challenge_phase.current_subphase = {GT_CONSTANTS}.challenge_subphase_type_setup
	local
		attack_command : GT_NET_CHOOSE_ATTACKER_COMMAND
	do
		phase_handler.get_current_phase.choose_attacker (card_id, current)
		if network_component /= void then
			create attack_command.make_choose_attacker_command (card_id)
			network_component.send (attack_command)
		end
	end


	choose_defender(card_id : INTEGER)
	-- Choose the specified card as a defender
	require
		-- Requires that card_id.Type = character card?
		-- Phase == challenge phase
		attached {GT_LOGIC_PHASE_CHALLENGES} phase_handler.get_current_phase as challenge_phase
		challenge_phase.current_subphase = {GT_CONSTANTS}.challenge_subphase_type_setup
	local
		defend_command : GT_NET_CHOOSE_DEFENDER_COMMAND
	do
		phase_handler.get_current_phase.choose_attacker (card_id, current)
		if network_component /= void then
			create defend_command.make_choose_defender_command (card_id)
			network_component.send (defend_command)
		end
	end

	end_action
	-- End your current action turn
	require
	local
		end_command : GT_NET_END_TURN_COMMAND
	do

		if attached {GT_LOGIC_PHASE_CHALLENGES} phase_handler.get_current_phase as challenge_phase then
			challenge_phase.end_action(player_id)
		end

		if
			player_id = 1 and game_board.get_player_from_id (2).get_is_human = TRUE --if playing against a network player
		then
			create end_command.default_create
	--		network_component.send (end_command)
		end
		if
			player_id = 1 and game_board.get_player_from_id (2).get_is_human = FALSE --if playing against AI
		then
			game_board.get_player_two.get_ai.make_move
		end

	end

	shuffle(deck : GT_LOGIC_DECK_HOUSE[GT_LOGIC_CARD])
	-- shuffle the cards, this sends a synch command over the network to make sure that the decks are ordered the same on both computers.
	local
		command : GT_NET_SYNCHRONIZE_COMMAND
	do
		deck.shuffle
		if
			network_component /= void
		then
			create command.make_synchronize_command (deck)
			network_component.send (command)
		end
	end

	end_turn
	-- indicate that your turn is over and you are not interested in performing any actions for this phase
	do
		ready_for_next_phase := true
		set_is_player_turn(false)

		game_board.end_turn (player_id)
		if network_component /= void then
			network_component.send (create {GT_NET_END_TURN_COMMAND})
		end
		if player_id = 1 and game_board.get_player_two.get_is_human = false then
			game_board.get_player_two.get_ai.make_move
		end
	end

	synchronize(deck: GT_LOGIC_DECK[GT_LOGIC_CARD])
	-- Synchronize this players house deck with the deck given
	local
		i:INTEGER
		card_order: ARRAYED_LIST[INTEGER]
		loop_card_id : INTEGER
		temp_deck: ARRAYED_LIST[GT_LOGIC_CARD]
		temp_house_deck: GT_LOGIC_DECK_HOUSE[GT_LOGIC_CARD]
	do
		-- gets the given deck card order based on card id.
		card_order := deck.get_card_order()
		create temp_deck.make (deck.size)
		-- Goes through the card_order and pulls the cards out of house_deck and puts them in the order of the deck given
		from i := 0 until i >= card_order.count
		loop
			loop_card_id := card_order.array_at (i)
			temp_deck.array_put (house_deck.get_card_by_id (loop_card_id), i)
			i:=i+1
		end
		--Make a new GT_LOGIC_DECK_HOUSE and add the content of the ARRAYED_LIST to this
		create temp_house_deck.make()
		temp_house_deck.push_bottom (temp_deck)
		-- Reassign the Decks
		house_deck := temp_house_deck

	end

	set_is_server(input_boolean: BOOLEAN)
	do
		is_server:=input_boolean
	end

	set_network_component (input_network_component : GT_NET_HOST)
	do
		network_component := input_network_component
	end

	set_phase_handler (handler : GT_LOGIC_HANDLER_PHASE)
	do
		phase_handler := handler
	end

	set_game_board_and_initialize_cards (board : GT_LOGIC_BOARD)
	-- Set the game board and populate card collections
	local
		card_loader : GT_LOGIC_CARD_LOADER
	do
		game_board := board
		-- load cards
		create card_loader.make (house_card, is_server, game_board)
		house_deck := card_loader.house_deck
		plot_deck := card_loader.plot_deck
		reducedCost := 0
	end

	set_is_player_turn(input_boolean : BOOLEAN)
	-- Set if it is the player's turn
	do
		is_player_turn := input_boolean
	end


	set_starting_player(starting_player : GT_LOGIC_PLAYER)
	-- This feature will send a network command, setting the starting player on the receiving instance
	local
		command : GT_NET_SET_STARTING_PLAYER_COMMAND
	do
		if network_component /= void then
			create command.make_set_starting_player_command (starting_player.player_id)
			network_component.send (command)
		else if
			player_id = 1 and game_board.get_player_from_id (2).get_is_human = FALSE then
				if starting_player.player_id = 2 then
					game_board.get_player_two.set_is_player_turn (true)
					game_board.get_player_one.set_is_player_turn (true)
				end
			end
		end
	end




shuffle_plot_cards
-- Shuffle the plot cards in the used pile back to the unused plot deck.
local
	count : INTEGER
do
	from
		count := 0
	until
		count = 7
	loop
		plot_deck.add_card (plot_deck_used.pop)
	end

ensure
	plot_deck.size = 7
	plot_deck_used.size = 0
end

invariant
	invariant_clause: True -- Your invariant here

end
