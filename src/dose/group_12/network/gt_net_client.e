note
	description: "Summary description for {GT_NET_CLIENT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GT_NET_CLIENT

	inherit
		GT_NET_HOST
		redefine connect
		end

	create
		make_client

	feature

		make_client(a_server_address: INET_ADDRESS; a_server_port: INTEGER_16)
		require
			valid_address: a_server_address /= Void
			valid_port: a_server_port >= 2000
		do
			create socket.make_client(a_server_address, a_server_port)
		end

	feature

		connect
		do
			socket.connect
		end

end
