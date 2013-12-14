note
	description: "This class represents the commands that will be interchanged between the players of a GOT-cardgame"
	author: "Group 12"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	GT_NET_COMMAND -- has an ID. All necessary data field must be specified in the subclasses.

	inherit
		ANY
		undefine
			out
		end

		STORABLE
		undefine
			out
		end

feature --attributes

	command_id : STRING --To be able to identify the dynamic type of the command after receiving
	deferred			--it over the network
	end

feature

	out : STRING
	deferred
	end

end
