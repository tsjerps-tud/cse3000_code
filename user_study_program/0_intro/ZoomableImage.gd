extends TextureButton


onready var start_rect_position := rect_position
onready var start_rect_size := rect_size

onready var target_rect_position := start_rect_position
onready var target_rect_size := start_rect_size

var fullscreen := false


# -
func _process(delta: float) -> void:
	# interpolate position and size to target
	rect_position = rect_position.linear_interpolate(target_rect_position, 0.15)
	rect_size = rect_size.linear_interpolate(target_rect_size, 0.15)


# -
func _pressed() -> void:
	# switch fullscreen
	fullscreen = not fullscreen
	
	# set target position and size
	target_rect_position = Vector2() if fullscreen else start_rect_position
	target_rect_size = Vector2(960, 540) if fullscreen else start_rect_size
	
	# move to front if fullscreen
	if fullscreen:
		raise()
	
	# set text visibility if present
	var fulltext := get_node_or_null("../FullText")
	if fulltext:
		fulltext.visible = fullscreen
		
		# move text to front if present
		if fullscreen:
			fulltext.raise()
