extends Button


export var scene_path := ""


# -
func _pressed() -> void:
	# go to the specified scene
	get_tree().change_scene(scene_path)
