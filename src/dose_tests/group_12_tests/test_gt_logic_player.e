note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	TEST_GT_LOGIC_PLAYER

inherit
	EQA_TEST_SET
	redefine
		on_prepare,
		on_clean
	end

feature {NONE} -- Events

	on_prepare
		do
			-- This routine is called before executing any test.
			-- You can use it, e.g. to prepare (i.e. create and set values to) objects
			-- that all your tests will need.
			-- We don't use it in this particualr class. but it's here so you learn about its existence.
		end

	on_clean
		do
			-- Similar to "on_prepare", this routine is automatically called after
			-- all tests have been executed. You can use it, for example, if you need
			-- to free resources etc. that your test were using.
		end

feature -- Test routines

	test_gt_logic_player_visible_cards_in_play
			-- New test routine
		note
			testing:  "covers/{GT_LOGIC_PLAYER}.visible_cards_in_play"
			testing: "user/GT" -- this is tag with the class-prefix
		local
			logic_player: GT_LOGIC_PLAYER
			house_deck : STRING
				-- a local variable for the board model
		do
			house_deck := "LANNISTER"
			create logic_player.make(TRUE, house_deck, TRUE)
			-- there are no visible cards at this point
			assert ("There are no visible cards:", logic_player.get_visible_cards_in_play.size = 0)

		end


	test_gt_logic_player_visible_cards_in_piles
			-- New test routine
		note
			testing: "covers/{GT_LOGIC_PLAYER}.visible_cards_in_play"
			testing: "user/GT" -- this is tag with the class-prefix
		local
			logic_player: GT_LOGIC_PLAYER
			house_deck : STRING
				-- a local variable for the board model
		do
			house_deck := "STARK"
			create logic_player.make(TRUE, house_deck, TRUE)
			-- there are no visible cards at this point
			-- need to be able to move some visible cards to be able to test this

		end

end


