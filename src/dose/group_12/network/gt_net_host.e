note
	description: "This class represents the network hosts and is the entry-point for all network interaction."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	GT_NET_HOST

	feature {NONE}

		socket: GT_NET_MUTEX_SOCKET

	feature

		connect
		require
			socket_not_void: socket /= Void
		deferred
		ensure
			ready_to_read : socket.is_open_read
			ready_to_write : socket.is_open_write
		end

		disconnect
		require
			socket_not_void : socket /= Void
		local
			command : GT_NET_DISCONNECT_COMMAND
		do
			create command
			send(command)
		ensure
			socket_closed: socket.is_closed
			disconnected: not socket.is_connected
		end

		send(command: GT_NET_COMMAND)
		require
			open_for_write : socket.is_open_write
		do
			print("sending: " + command.out + "%N")
			socket.lock
			command.independent_store(socket)
			socket.unlock
		end

		launch_listener(a_board : GT_LOGIC_BOARD)
		require
			a_board /= Void
		local
			listener: GT_NET_CONNECTION_LISTENER
			chat_listener : GT_NET_CHAT_INPUT_LISTENER
		do
			create listener.make_listener(socket, a_board)
			create chat_listener.make_chat_listener (socket)
			listener.launch
			chat_listener.launch
		end

end
