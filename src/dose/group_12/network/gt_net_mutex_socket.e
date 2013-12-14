note
	description: "Summary description for {MUTEX_SOCKET}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GT_NET_MUTEX_SOCKET

	inherit
		MUTEX
		rename
			make as make_mutex
		end

		NETWORK_STREAM_SOCKET
		rename
			dispose as dispose_socket
		select
			dispose_socket
		end

		create
			make_from_descriptor_and_address, make_client, make_server

		feature
			make_client(a_server_address : INET_ADDRESS; a_server_port: INTEGER)
			do
				make_mutex
				make_client_by_address_and_port(a_server_address, a_server_port)
			end

			make_server(a_port : INTEGER)
			do
				make_mutex
				make_server_by_port(a_port)
			end

			initialize_mutex
			do
				make_mutex
			end

end
