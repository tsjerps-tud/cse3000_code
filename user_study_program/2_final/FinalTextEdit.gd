extends TextEdit


var file := File.new()


# -
func _ready() -> void:
	# open the file
	var err := file.open("user://results.csv", File.READ)
	assert(err == OK)
	
	# put the text in the textbox
	text = file.get_as_text()
