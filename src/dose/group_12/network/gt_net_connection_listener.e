note
	description: "Listens for incoming messages on connection."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GT_NET_CONNECTION_LISTENER

	inherit

		THREAD
		rename
			make as make_thread
		redefine
			execute
		end

    create
    	make_listener

	feature --initialization
		make_listener(a_socket : GT_NET_MUTEX_SOCKET; a_board : GT_LOGIC_BOARD)
		do
			make_thread
			socket := a_socket
			board := a_board
		end

	feature --threading functionality

		execute --loop and poll the medium
		do
			io.put_string("Listening!%N")
			from
				running := true
			until
				not running
			loop
				socket.lock
				if socket.is_readable then
	            	if attached {GT_NET_COMMAND} socket.retrieved as command then
	            		socket.unlock
	            		dispatch(command)
	            	else
	            		print("message type unknown%N")
	            	end
	            else
           			socket.unlock
            	end
				sleep(80000)
			end
		rescue
			print("something went terribly wrong, sorry%N")
		end

	feature --message dispatching

	dispatch(a_command : GT_NET_COMMAND)
	local
		disconnect_confirmation : GT_NET_CONFIRM_DISCONNECT_COMMAND
	do
		print("Received command: " + a_command.out + "%N")

		if attached {GT_NET_CHOOSE_CHALLENGE_COMMAND} a_command as challenge_command then
			board.lock
			board.get_player_two.choose_challenge_type (challenge_command.challenge_type)
			board.unlock
		elseif attached {GT_NET_END_TURN_COMMAND} a_command then
			board.lock
			board.get_player_two.end_turn
			board.unlock
		elseif attached {GT_NET_END_ACTION_COMMAND} a_command then
			board.lock
			board.get_player_two.end_action
			board.unlock
		elseif attached {GT_NET_HOUSE_COMMAND} a_command as house_command then
			board.lock
			--TODO
			board.unlock
		elseif attached {GT_NET_DISCONNECT_COMMAND} a_command then
			--TODO for LOGIC: What should happen when other player disconnects?
			create disconnect_confirmation
			socket.lock
			disconnect_confirmation.independent_store(socket)
			socket.unlock
			running := False
		elseif attached {GT_NET_CONFIRM_DISCONNECT_COMMAND} a_command then
			socket.lock
			socket.close
			socket.unlock
			running := False
		elseif attached {GT_NET_DRAW_COMMAND} a_command as draw_command then
			board.lock
			board.get_player_two.draw (draw_command.number_of_cards_to_draw)
			board.unlock
		elseif attached {GT_NET_PLAY_COMMAND} a_command as play_command then
			board.lock
			if not play_command.has_extra_card_number then
				board.get_player_two.play (play_command.card_number)
			else
				board.get_player_two.play_attachment (play_command.extra_card_number, play_command.card_number)
			end
			board.unlock
		elseif attached {GT_NET_SYNCHRONIZE_COMMAND} a_command as sync_command then
			board.lock
			board.get_player_two.synchronize (sync_command.deck)
			board.unlock
		elseif attached {GT_NET_CHOOSE_ATTACKER_COMMAND} a_command as attacker_command then
			board.lock
			board.get_player_two.choose_attacker (attacker_command.card_id)
			board.unlock
		elseif attached {GT_NET_CHOOSE_DEFENDER_COMMAND} a_command as defender_command then
			board.lock
			board.get_player_two.choose_defender (defender_command.card_id)
			board.unlock
		elseif attached {GT_NET_KILL_CHARACTERS_COMMAND} a_command as kill_chars_command then
			board.lock
			board.kill_character (2, kill_chars_command.nr_characters_to_kill)
			board.unlock
		elseif attached {GT_NET_DISCARD_CARDS_COMMAND} a_command as discard_cards_command then
			board.lock
			board.discard_cards (2, discard_cards_command.nr_cards_to_discard)
			board.unlock
		elseif attached {GT_NET_STEAL_POWER_COMMAND} a_command as steal_power_command then
			board.lock
			board.steal_power_tokens (2, 1, steal_power_command.nr_tokens_to_steal)
			board.unlock
		elseif attached {GT_NET_SET_STARTING_PLAYER_COMMAND} a_command as starting_player_command then
			board.lock
			board.get_player_from_id (starting_player_command.starting_player_id).set_is_player_turn (true)
			board.get_player_from_id (3-starting_player_command.starting_player_id).set_is_player_turn (false)
			board.unlock
		elseif attached {GT_NET_CHAT_COMMAND} a_command as chat_command then
			print("Player 2: " + chat_command.message + "%N")
		else
			print("Message type unknown%N")
		end
	end

	feature {NONE} --attributes

		socket : GT_NET_MUTEX_SOCKET
		board  : GT_LOGIC_BOARD
		running : BOOLEAN
end
