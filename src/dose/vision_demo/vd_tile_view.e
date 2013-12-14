note
	description: "An object that represents an Ingenious tile, which is made of two hexes."
	author: "Emanuele Rudel"
	date: "$Date$"
	revision: "$Revision$"

class
	VD_TILE_VIEW

inherit
	EV_MODEL_MOVE_HANDLE

create
	make_with_hexes

feature {NONE} -- Implementation

	make_with_hexes (a_first_hex, a_second_hex: EV_PIXMAP)
		local
			l_hex: EV_MODEL_PICTURE
		do
			default_create
			create l_hex.make_with_pixmap (a_first_hex)
			extend (l_hex)
			l_hex.set_point_position (0, 0)
			create l_hex.make_with_pixmap (a_second_hex)
			extend (l_hex)
			l_hex.set_point_position (0, 27)
			enable_move
			enable_events_sended_to_group
		end

feature -- Status setting

	enable_move
		do
			pointer_motion_actions.extend (agent on_pointer_motion_on_world)
			pointer_button_press_actions.extend (agent on_pointer_button_press_on_world)
			pointer_button_release_actions.extend (agent on_pointer_button_release_on_world)
		end

feature {NONE} -- Move features

	on_pointer_motion_on_world (ax, ay: INTEGER; x_tilt, y_tilt, pressure: DOUBLE; a_screen_x, a_screen_y: INTEGER)
		do
			if has_capture then
				print ("Dragged tile view: (" + ax.out + "," + ay.out +")%N")
				set_point_position (ax, ay)
			end
		end

	on_pointer_button_press_on_world (ax, ay, button: INTEGER; x_tilt, y_tilt, pressure: DOUBLE; a_screen_x, a_screen_y: INTEGER)
		do
			enable_capture
		end

	on_pointer_button_release_on_world (ax, ay, button: INTEGER; x_tilt, y_tilt, pressure: DOUBLE; a_screen_x, a_screen_y: INTEGER)
		do
			if has_capture then
				disable_capture
			end
		end

end
