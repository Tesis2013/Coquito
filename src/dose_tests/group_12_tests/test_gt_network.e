note
	description: "Summary description for {TEST_GT_NETWORK}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TEST_GT_NETWORK
inherit
	EQA_TEST_SET
	redefine
		on_prepare
	end

inherit {NONE}
	GT_NET_HOST
	rename
		default_create as gt_default_create

	redefine
		connect
	end


feature {none}
	--GT_CLIENT
	nw_client : GT_NET_CLIENT
	address : INET4_ADDRESS
	hostname : STRING_8
	address_as_array : ARRAY[NATURAL_8]
	--GT_SERVER
	nw_server : GT_NET_SERVER
	port_no : INTEGER_16
	--GT_HOST
	nw_host : GT_NET_HOST


feature
	on_prepare
		do
			--creates the gt_client variables
			hostname := "abcdefgh"
			address_as_array.make_filled(1,1,4)
			create address.make_from_host_and_address (hostname, address_as_array)

			--creates the gt_server variables
			port_no := 8080
			--creates the gt_host
			--TODO nw_host is deferred.

		end

	test_set_nw_client
		note
			testing: "covers/{GT_CLIENT}.make_client"
			testing: "GT/GT_CLIENT"
		do
			create nw_client.make_client(address, 12)
			assert("The client could not be set", FALSE)
			--check variables when they are set. maybe inherit gt_client instead of host
		end

	test_set_nw_server
		note
			testing: "covers/{GT_SERVER}.make_server"
			testing: "GT/GT_SERVER"
		do
			create nw_server.make_server(port_no)
			assert("The server could not be set", FALSE)
			--check variables when they are set. maybe inherit gt_client instead of host
		end
	connect
		do

		end
end
