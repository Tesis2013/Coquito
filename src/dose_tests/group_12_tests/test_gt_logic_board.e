note
	description: "Summary description for {TEST_GT_LOGIC_BOARD}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TEST_GT_LOGIC_BOARD

	inherit
		EQA_TEST_SET
		redefine
			on_prepare
		end

	feature {NONE}
		testboard: GT_LOGIC_BOARD
		testplayer_1: GT_LOGIC_PLAYER
		testplayer_2: GT_LOGIC_PLAYER

	feature
		on_prepare
		local
			house_1 : STRING
			house_2 : STRING
		do
			house_1 := "LANNISTER"
			house_2 := "STARK"
			create testplayer_1.make(TRUE, house_1, TRUE)
			create testplayer_2.make(TRUE, house_2, FALSE)
			create testboard.make(testplayer_1, testplayer_2)
		end

	feature
		test_add_gold_dragon
		note
			testing : "covers/{GT_LOGIC_BOARD}.give_gold_dragon_token"
		local
			start_gold : INTEGER
		do
			start_gold := testplayer_1.gold_dragon_tokens
			testboard.give_gold_dragon_token (1, 1)
			assert("Player_1's amount of gold tokens: ", testplayer_1.gold_dragon_tokens = start_gold + 1)
		end

		test_add_power_token
		note
			testing : "covers/{GT_LOGIC_BOARD}.give_power_token"
		local
			start_tokens : INTEGER
		do
			start_tokens := testplayer_1.power_tokens
			testboard.give_power_token (1, 1)
			assert("Player_1's amount of power tokens: ", testplayer_1.power_tokens = start_tokens + 1)
		end

--		test_load_cards -- wrote by Marco, ITU14
--		note
--			testing : "covers/{GT_LOGIC_BOARD}.load_cards"
--		do
--			testboard.load_cards ("STARK")
--			assert("Deck for the Stark house: ", testboard.load_cards ("STARK") /= Void)
--		end
end
