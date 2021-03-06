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
						i >= ai_player.get_cards_in_hand.to_arrayed_list.count
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
						i >= ai_player.get_cards_in_hand.to_arrayed_list.count
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
			--cards_to_defence:=cards_to_play(power_op, visible_cards_ai, phase)
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
					i >= possible_cards.count
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
							i >= ai_player.get_cards_in_hand.to_arrayed_list.count
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
						card_cost := 7
					until
						card_cost < 0
					loop
						from
							i := 0
						until
							i >= ai_player.get_cards_in_hand.to_arrayed_list.count
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
			challenge: STRING
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
						end
						if character.intrigue and not intrigue_challenge_used then
							intrigue := intrigue + character.strength
						end
						if character.power and not power_challenge_used then
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
						end
						if character.intrigue and not intrigue_challenge_used then
							intrigue := intrigue - character.strength
						end
						if character.power and not power_challenge_used then
							power := power - character.strength
						end
					end
				end
				i := i + 1
			end -- loop
			create list_challenge.make(0)
			if military > 0 then
				list_challenge.extend ({GT_CONSTANTS}.challenge_type_military)
			end
			if intrigue > 0 then
				list_challenge.extend ({GT_CONSTANTS}.challenge_type_intrigue)
			end
			if power > 0 then
				list_challenge.extend ({GT_CONSTANTS}.challenge_type_power)
			end
			if list_challenge.count = 0 then
				Result := Void
			elseif list_challenge.count = 1 then
				Result := list_challenge.array_item (0)
			else
				Result := list_challenge.array_item (random_integer(list_challenge.count)- 1)
			end
		end -- End choose_challenge

feature {TEST_GT_AI_EASY}-- Implementation (choose_attack)

	filter_character_cards(cards_to_filter : ARRAYED_LIST[GT_LOGIC_CARD]; challenge: STRING):ARRAYED_LIST[GT_LOGIC_CARD_CHARACTER]
		  --Given an arrayed_list of cards returns another arrayed_list with only the characters cards of the first one
		require correct_challenge: 	challenge = {GT_CONSTANTS}.challenge_type_intrigue or
				challenge = {GT_CONSTANTS}.challenge_type_military or
				challenge = {GT_CONSTANTS}.challenge_type_power
		local
			i : INTEGER_32
			res : ARRAYED_LIST[GT_LOGIC_CARD_CHARACTER]
			auxiliar_card:GT_LOGIC_CARD
		do
			create res.make (0)
			from
				i := 0
			until
				i >= cards_to_filter.count
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

	can_participate(card:GT_LOGIC_CARD_CHARACTER; challenge: STRING):BOOLEAN
			-- returns if a card can participate in some challenge
		local
			res:BOOLEAN
		do
			res := ai_player.is_card_playable (card.unique_id)
			if challenge = {GT_CONSTANTS}.challenge_type_military then
				Result := card.military and res
			end
			if {GT_CONSTANTS}.challenge_type_intrigue = challenge then
				Result := card.intrigue and res
			end
			if {GT_CONSTANTS}.challenge_type_power = challenge  then
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
			i >= ai_player.get_cards_in_play.to_arrayed_list.count
		loop
			card := ai_player.get_cards_in_play.to_arrayed_list.array_item (i)
			if attached {GT_LOGIC_CARD_CHARACTER} card then
				count := count + 1
			end
			i := i + 1
		end
		Result := count
	end


	cards_to_defense(challengue:STRING; power_op: INTEGER ; cards: ARRAYED_LIST[GT_LOGIC_CARD]; phase: GT_LOGIC_PHASE_CHALLENGES): ARRAYED_LIST[GT_LOGIC_CARD]
		local
			play, playing_cards: ARRAYED_LIST[GT_LOGIC_CARD]
			i, power: INTEGER
			type_correct: BOOLEAN
			defense_card: GT_LOGIC_CARD
		do
			create playing_cards.make (0)
			from
				i := 0
			until
				i>= cards.count or power>=power_op
			loop
				if attached {GT_LOGIC_CARD_CHARACTER} cards.array_item(i) as card then
					if challengue = {GT_CONSTANTS}.challenge_type_military then
						type_correct := card.military
					end
					if challengue = {GT_CONSTANTS}.challenge_type_intrigue then
						type_correct := card.intrigue
					end
					if challengue = {GT_CONSTANTS}.challenge_type_power then
						type_correct := card.power
					end
				end
				if phase.is_card_playable_in_phase (cards.array_item (i).unique_id, ai_player) and type_correct then
					playing_cards.extend (cards.array_item (i))
					-- considers only the strength of the card
					if attached {GT_LOGIC_CARD_CHARACTER} cards.array_item (i) as current_card then
						power := power + current_card.strength
					end
				end
				i := i + 1
				type_correct := False
			end
			if playing_cards.count > 0 then
				if (power >= power_op) then
					Result := playing_cards
				else
					-- Play a small defense
					defense_card := cards.array_item (0)
					from
						i := 1
					until
						i >= playing_cards.count
					loop
						if attached {GT_LOGIC_CARD_CHARACTER} playing_cards.array_item(i) as card then
							if attached {GT_LOGIC_CARD_CHARACTER} defense_card as d_card then
								if d_card.strength > card.strength then
									defense_card := card
								end
							end
						end
						i := i + 1
					end
					create playing_cards.make (0)
					playing_cards.extend (defense_card)
					Result := playing_cards
				end
			else
				Result := Void
			end
		end

end --GT_AI_EASY
