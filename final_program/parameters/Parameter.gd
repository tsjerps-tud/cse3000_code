class_name Parameter
extends Node


export var param_name: String

export(String, "generation", "metric", "final") var parameter_type: String

onready var main := get_tree().current_scene


# -
func _ready() -> void:
	add_to_group("parameters")


# sets the corresponding param in the program
func set_param(value) -> void:
	match parameter_type:
		"generation":
			# ignore if program is optimising
			if main.is_optimising:
				return
			
			main.set_generation_param(param_name, value)
		"metric":
			main.set_metric_param(param_name, value)
		"final":
			main.set_final_param(param_name, value)


# sets the value of the UI element of the parameter
func set_value(_value) -> void:
	assert(false, "Not yet implemented!")
