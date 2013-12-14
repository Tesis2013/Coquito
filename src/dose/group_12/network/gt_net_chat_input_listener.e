note
	description: "Summary description for {GT_NET_CHAT_INPUT_LISTENER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GT_NET_CHAT_INPUT_LISTENER

	inherit
		THREAD
		rename make as make_thread
		end

	create make_chat_listener

	feature
		make_chat_listener(a_socket : GT_NET_MUTEX_SOCKET)
		do
			make_thread
			socket := a_socket
		end

		execute
		local
			chat_command : GT_NET_CHAT_COMMAND
		do
			print("Write your chat messages here:%N")
			from
			until
				False
			loop
				io.read_line
				chat_command := create {GT_NET_CHAT_COMMAND}.make_chat_command (io.last_string)
				socket.lock
				chat_command.independent_store (socket)
				socket.unlock
			end
		end

	feature {NONE}
		socket : GT_NET_MUTEX_SOCKET

end
