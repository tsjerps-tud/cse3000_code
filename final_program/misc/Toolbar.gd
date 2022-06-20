extends Control


onready var main := get_parent()

onready var colour_button: Button = $ColourButton
onready var depth_button: Button = $DepthButton
onready var export_button: Button = $ExportButton

onready var open_file_dialog: FileDialog = $OpenFileDialog
onready var save_file_dialog: FileDialog = $SaveFileDialog

var import_image_type := ""


# starts importing a colour image @ ColourButton pressed
func _on_ColourButton_pressed() -> void:
	# set type of image to be imported
	import_image_type = "colour"
	
	# pop up the dialog
	open_file_dialog.popup_centered()


# starts importing a depth image @ DepthButton pressed
func _on_DepthButton_pressed() -> void:
	# set type of image to be imported
	import_image_type = "depth"
	
	# pop up the dialog
	open_file_dialog.popup_centered()


# starts exporting a final image @ ExportButton pressed
func _on_ExportButton_pressed() -> void:
	# pop up the dialog
	save_file_dialog.popup_centered()


# imports an image @ OpenFileDialog file_selected
func _on_OpenFileDialog_file_selected(path: String) -> void:
	# import the image
	var new_texture := FileHandler.load_texture_from_path(path)
	
	match import_image_type:
		"depth", "colour":
			var tex_param_name := import_image_type + "_texture"
			
			main.set_generation_param(tex_param_name, new_texture)
			main.set_metric_param(tex_param_name, new_texture)
		_:
			assert(false, "Unable to import image")


# exports the final image @ SaveFileDialog file_selected
func _on_SaveFileDialog_file_selected(path: String) -> void:
	# get the top viewport
	var viewports := main.get_node("Results/Viewports")
	var viewport: Viewport = viewports.get_child(viewports.get_child_count() - 1).get_node("Viewport")
	
	# save the image
	FileHandler.save_texture_to_path(viewport.get_texture(), path)
