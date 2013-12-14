note
	description	: "Constants for the Eiffel Vision demo."
	author		: "haches"
	date		: "$Date$"
	revision	: "$Revision$"

class
	VD_CONSTANTS

inherit
    KL_SHARED_FILE_SYSTEM
    		-- use KL_SHARED_FILE_SYSTEM to make file paths OS independent
        export {NONE}
            all
        end

feature -- Access

	Dose_folder: STRING = "dose"
	Image_folder: STRING = "images"
	vd_folder: STRING = "vision_demo"

	vd_img_path: KL_PATHNAME
			-- Path for image folder of main_ui
		do
			create Result.make
			Result.set_relative (True)
			Result.append_name (Dose_folder)
			Result.append_name (Image_folder)
			Result.append_name (vd_folder)
		end

	vd_img_background: KL_PATHNAME
			-- Path to "background" image
		do
			Result := vd_img_path
			Result.append_name ("background.png")
		end

	vd_img_stone: KL_PATHNAME
			-- Path to "play" button image
		do
			Result := vd_img_path
			Result.append_name ("hex_orange.png")
		end


	Label_confirm_close_window: STRING = "You are about to close this window.%NClick OK to proceed."
			-- String for the confirmation dialog box that appears
			-- when the user try to close the first window.

end
