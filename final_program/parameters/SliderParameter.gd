extends Parameter


onready var slider: Slider = $Slider


# sets the value of the UI element of the parameter
func set_value(value) -> void:
	slider.value = float(value)
