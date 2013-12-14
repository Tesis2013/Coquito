note
	description: "Summary description for {GT_LOGIC_TEXT_EFFECT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GT_LOGIC_TEXT_EFFECT

create
	make

feature {ANY} -- initialization
	make(input: STRING; text_effect_id : STRING; game_board : GT_LOGIC_BOARD)
	do
		text := input
		id := text_effect_id
		board := game_board
	end

feature -- Queries
	text : STRING
	-- What is my text?

	id : STRING
	-- What is my id?

	board : GT_LOGIC_BOARD
	-- What is my board?

feature -- Commands
	play_simple(card : GT_LOGIC_CARD; player : GT_LOGIC_PLAYER)
	do
		play(card, player, void)
	end

	play (card : GT_LOGIC_CARD; player : GT_LOGIC_PLAYER; affected_card : GT_LOGIC_CARD)
	--Active this effect, parameters are the card whose effect it is and player who played it and a card effected by it
	local
		card_id : INTEGER
		random_card : GT_LOGIC_CARD
	do
		card_id := card.unique_id
		if
			id = "S11"
		then
			shaggydog_s11 (player, card.unique_id, board)
		end

		if
			id = "S25"
		then
			--Run effect for card "Winterfell Castle"
			--"Each of your STARK characters get +1 STR"
			--During challenge phase whenever a STARK character STR is counted do +1
		end

		if
			id = "B99"
		then
			--Run effect for card "Narrow Sea"
			--"Discard this from play to reduce the cost of the next STARK character you play this phase by 2"
			random_card := player.get_cards_in_play.remove_card_by_id (card.unique_id)
			player.get_cards_in_discard_pile.add_card (card)
			player.reducedCost := player.reducedCost + 2
		end

		if
			id = "S32"
		then
			--Run effect for card "Godswood"
			--"Kneel this to lower the cost of the next STARK character you play this phase by 2
			card.kneeling := true --This doesn't work, how do make a card kneel?
			player.reducedCost := player.reducedCost + 2
		end

		if
			id = "S177"
		then
			if attached {GT_LOGIC_CARD_CHARACTER} affected_card as affected_character
			then
				distinct_mastery_s177 (affected_character)
			end
		end

		if
			id = "L49"
		then
			if attached {GT_LOGIC_CARD_CHARACTER} card as affected_character
			then
				qyburns_informers_l49 (player, affected_character, board)
			end
		end

		if
			id = "L57"
		then
			--Run effect for card "Golden Tooth Mines"
			--"Each time you reveal a plot card, draw a card"
			--Run each time a plot card is played
			if
				player.get_cards_in_play.contain (card.unique_id)
			then
				player.get_cards_in_hand.add_card (player.get_cards_in_house_deck.pop)
			else
				player.remove_text_effect (current.id)
			end
		end

		if
			id = "L65"
		then
			--Run effect for card "Sunset Sea"
			--"Discard this from play to reduce the cost of the next LANNISTER character you play this phase by 2
			random_card := player.get_cards_in_play.remove_card_by_id (card.unique_id)
			player.get_cards_in_discard_pile.add_card (card)
			player.reducedCost := player.reducedCost + 2
		end

		if
			id = "L64"
		then
			--Run effect for card "Hall of Heroes"
			--"Kneel this to reduce the cost of the next LANNISTER character you play this phase by 2"
			card.kneeling := true --This doesn't work, how to make a card kneel?
			player.reducedCost := player.reducedCost + 2
		end

		if
			id = "L162"
		then
			if attached {GT_LOGIC_CARD_CHARACTER} affected_card as affected_character
			then
				the_lions_will_l162 (player, affected_character)
			end
		end
	end

feature {NONE}
	shaggydog_S11(current_player : GT_LOGIC_PLAYER;current_card_id:INTEGER; game_board:GT_LOGIC_BOARD)
	--The text effect for "Shaggydog"
	local
		card : GT_LOGIC_CARD
	do
		-- counts the number of cards on players hand with the trait "Lord"
		if count_cards_on_board_with_this_trait("Lord", current_player.player_id,game_board) >= 1 then
			-- if the number is equal or higher than one, then the effect is active and gives the shaggydog a STR+3 modifier
			card := current_player.get_cards_in_play.get_card_by_id (current_card_id)
			if attached {GT_LOGIC_CARD_CHARACTER} card as current_card then
				current_card.strength_modifier := current_card.strength_modifier + 3
			end
		end
	end

	distinct_mastery_s177(affected_character: GT_LOGIC_CARD_CHARACTER)
	--The text effect for "Distinct Mastery"
	do
		if affected_character.crests.occurrences ("noble") >0 or affected_character.crests.occurrences ("learned") >0 or affected_character.crests.occurrences ("holy") > 0 or affected_character.crests.occurrences ("war") >0 then
			affected_character.kneeling := false
		end
	end

	qyburns_informers_l49 (current_player : GT_LOGIC_PLAYER;current_card :GT_LOGIC_CARD_CHARACTER; game_board:GT_LOGIC_BOARD)
	--The text effect for Qyburn's Informers"
	local
		current_phase : GT_LOGIC_PHASE
	do
		if game_board.get_current_phase.get_phase_identifer = {GT_CONSTANTS}.phase_challenges then
			current_phase := game_board.get_current_phase
			if attached {GT_LOGIC_PHASE_CHALLENGES} current_phase as challenge_phase then
				if challenge_phase.cards_attacking (current_player.player_id).occurrences (current_card)> 0 or challenge_phase.cards_defending (current_player.player_id).occurrences (current_card) > 0 then
					current_player.draw (2)
				end
			end
		end
	end

	the_lions_will_l162 (current_player : GT_LOGIC_PLAYER; affected_character: GT_LOGIC_CARD_CHARACTER)
	--The text effect for "The Lion's Will"
	do
		if current_player.gold_dragon_tokens >= 2 then
			current_player.gold_dragon_tokens := current_player.gold_dragon_tokens-2
			affected_character.kneeling := true
		end
	end

feature {NONE} -- Auxiliary functions

	count_cards_on_board_with_this_trait(trait : STRING; current_player_id:INTEGER ;game_board:GT_LOGIC_BOARD) : INTEGER
	--Returns the number of cards on the board with the given trait
	local
		count : INTEGER
	do
		count := 0
		across game_board.get_player_from_id (current_player_id).get_cards_in_play_as_arrayed_list as card
		loop
			if card.item.traits.occurrences (trait) >= 1 then
				count := count +1
			end
		end
		Result := count
	end


end
