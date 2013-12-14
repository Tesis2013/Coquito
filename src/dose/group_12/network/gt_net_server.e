note
	description: "Summary description for {GT_NET_SERVER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GT_NET_SERVER

	inherit GT_NET_HOST
	rename
		socket as client_socket
	redefine
		connect
	end

	create
		make_server

	feature --initialization

	make_server(a_port: INTEGER_16)
	require
		valid_port: a_port >= 2000
	do
		create listen_socket.make_server(a_port)
		client_socket := listen_socket
	end

	feature

	connect
	do
		listen_socket.listen (1)
		listen_socket.accept
		if attached {GT_NET_MUTEX_SOCKET} listen_socket.accepted as l_soc2 then
			l_soc2.initialize_mutex
            client_socket := l_soc2
        end
	end

	feature {NONE}

	listen_socket : GT_NET_MUTEX_SOCKET

end
