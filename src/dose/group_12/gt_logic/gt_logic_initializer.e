note
	description: "[
					{GT_LOGIC_INITIALIZER}. This class functions as a bootstrapper for the logic component,
					 connecting the GUI with the logic and network by creating players depending on their gui selection.
					]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GT_LOGIC_INITIALIZER


feature -- Access
network_host : GT_NET_HOST

feature -- Commands

start_game_with_ai(player_one_house : STRING; easy_ai : BOOLEAN) : GT_LOGIC_BOARD
-- Start a game with the specified house, against an AI opponent.
require
	-- player_one_house := is_valid_house(player_one_house) -- TODO: Define overall is_valid_house method
local
	player_one : GT_LOGIC_PLAYER
	player_two_ai : GT_LOGIC_PLAYER

	board : GT_LOGIC_BOARD
	ai_house_card : STRING

	-- TODO : AI, cast instead?
	ai : GT_AI
	ai_easy : GT_AI_EASY
	ai_hard : GT_AI_HARD
do
	-- Choose the AI house card
	if (player_one_house = {GT_CONSTANTS}.HOUSE_STARK) then
		ai_house_card := {GT_CONSTANTS}.HOUSE_LANNISTER
	else
		ai_house_card := {GT_CONSTANTS}.HOUSE_STARK
	end

	-- Create AI and human players
	create player_one.make (TRUE, player_one_house, TRUE) -- Server

	create player_two_ai.make (FALSE, ai_house_card, FALSE) -- Client

	-- Create board
	create board.make (player_one, player_two_ai)

	-- creates the board and the ai.
	if easy_ai=true then
		create ai_easy.make(player_two_ai, board) --create the ai object
		player_two_ai.set_ai(ai_easy) --feeds the ai into the player object.
	else
		create ai_hard.make (player_two_ai, board)
		player_two_ai.set_ai(ai_hard)
	end

	-- give back the resulting board.
	result := board

ensure
	--board.get_current_phase.current_phase = "SETUP"
	result.get_player_one /= void
	result.get_player_two /= void
end

start_game_as_server(player_one_house : STRING) : GT_LOGIC_BOARD
-- Start a game with the specified house as a server.
require
	-- player_one_house = is_valid_house(player_one_house)
local
	player_one : GT_LOGIC_PLAYER
	player_two_network : GT_LOGIC_PLAYER
	player_two_house : STRING
	board : GT_LOGIC_BOARD
do
	create player_one.make (TRUE, player_one_house, TRUE) -- human, house, is server = true.

	if (player_one_house = {GT_CONSTANTS}.HOUSE_STARK) then
		player_two_house := {GT_CONSTANTS}.HOUSE_LANNISTER
	else
		player_two_house := {GT_CONSTANTS}.HOUSE_STARK
	end

	create player_two_network.make (TRUE, player_two_house, FALSE) --create the nw-player

	--wait for client to connect and choose house, so we can make his deck and send it back.

	-- override player two deck and do synchronization
	-- Right now we simply just give the other player the other deck, avoiding need for synch.

	-- create the board.
	create board.make(player_one, player_two_network)
	network_host := create {GT_NET_SERVER}.make_server({GT_CONSTANTS}.STANDARD_PORT)
	player_one.set_network_component (network_host)
	network_host.connect
	network_host.launch_listener (board)
	-- network_host.send (create {GT_NET_CHAT_COMMAND}.make_chat_command ("Server established."))


	result := board

ensure
end

start_game_as_client(address : INET_ADDRESS) : GT_LOGIC_BOARD
-- Start a game with the specified house as a client.
require
local
	player_one : GT_LOGIC_PLAYER
	player_two_network : GT_LOGIC_PLAYER
	player_two_house : STRING
	board : GT_LOGIC_BOARD
do
	create player_one.make (TRUE, {GT_CONSTANTS}.HOUSE_LANNISTER, FALSE) --create the local player.

	player_two_house := {GT_CONSTANTS}.HOUSE_STARK
	create player_two_network.make (TRUE, player_two_house, TRUE) --will be overwritten. with new deck later.

	--wait for client to connect, so we can recieve his deck and syncronize.
	create board.make(player_one, player_two_network)
	network_host := create {GT_NET_CLIENT}.make_client(address, {GT_CONSTANTS}.STANDARD_PORT)
	player_one.set_network_component (network_host)
	network_host.connect
	network_host.launch_listener (board)
	network_host.send (create {GT_NET_CHAT_COMMAND}.make_chat_command ("Client joined"))
	result := board
ensure
end

feature {NONE} -- Implementation

invariant
	invariant_clause: True -- Your invariant here

end
