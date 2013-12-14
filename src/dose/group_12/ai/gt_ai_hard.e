note
	description	: "AI level Hard"
	author		: "RioCuarto2"
	date		: "11/12/2013"
	revision	: ""

class
	GT_AI_HARD

inherit
	GT_AI
		redefine
			make
		end

create
	make

feature -- Initialization

	make(player:GT_LOGIC_PLAYER; board:GT_LOGIC_BOARD)
			-- Constructor of the AI
		do
			ai_player := player
			ai_board := board
		end

feature -- Implementation

	change_initial_card: BOOLEAN
			-- Decides whether to change the 7 initial cards for others 7
		local
			percentage:INTEGER -- Default zero
			deck: ARRAYED_LIST[GT_LOGIC_CARD]
		do
			-- Weighting of the cards in the hand
			deck := ai_player.get_cards_in_hand.to_arrayed_list
			percentage := 0
			percentage := all_card_types(deck) + average_cost(deck) + average_strength(deck) + amount_character_cards(deck)
			if percentage > 65 then
				Result := False
			elseif percentage < 35 then
				Result := True
			elseif (percentage <= 65) and (percentage >= 35) then
				Result :=  random_integer(3) = 3
			end
		end --end change_initial_card		

	choose_plot_card: GT_LOGIC_CARD_PLOT
			-- Choose de plot card
		local
			percentage:INTEGER -- Default zero
			deck: ARRAYED_LIST[GT_LOGIC_CARD]
		do
			deck := ai_player.get_cards_in_play_as_arrayed_list
			percentage := all_card_types(deck) + average_cost(deck) + average_strength(deck) + amount_character_cards(deck)
			if  percentage > 50 then
				Result := choose_best_plot_card("CLAIM")
			else
				Result := choose_best_plot_card("GOLD")
			end
		end

	choose_cards_to_kill
		--choose that cards kill
		local
			i, no_character: INTEGER
			ordered_cards: ARRAYED_LIST[TUPLE[c: GT_LOGIC_CARD; v: INTEGER]]
			current_card: GT_LOGIC_CARD
			tuple: TUPLE[c: GT_LOGIC_CARD; v: INTEGER]
		do
			-- Arranges the cards according to their valuation
			create ordered_cards.make (7)
			from
				i := 0
			until
				ai_player.get_cards_in_play.to_arrayed_list.count <= i
			loop
				current_card := ai_player.get_cards_in_play.to_arrayed_list.array_item (i)
				if attached{GT_LOGIC_CARD_CHARACTER} current_card as card then
					create tuple.default_create
					tuple.put (card, 1)
					tuple.put (valuation_character(card), 2)
					insertion_sort(tuple, ordered_cards)
				elseif attached{GT_LOGIC_CARD_LOCATION} current_card as card then
					create tuple.default_create
					tuple.put (card, 1)
					tuple.put (valuation_location(card), 2)
					insertion_sort(tuple, ordered_cards)
				end
				i := i + 1
			end --end loop

			-- kill card in position 0 in the ordered_cards array
			ai_board.kill_character (ai_player.player_id, ordered_cards.array_item (0).c.unique_id)
		end

	choose_cede_initiative
			-- Decides whether or not the initiative gives, considering playing card
		local
			percentage:INTEGER -- Default zero
			deck: ARRAYED_LIST[GT_LOGIC_CARD]
		do
			deck := ai_player.get_cards_in_play_as_arrayed_list
			percentage := all_card_types(deck) + average_cost(deck) + average_strength(deck) + amount_character_cards(deck)
			if percentage <= 40 then
				-- method cede initiative
			end
		end

	choose_challenge: STRING
	    local
			i: INTEGER
			military, intrigue, power: INTEGER
			tuple: TUPLE[s: STRING; v: INTEGER]
			list_challenge: ARRAYED_LIST [TUPLE[s: STRING; v: INTEGER]]
		do
			i := 0
			military := 0
			intrigue := 0
			power := 0
			from -- plus AI_PLAYER strength
				i := 0
			until
				i >= ai_player.get_cards_in_play_as_arrayed_list.count
			loop
				if not ai_player.get_cards_in_play_as_arrayed_list.array_item(i).kneeling then
					if attached {GT_LOGIC_CARD_CHARACTER} ai_player.get_cards_in_play.to_arrayed_list.array_item(i) as character then
						if character.military and not military_challenge_used then
							military := military + character.strength

						elseif character.intrigue and not intrigue_challenge_used then
							intrigue := intrigue + character.strength

						elseif character.power and not power_challenge_used then
							power := power + character.strength

						end
					end
				end
				i := i + 1
			end -- loop
			from -- less PLAYER strength
				i := 0
			until
				i >= ai_board.get_player_one.get_cards_in_play_as_arrayed_list.count
			loop
				if not ai_board.get_player_one.get_cards_in_play_as_arrayed_list.array_item(i).kneeling then
					if attached {GT_LOGIC_CARD_CHARACTER} ai_board.get_player_one.get_cards_in_play.to_arrayed_list.array_item(i) as character then
						if character.military and not military_challenge_used then
							military := military - character.strength

						elseif character.intrigue and not intrigue_challenge_used then
							intrigue := intrigue - character.strength

						elseif character.power and not power_challenge_used then
							power := power - character.strength

						end
					end
				end
				i := i + 1
			end -- loop

			create list_challenge.make (3)
			if ai_player.house_card = {GT_CONSTANTS}.house_lannister then -- if the house is Lannistar has more chance to make a challenge of Intrigue
				if intrigue > -1 then
					create tuple.default_create
					tuple.put (intrigue, 2)
					tuple.put ("intrigue", 1)
					list_challenge.extend (tuple)
				end
			else
				if intrigue > 1 then
					create tuple.default_create
					tuple.put (intrigue, 2)
					tuple.put ("intrigue", 1)
					list_challenge.extend (tuple)
				end
			end
			if ai_player.house_card = {GT_CONSTANTS}.house_stark then --if the house is Stark has more chance to make a challenge of Military
				if military > -1 then
					create tuple.default_create
					tuple.put (intrigue, 2)
					tuple.put ("military", 1)
					list_challenge.extend (tuple)
				end
			else
				if military > 1 then
					create tuple.default_create
					tuple.put (military, 2)
			    	tuple.put ("military", 1)
					list_challenge.extend (tuple)
				end
			end
			if power > 0 then
				create tuple.default_create
				tuple.put (power, 2)
				tuple.put ("power", 1)
				list_challenge.extend (tuple)
			end
			if list_challenge.count = 0 then
				Result := "no challenge"
			else
			    tuple := less(list_challenge)
				Result := tuple.s
			end

	end --End choose_challenge


	choose_initial_cards
			-- Choose initial cards in setup phase
		local
			i, no_character: INTEGER
			ordered_cards: ARRAYED_LIST[TUPLE[c: GT_LOGIC_CARD; v: INTEGER]]
			current_card: GT_LOGIC_CARD
			tuple: TUPLE[c: GT_LOGIC_CARD; v: INTEGER]
		do
			-- Arranges the cards according to their valuation
			create ordered_cards.make (7)
			from
				i := 0
			until
				ai_player.get_cards_in_hand.to_arrayed_list.count <= i
			loop
				current_card := ai_player.get_cards_in_hand.to_arrayed_list.array_item (i)
				if attached{GT_LOGIC_CARD_CHARACTER} current_card as card then
					create tuple.default_create
					tuple.put (card, 1)
					tuple.put (valuation_character(card), 2)
					insertion_sort(tuple, ordered_cards)
				elseif attached{GT_LOGIC_CARD_LOCATION} current_card as card then
					create tuple.default_create
					tuple.put (card, 1)
					tuple.put (valuation_location(card), 2)
					insertion_sort(tuple, ordered_cards)
				end
				i := i + 1
			end
			-- Indicates that the cards played are not character
			no_character := 0

			-- select the cards to play
			from
				i := ordered_cards.count - 1
			until
				0 > i
			loop
				current_card := ordered_cards.array_item (i).c
				if (attached{GT_LOGIC_CARD_CHARACTER} current_card as card) and ai_player.is_card_playable (current_card.unique_id) then
					ai_player.play (current_card.unique_id)
				elseif (attached{GT_LOGIC_CARD_LOCATION} current_card as card) and ai_player.is_card_playable (current_card.unique_id) and (no_character<2) then
					ai_player.play (current_card.unique_id)
					no_character := no_character + 1
				end
				i := i + 1
			end

		end

	choose_defense (phase: GT_LOGIC_PHASE_CHALLENGES)
			-- Choose defense cards
		local
			visible_cards_ai, cards_to_defence: ARRAYED_LIST[GT_LOGIC_CARD]
			i, power_op: INTEGER
		do
			-- Visible cards of ai_player
			visible_cards_ai := ai_player.get_cards_in_play_as_arrayed_list
			-- Power put in play
			power_op := phase.total_strength (ai_board.get_player_one.player_id)
			-- Choose cards to defend (minimal convination of cards)
			cards_to_defence := cards_to_play(power_op, visible_cards_ai)
			from
				i := 0
			until
				i >= cards_to_defence.count
			loop
				-- Put into play the chosen cards
	 			ai_player.choose_defender (cards_to_defence.array_item (i).unique_id)
				i := i + 1
			end
		end

	choose_attack (challenge: STRING)
			-- Choose attack cards
		local
			better_human_card : GT_LOGIC_CARD_CHARACTER
			human_card_strength : INTEGER_32
			all_my_character_cards : ARRAYED_LIST[GT_LOGIC_CARD]
			possibles_moves :  ARRAYED_LIST[ ARRAYED_LIST[GT_LOGIC_CARD]]
			my_move : ARRAYED_LIST[GT_LOGIC_CARD]
			possible_move : ARRAYED_LIST[GT_LOGIC_CARD]

			acum : INTEGER_32
			my_minimum_winner_strength : INTEGER_32
			minimun_number_of_cards : INTEGER_32

			i, j :INTEGER_32
		do
			 -- i obtain the strength of the "better" human's card for a said challenge
			better_human_card := biggest_opponent_card(ai_board.get_player_one.get_cards_in_play_as_arrayed_list, challenge)
			human_card_strength := better_human_card.strength
				-- i should now choose the minimun tuple of cards that win against the human card
			all_my_character_cards := filter_character_cards (ai_player.get_cards_in_play_as_arrayed_list, challenge)
			possibles_moves := permutation (all_my_character_cards)
			minimun_number_of_cards := {INTEGER}.max_value
			my_minimum_winner_strength := {INTEGER}.max_value
			from
				i := 0
			until
				i >= possibles_moves.count
			loop
				acum := 0
				possible_move := possibles_moves.array_at (i)
				from
					j := 0
				until
					j >= possible_move.count
				loop
					if attached {GT_LOGIC_CARD_CHARACTER} possible_move.array_item (j) as card then
						acum := card.strength + acum
					end
					j := j + 1
				end
				if acum > human_card_strength and (acum < my_minimum_winner_strength or possible_move.count < minimun_number_of_cards) then
					my_minimum_winner_strength := acum
					minimun_number_of_cards := possible_move.count
					my_move := possible_move
				end
				i := i +1
			end

			from
				i := 0
			until
				i >= my_move.count
			loop
				ai_player.choose_attacker (my_move.array_item (i).unique_id)
				i := i + 1
			end
		end

	choose_cards_to_recruit
			-- Choose cards to rescuit in Marshalling Phase
		local
			i: INTEGER
			list: ARRAYED_LIST[STRING]
			list_current : ARRAYED_LIST[GT_LOGIC_CARD]
		do
			list := missing_cards_types(ai_player.get_cards_in_play_as_arrayed_list)
			list_current := current_hand(ai_player.get_cards_in_hand.to_arrayed_list, list)
			from
				i := 0
			until
				i >= list_current.count
			loop
				if ai_player.is_card_playable (list_current.array_item (i).unique_id) then
					ai_player.play (list_current.array_item (i).unique_id)
				end
				i := i + 1
			end
		end

feature -- Implementation (choose_attack)

	filter_character_cards(cards_to_filter : ARRAYED_LIST[GT_LOGIC_CARD]; challenge: STRING):ARRAYED_LIST[GT_LOGIC_CARD_CHARACTER]
		  --Given an arrayed_list of cards returns another arrayed_list with only the characters cards of the first one
		local
			i : INTEGER_32
			res : ARRAYED_LIST[GT_LOGIC_CARD_CHARACTER]
			auxiliar_card:GT_LOGIC_CARD
		do
			res.make (0)
			from i:= 0
			until i = cards_to_filter.count
			loop
				auxiliar_card := cards_to_filter.array_at (i)
				if attached {GT_LOGIC_CARD_CHARACTER} auxiliar_card as character then
					if can_participate(character, challenge)then
						res.extend (character)
					end
				end
				i:= i+1
			end
			Result := res
		end

	can_participate(card:GT_LOGIC_CARD_CHARACTER; string: STRING):BOOLEAN
			-- returns if a card can participate in some challenge
		local
			res:BOOLEAN
		do
			res := ai_player.is_card_playable (card.unique_id)
			if string = {GT_CONSTANTS}.challenge_type_military then
				Result := card.military and res
			end
			if {GT_CONSTANTS}.challenge_type_intrigue = string then
				Result := card.intrigue and res
			end
			if {GT_CONSTANTS}.challenge_type_power = string  then
				Result := card.power and res
			end
		end

	biggest_opponent_card(opponent_cards : ARRAYED_LIST[GT_LOGIC_CARD]; challenge:STRING  ) : GT_LOGIC_CARD_CHARACTER
			-- selects the  opponent's card who has the biggest value for a said challenge
		local
			momentary_the_best_card:GT_LOGIC_CARD_CHARACTER
			auxiliar_card:GT_LOGIC_CARD
			momentary_the_greater_value : INTEGER_32
			i : INTEGER
		do
			from i := 0
			until i =  opponent_cards.count
			loop
					auxiliar_card := opponent_cards.array_at (i)
					if attached {GT_LOGIC_CARD_CHARACTER} auxiliar_card as character then
						if character.strength > momentary_the_greater_value and can_participate(character, challenge) then
							-- ask if the current card has a bigger streng than the one who has been choosen before
							momentary_the_greater_value := character.strength
							momentary_the_best_card := character
						end
					end
					i := i + 1
				 end
			Result := momentary_the_best_card
		end

feature -- Implementation (choose_challenge)

	less (list_challenge: ARRAYED_LIST [TUPLE[s: STRING; v: INTEGER]]): TUPLE[s: STRING; v: INTEGER]
		local
			i: INTEGER
			tuple: TUPLE[s: STRING; v: INTEGER]
		do
			create tuple.default_create
			tuple.put ({INTEGER}.max_value, 2)
			tuple.put ("no challenge", 1)
			from
				i := 0
			until
				i >= list_challenge.count
			loop
	           if list_challenge.array_item (i).v < tuple.v then
	           	tuple := list_challenge.array_item (i)
	           end
	           i := i + 1
			end
			Result := tuple
		end -- End less

feature -- Implementation (choose_defense)

	cards_to_play(power_op: INTEGER ; cards: ARRAYED_LIST[GT_LOGIC_CARD]): ARRAYED_LIST[GT_LOGIC_CARD]
			-- Given a array of the cards, the power of oponent and the actual phase, returns the minimal convination of the cards
			-- with more power that power_op
		require
			-- The cards of "cards" should be visible
			correct_power: power_op >= 0
			not_void_card: not (cards = Void)
		local
			cards_filtered, perm_cards:  ARRAYED_LIST[ARRAYED_LIST[GT_LOGIC_CARD]]
		do
			perm_cards := permutation(cards_playable(cards))
			cards_filtered := filter(perm_cards, power_op)
			Result := choose_minimal(cards_filtered)
		end

	permutation(cards: ARRAYED_LIST[GT_LOGIC_CARD]): ARRAYED_LIST[ARRAYED_LIST[GT_LOGIC_CARD]]
			-- takes a list of cards and returns all permutations of the same
			--perm :: [Int] -> [[Int]]
			--perm [] = []
			--perm [x] = [[x]]
			--perm (x:xs) = [x] : ins x (perm xs) ++ perm xs

			--ins :: Int -> [[Int]] -> [[Int]]
			--ins x [] = []
			--ins x (y:ys) = (x:y): (ins x ys)
		require
			cards /= Void
		local
			i: INTEGER
			res: ARRAYED_LIST[ARRAYED_LIST[GT_LOGIC_CARD]]
			first: ARRAYED_LIST[GT_LOGIC_CARD]
			perm_two, perm_one: ARRAYED_LIST[ARRAYED_LIST[GT_LOGIC_CARD]]
		do
			create res.make (0)
			if cards.count = 0 then
				Result := res
			elseif cards.count = 1 then
				res.extend (cards)
				Result := res
			else
				create first.make (0)
				first.extend (cards.array_item (i))
				res.extend (first)
				cards.remove
				perm_one := permutation(cards)
				res.fill (perm_one)

				from
					i := 0
				until
					i >= perm_two.count
				loop
					perm_two.array_item(i).extend (first.array_item (0))
					i := i + 1
				end

				res.fill (perm_two)
				Result := res
			end
		end

	cards_playable(cards: ARRAYED_LIST[GT_LOGIC_CARD]): ARRAYED_LIST[GT_LOGIC_CARD]
			-- Given a phase and an array of cards, returns the cards are playable in phase
		require
			not_void_card: not (cards = Void)
		local
			i: INTEGER
			playable: ARRAYED_LIST[GT_LOGIC_CARD]
		do
			create playable.make (0)
			from
				i := 0
			until
				i >= cards.count
			loop
				if ai_player.is_card_playable (cards.array_item (i).unique_id) then
					playable.extend (cards.array_item (i))
				end
				i := i + 1
			end
			Result := playable
		end

	filter(perm_cards: ARRAYED_LIST[ARRAYED_LIST[GT_LOGIC_CARD]]; power_op: INTEGER): ARRAYED_LIST[ARRAYED_LIST[GT_LOGIC_CARD]]
			-- Given a array of the array of the cards, returns the arrays with most power that power_op
		require
			correct_power: power_op >= 0
			not_void_card: not (perm_cards = Void)
		local
			i: INTEGER
			filtered: ARRAYED_LIST[ARRAYED_LIST[GT_LOGIC_CARD]]
		do
			create filtered.make (0)
			from
				i := 0
			until
				i >= perm_cards.count
			loop
				if power_op >= power_cards(perm_cards.array_item (i)) then
					filtered.extend (perm_cards.array_item (i))
				end
				i := i + 1
			end
			Result := Filtered
		end

	choose_minimal(cards_filtered: ARRAYED_LIST[ARRAYED_LIST[GT_LOGIC_CARD]]): ARRAYED_LIST[GT_LOGIC_CARD]
			-- Given a array of the array of the cards, returns the array with lowest power.
		require
			cards_filtered /= Void
		local
			i, minimal_value, power: INTEGER
			min: ARRAYED_LIST[GT_LOGIC_CARD]
		do
			create min.make (20)
			minimal_value := {INTEGER}.max_value
			from
				i := 0
			until
				i >= cards_filtered.count
			loop
				power := power_cards(cards_filtered.array_item (i))
				if minimal_value >= power then
					min := cards_filtered.array_item (i)
					minimal_value := power
				end
				i := i + 1
			end
			Result := min
		end

	power_cards(cards_filtered: ARRAYED_LIST[GT_LOGIC_CARD]) : INTEGER
		require
			cards_filtered /= Void
		local
			i, power: INTEGER
		do
			power := 0
			from
				i := 0
			until
				i >= cards_filtered.count
			loop
				if attached {GT_LOGIC_CARD_CHARACTER} cards_filtered.array_item (i) as card then
					power := power + card.strength
				end
				i := i + 1
			end
			Result := power
		end

feature -- Implementation (choose_plot_card)

	choose_best_plot_card(type: STRING): GT_LOGIC_CARD_PLOT
		local
			card: GT_LOGIC_CARD_PLOT
			i: INTEGER
		do
			card := ai_player.get_cards_in_plot_deck.to_arrayed_list.array_item (0)
			from
				i := 1
			until
				i < ai_player.get_cards_in_plot_deck.size
			loop
				if type = "GOLD" then
					if card.income < ai_player.get_cards_in_plot_deck.to_arrayed_list.array_item (i).income then
						card := ai_player.get_cards_in_plot_deck.to_arrayed_list.array_item (i)
					end
				else
					if card.claim < ai_player.get_cards_in_plot_deck.to_arrayed_list.array_item (i).claim then
						card := ai_player.get_cards_in_plot_deck.to_arrayed_list.array_item (i)
					end
				end
				i := i + 1
			end
			Result := card
		end

feature -- Implementation (change_initial_card)

	all_card_types(deck: ARRAYED_LIST[GT_LOGIC_CARD]): INTEGER
		local
			i: INTEGER
			intrigue, military, power: BOOLEAN
			current_card: GT_LOGIC_CARD
		do
			from
				i := 0
			until
				i >= deck.count
			loop
				current_card :=  deck.array_item (i)
				if attached{GT_LOGIC_CARD_CHARACTER} current_card as card then
					if card.military then
						military := True
					end
					if card.power then
						power := True
					end
					if card.intrigue then
						intrigue := True
					end
				end
				i := i + 1
			end
			if military and power and intrigue then
				Result := 40  	-- If you have the three challenges
			elseif not military and power and intrigue then
				Result := 20  	-- If only have one
			elseif military and not power and intrigue then
				Result := 20  	-- If only have one
			elseif military and power and not intrigue then
				Result := 20  	-- If only have one
			else
				Result := 0  	-- If none
			end
		ensure
			Result <= 40 and Result >= 0
		end

	average_cost(deck: ARRAYED_LIST[GT_LOGIC_CARD]): INTEGER
		-- Cost percentage
		local
			avg_cost: REAL_64
			current_card: GT_LOGIC_CARD
			i, counter: INTEGER
		do
			counter := 0
			from
				i := 0
			until
				i >= deck.count
			loop
				current_card :=  deck.array_item (i)
				counter := counter + current_card.cost
				i := i + 1
			end
			avg_cost := counter / 7
			if avg_cost < 2.3 then
				Result := 15
			elseif avg_cost >= 2.3 and avg_cost < 2.6 then
				Result := 5
			else
				Result := 0
			end
		ensure
			Result <= 15 and Result >= 0
		end

	average_strength(deck: ARRAYED_LIST[GT_LOGIC_CARD]): INTEGER
		-- Percentage of force
		local
			avg_str: REAL_64
			current_card: GT_LOGIC_CARD
			i, counter: INTEGER
		do
			counter := 0
			from
				i := 0
			until
				i >= deck.count
			loop  -- Charter must be character
				current_card := deck.array_item (i)
				if attached{GT_LOGIC_CARD_CHARACTER} current_card as card then
					counter := counter + card.strength
				end
				i := i + 1
			end
			avg_str:= counter / 7
			if avg_str > 2.75 then
				Result := 20
			elseif avg_str <= 2.75 and avg_str > 2.60 then
			    Result := 10
			else
				Result := 0
			end
		ensure
			Result <= 20 and Result >= 0
		end

	amount_character_cards(deck: ARRAYED_LIST[GT_LOGIC_CARD]): INTEGER
		-- Number of character cards
		local
			current_card: GT_LOGIC_CARD
			i, counter: INTEGER
		do
			counter := 0
			from
				i := 0
			until
				i >= deck.count
			loop
				current_card := deck.array_item (i)
				if attached{GT_LOGIC_CARD_CHARACTER} current_card then
					counter := counter + 1
				end
				i := i + 1
			end
			if counter >= 4 then
				Result := 25
			else
				Result := 0
			end
		ensure
			Result <= 25 and Result >= 0
		end

feature -- Implementation (choose_card_to_recruit)

	current_hand(cards:ARRAYED_LIST[GT_LOGIC_CARD]; missing_card: ARRAYED_LIST[STRING]) : ARRAYED_LIST[GT_LOGIC_CARD]
		local
			i,j: INTEGER
			flag: BOOLEAN
			cards_add: ARRAYED_LIST[GT_LOGIC_CARD]
		do
			create cards_add.make (0)
			from
				i := 0
			until
				i >= cards.count
			loop
				flag := False
				from
					j := 0
				until
					j >= missing_card.count or flag
				loop
					if attached{GT_LOGIC_CARD_CHARACTER} cards.array_item (i) as card then
						if missing_card.array_item (j)= "military" then
							flag:= card.military
						elseif missing_card.array_item (j)= "intrigue" then
							flag:= card.intrigue
						elseif missing_card.array_item (j)= "power" then
							flag:= card.power
						end
					end
					j := j + 1
				end -- end loop
				if flag then
					cards_add.extend (cards.array_item (i))
				end
				i := i+1
			end
			Result := cards_add
		end -- end method current_hand


	missing_cards_types(cards: ARRAYED_LIST[GT_LOGIC_CARD]) : ARRAYED_LIST[STRING]
	local
		i: INTEGER
		military, power, intrigue: BOOLEAN
		list: ARRAYED_LIST[STRING]
		current_card: GT_LOGIC_CARD
	do
		create list.make (3)
		from
			i := 0
		until
			i >= cards.count
		loop
			current_card :=  cards.array_item (i)
			if attached{GT_LOGIC_CARD_CHARACTER} current_card as card then
				if card.military then
					military := True
				end
				if card.power then
					power := True
				end
				if card.intrigue then
					intrigue := True
				end
			end
				i := i + 1
		end -- end loop
		if not (military) then
			list.extend ("military")
		end
		if not (power) then
			list.extend ("power")
		end
		if not (intrigue) then
			list.extend ("intrigue")
		end
		Result:=list
	end


feature -- Implementation (choose_initial_card)

	insertion_sort (tuple: TUPLE[c: GT_LOGIC_CARD; v: INTEGER] ; array : ARRAYED_LIST[TUPLE[c: GT_LOGIC_CARD; v: INTEGER]])
			-- Card inserted in the orderly arrangement according to the value
		local
			i: INTEGER
			current_value, old_value: TUPLE[c: GT_LOGIC_CARD; v: INTEGER]
			done: BOOLEAN
		do
			if array.count > 0 then
				from
					i := 0
					old_value := tuple
				until
					not (array.count > i)
				loop
					if array.array_item (i).v < old_value.v  then
						current_value := array.array_item (i)
						array.array_put (old_value, i)
						old_value := current_value
					end

					i := i + 1
				end
				array.array_put (old_value, i)
			else
				array.put (tuple)
			end
		end

	valuation_character(card: GT_LOGIC_CARD_CHARACTER) : INTEGER
			-- Gives a rating to the parameter
		local
			count_challenges: INTEGER
		do
			count_challenges := 0
			if card.intrigue then
				count_challenges := count_challenges + 1
			end
			if card.military then
				count_challenges := count_challenges + 1
			end
			if card.power then
				count_challenges := count_challenges + 1
			end
			Result := card.strength // card.cost + count_challenges
		end

	valuation_location(card: GT_LOGIC_CARD_LOCATION) : INTEGER
			-- Gives a rating to the parameter
			-- Will take account only the cost and bonus iniciative and gold modifier
		local
			value: INTEGER
		do
			Result := card.initiative_bonus + card.gold_modifier - card.cost
		end
end
