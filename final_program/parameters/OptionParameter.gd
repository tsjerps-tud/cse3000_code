extends Parameter


export var items: PoolStringArray

onready var option_button: OptionButton = $OptionButton


# -
func _ready() -> void:
	# populate items
	for item in items:
		option_button.add_item(item)


# sets the value of the UI element of the parameter
func set_value(value) -> void:
	option_button.selected = int(value)
