note
	description	: "AI level Easy"
	author		: "RioCuarto2"
	date		: "04/12/2013"
	revision	: ""

class
	GT_AI_EASY

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
			ai_player:=player
			ai_board:=board
		end

feature -- Implementation

	change_initial_card: BOOLEAN
			-- Decides whether to change the 7 initial cards for others 7
		do
			Result := random_integer(2) = 1
		end

	choose_plot_card : GT_LOGIC_CARD_PLOT
			-- Choose the plot card
		local
			number: INTEGER
		do
			number:= random_integer(ai_player.get_cards_in_plot_deck.size)-1
			Result:= ai_player.get_cards_in_plot_deck.playable_plot_cards.array_item (number)
		end


	choose_initial_cards
			-- Choose initial cards in setup phase
		local
			option, i, card_cost, not_character: INTEGER
			card: GT_LOGIC_CARD
		do
			option := random_integer(3)
			not_character := 2
			if option = 1 then -- choose the most cheapest cards
				from
					card_cost := 0
				until
					(card_cost > ai_player.gold_dragon_tokens) or (card_cost > 5)
				loop
					from
						i := 0
					until
						i = ai_player.get_cards_in_hand.size
					loop
						card := ai_player.get_cards_in_hand.to_arrayed_list.array_item (i)
						if card.cost = card_cost and ai_player.is_card_playable (card.unique_id) then
							if attached {GT_LOGIC_CARD_CHARACTER} card then
								ai_player.play (card.unique_id)
							elseif not attached {GT_LOGIC_CARD_CHARACTER} card and not_character > 0 then
								ai_player.play (card.unique_id)
								not_character := not_character - 1
							end
						end
						i := i + 1
					end
					card_cost := card_cost + 1
				end
			elseif option = 2 then -- choose the most expensive cards
				from
					card_cost := 5
				until
					card_cost < 0
				loop
					from
						i := 0
					until
						i = ai_player.get_cards_in_hand.size
					loop
						card := ai_player.get_cards_in_hand.to_arrayed_list.array_item (i)
						if card.cost = card_cost and ai_player.is_card_playable (card.unique_id) then
							if attached {GT_LOGIC_CARD_CHARACTER} card then
								ai_player.play (card.unique_id)
							elseif not attached {GT_LOGIC_CARD_CHARACTER} card and not_character > 0 then
								ai_player.play (card.unique_id)
								not_character := not_character - 1
							end
						end
						i := i + 1
					end
					card_cost := card_cost - 1
				end
			elseif option = 3 then -- choose cards by random
				from
					i := ai_player.get_cards_in_hand.to_arrayed_list.count-1
				until
					i < 0
				loop
					card := ai_player.get_cards_in_hand.to_arrayed_list.array_item (i)
					if card.cost <= ai_player.gold_dragon_tokens and ai_player.is_card_playable (card.unique_id) then
						if attached {GT_LOGIC_CARD_CHARACTER} card then
							ai_player.play (card.unique_id)
						elseif not attached {GT_LOGIC_CARD_CHARACTER} card and not_character > 0 then
							ai_player.play (card.unique_id)
							not_character := not_character - 1
						end
					end
					i := i - 1
				end
			end
		end

	choose_cede_initiative
			-- choosing to give initiative to form random
		do
			if random_integer(2) = 1 and ai_player.is_player_turn then
				-- method cede initiative
			end
		end

	choose_cards_to_kill
		-- choose that cards kill
		-- choose the cart with lower cost
		local
			cost_lower, position_cost_lower, i: INTEGER
		do
			cost_lower := 10
			position_cost_lower := -1
			from
				i := 0
			until
				i >= ai_player.get_cards_in_play_as_arrayed_list.count
			loop
				if cost_lower >= ai_player.get_cards_in_play_as_arrayed_list.array_item (i).cost then
					cost_lower := ai_player.get_cards_in_play_as_arrayed_list.array_item (i).cost
					position_cost_lower := i
				end
				i := i + 1
			end
			ai_board.kill_character (ai_player.player_id, ai_player.get_cards_in_play_as_arrayed_list.array_item (position_cost_lower).unique_id)
			-- kill the card at position "position_cost_lower"
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
			-- Choose cards to defend
			cards_to_defence:=cards_to_play(power_op, visible_cards_ai, phase)
			from
				i:=0
			until
				i>= cards_to_defence.count
			loop
				-- Put into play the chosen cards
	 			ai_player.choose_defender (cards_to_defence.array_item (i).unique_id)
				i := i + 1
			end
		end

	choose_attack (challenge: STRING)
			-- Choose attack cards
		local
			possible_cards: ARRAYED_LIST [GT_LOGIC_CARD_CHARACTER]
			i: INTEGER
		do
			possible_cards := filter_character_cards(ai_player.get_cards_in_play_as_arrayed_list, challenge)
			if possible_cards.count = 1 then
				ai_player.choose_attacker (possible_cards.array_item (0).unique_id)
			else
				from
					i := 0
				until
					i >= possible_cards.count - 1
				loop
					ai_player.choose_attacker (possible_cards.array_item (i).unique_id)
					i := i + 1
				end
			end
		end

	choose_cards_to_recruit
			-- Choose cards to recruit in Marshalling Phase
		local
			option, i, card_cost, not_character: INTEGER
			card: GT_LOGIC_CARD
		do
			option := random_integer(3)
			not_character := 4
			if option = 1 then -- choose the most cheapest cards
					from
						card_cost := 0
					until
						(card_cost > ai_player.gold_dragon_tokens)
					loop
						from
							i := 0
						until
							i = ai_player.get_cards_in_hand.size
						loop
							card := ai_player.get_cards_in_hand.to_arrayed_list.array_item (i)
							if card.cost = card_cost and ai_player.is_card_playable (card.unique_id) then
								if attached {GT_LOGIC_CARD_CHARACTER} card then
									ai_player.play (card.unique_id)
								elseif not attached {GT_LOGIC_CARD_CHARACTER} card and count_not_character_in_play < 4 and not_character > 0 then
									ai_player.play (card.unique_id)
									not_character := not_character - 1
								end
							end
							i := i + 1
						end --end loop (internal)
						card_cost := card_cost + 1
					end --end loop (external)

			elseif option = 2 then -- choose the most expensive cards
					from
						card_cost := 5
					until
						card_cost < 0
					loop
						from
							i := 0
						until
							i = ai_player.get_cards_in_hand.size
						loop
							card := ai_player.get_cards_in_hand.to_arrayed_list.array_item (i)
							if card.cost = card_cost and ai_player.is_card_playable (card.unique_id) then
								if attached {GT_LOGIC_CARD_CHARACTER} card then
									ai_player.play (card.unique_id)
								elseif not attached {GT_LOGIC_CARD_CHARACTER} card and count_not_character_in_play<4 and  not_character > 0 then
									ai_player.play (card.unique_id)
									not_character := not_character - 1
								end
							end
							i := i + 1
						end -- end loop (internal)
						card_cost := card_cost - 1
					end -- end loop (external)
					elseif option = 3 then -- choose cards by random
						from
							i := ai_player.get_cards_in_hand.to_arrayed_list.count-1
						until
							i < 0
						loop
							card := ai_player.get_cards_in_hand.to_arrayed_list.array_item (i)
							if card.cost <= ai_player.gold_dragon_tokens and ai_player.is_card_playable (card.unique_id) then
								if attached {GT_LOGIC_CARD_CHARACTER} card then
									ai_player.play (card.unique_id)
								elseif not attached {GT_LOGIC_CARD_CHARACTER} card and count_not_character_in_play<4 and not_character > 0 then
										ai_player.play (card.unique_id)
										not_character := not_character - 1
								end
							end
							i := i - 1
						end -- end loop
				end
	end -- end do

	choose_challenge: STRING
		local
			i: INTEGER
			military, intrigue, power: INTEGER
			list_challenge: ARRAYED_LIST[STRING]
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
			create list_challenge.make(0)
			if military > 0 then
				list_challenge.extend ("military")
			end
			if intrigue > 0 then
				list_challenge.extend ("intrigue")
			end
			if power > 0 then
				list_challenge.extend ("power")
			end
			if list_challenge.count = 0 then
				Result := "no challenge"
			else
				Result := list_challenge.array_item (random_integer(list_challenge.count-1))
			end
		end -- End choose_challenge

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


feature {NONE}-- Implementations

	count_not_character_in_play: INTEGER
	local
		count,i:INTEGER
		card: GT_LOGIC_CARD
	do
		from
			i:=0
		until
			i=ai_player.get_cards_in_play.size
		loop
			card:=ai_player.get_cards_in_play.to_arrayed_list.array_item (i)
			if attached {GT_LOGIC_CARD_CHARACTER} card then
				count:= count + 1
			end
			i:=i+1
		end
		Result:=count
	end


	cards_to_play(power_op: INTEGER ; cards: ARRAYED_LIST[GT_LOGIC_CARD]; phase: GT_LOGIC_PHASE_CHALLENGES): ARRAYED_LIST[GT_LOGIC_CARD]

	require
		-- The cards of "cards" should be visible
	local
		play, playing_cards: ARRAYED_LIST[GT_LOGIC_CARD]
		i, power: INTEGER
	do
		create playing_cards.make (cards.count)

		from
			i := 0
		until
			i>= cards.count and power>=power_op
		loop
			if phase.is_card_playable_in_phase (cards.array_item (i).unique_id, ai_player)then
				playing_cards.array_put (cards.array_item (i), i)
				-- considers only the strength of the card
				if attached {GT_LOGIC_CARD_CHARACTER} cards.array_item (i) as current_card then
					power := power + current_card.strength
				end
			end
			i := i + 1
		end
		if (power >= power_op) then
			Result := playing_cards
		end
	end

end --GT_AI_EASY
