extends Control


onready var parameters: Control = $"../../Parameters"
onready var results: Control = $"../../Results"


# -
func _process(delta: float) -> void:
	# move results tab based on parameter visibility
	var target_x := 512.0 if parameters.visible else 284.0
	
	results.rect_position.x = lerp(results.rect_position.x, target_x, 0.15)


# toggles visibility of parameters
func _on_OptimisationCheckButton_toggled(button_pressed: bool) -> void:
	parameters.visible = button_pressed
