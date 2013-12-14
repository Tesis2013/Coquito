note
	description: "Test class for {TEST_GT_AI_HARD}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TEST_GT_AI_HARD

inherit
	EQA_TEST_SET
	rename
		default_create as gt_test_default_create
	redefine
		on_prepare
		select gt_test_default_create
	end



	GT_LOGIC_BOARD
		rename
			default_create as gt_board_default_create,
			make as gt_board_make
		end
	GT_AI_HARD
		rename
			default_create as gt_ai_easy_default_create,
			make as gt_ai_easy_make
		end

-- This class is not popualted yet, but it is going to be a mirror of the AI_EASY test.
feature
	on_prepare
	do

	end

end
