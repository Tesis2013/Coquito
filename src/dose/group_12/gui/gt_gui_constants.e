note
	description: "Summary description for {G12_GUI_CONSTANTS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GT_GUI_CONSTANTS

inherit
    KL_SHARED_FILE_SYSTEM
        export {NONE}
            all
        end

feature -- Access

	Dose_folder: STRING = "dose"
	Image_folder: STRING = "images"
	g12_folder: STRING = "group_12"
	gray_folder: STRING = "gray"

	g12_img_path: KL_PATHNAME
		do
			create Result.make
			Result.set_relative (True)
			Result.append_name (Dose_folder)
			Result.append_name (Image_folder)
			Result.append_name (g12_folder)
		end

	gt_img(file_name : STRING; gray : BOOLEAN) : KL_PATHNAME
		do
			Result := g12_img_path
			if gray then
				Result.append_name(gray_folder)
			end
			Result.append_name (file_name)
		end

	frozen STANDARD_FONT: EV_FONT
        once
            create Result
            Result.set_family (feature {EV_FONT_CONSTANTS}.Family_roman)
            Result.set_weight (feature {EV_FONT_CONSTANTS}.Weight_bold)
            Result.set_shape (feature {EV_FONT_CONSTANTS}.Shape_regular)
            Result.set_height_in_points (16)
            Result.preferred_families.extend ("Arial")
        end

    frozen BOLD_FONT: EV_FONT
        once
            create Result
            Result.set_weight (feature {EV_FONT_CONSTANTS}.Weight_bold)
        end

	Label_confirm_close_window: STRING = "Do you really want to quit?"
	demand_plot_card_selection: STRING = "Please select a plot card!"
	more_cards_button_text: STRING = "MORE CARDS"


	get_image(an_id : INTEGER; gray : BOOLEAN) : EV_PIXMAP
		local
			card_img : EV_PIXMAP
			img_id: STRING
		do
			img_id := ".png"
			create card_img
			img_id.prepend_integer (an_id)
			card_img.set_with_named_file (file_system.pathname_to_string (gt_img(img_id, gray)))
			Result := card_img

		end

	color_bw(a_widget : EV_WIDGET)
	do
		a_widget.set_background_color (create {EV_COLOR}.make_with_8_bit_rgb (0, 0, 0))
		a_widget.set_foreground_color (create {EV_COLOR}.make_with_8_bit_rgb (255, 255, 255))
	end

end
