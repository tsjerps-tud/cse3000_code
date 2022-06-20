extends Node2D


onready var interface: Node2D = $Interface
onready var image: TextureRect = $Interface/Image
onready var color_slider: HSlider = $Interface/ColorSlider
onready var depth_slider: HSlider = $Interface/DepthSlider

onready var total_image: Node2D = $Image
onready var preview_image: TextureRect = $Image/PreviewImage


var file := File.new()

var image_count := 5
var variation_count := 11

var image_names := ["binky", "bowl", "markers"]

var choices := []

var image_index := 0
var variation_index := 0

var variations := []

var data := []

var t := 0

var done := false


var folder: String setget ,_get_folder
func _get_folder() -> String:
	return "res://1_main/images/" + image_names[image_index] + "/"


# -
func _ready() -> void:
	# randomize the RNG
	randomize()
	
	# open file to log to
	# (note: this also clears the file)
	var err := file.open("user://results.csv", File.WRITE)
	assert(err == OK)
	print("Logging started!")
	
	print_file("Session started at " + str(OS.get_time()))
	
	# shuffle image names, generate variations
	image_names.shuffle()
	generate_variations()
	
	# set initial preview
	preview_image.texture = load(self.folder + "preview.png")
	print_file(str(image_index, ": ", image_names[image_index]))


# sets up variations
func generate_variations() -> void:
	# reset score data
	data = []
	data.resize(variation_count)
	
	# populate variations
	variations = []
	variations.resize(variation_count)
	for i in range(variation_count):
		variations[i] = i
	
	# shuffle order
	variations.shuffle()


# continues @ ContinueButton pressed
func _on_ContinueButton_pressed() -> void:
	# get time information
	# (note: time information was unused in final analysis)
	var new_t := OS.get_ticks_msec()
	var dt := new_t - t
	t = new_t
	
	# check if we are at the preview or at scoring
	if total_image.visible:
		# set up score interface
		total_image.visible = false
		interface.visible = true
	else:
		# get values from sliders
		var color_value := color_slider.value
		var depth_value := depth_slider.value
		
		# reset sliders
		color_slider.value = 0.5
		depth_slider.value = 0.5
		
		# get current variation
		var current_variation: int = variations[variation_index]
		
		# store data
		data[current_variation] = [color_value, depth_value, dt/1000.0]
		
		# go to next variation
		variation_index += 1
		
		# go to next image
		if variation_index >= variation_count:
			image_index += 1
			
			# print data in order
			for i in range(variation_count):
				print_array_file([i] + data[i])
			
			# finish if no images left
			if image_index == image_names.size():
				done = true
				
				get_tree().change_scene("res://2_final/Final.tscn")
				return
			
			# reset variations
			variation_index = 0
			generate_variations()
			
			# initialize preview
			preview_image.texture = load(self.folder + "preview.png")
			total_image.visible = true
			interface.visible = false
	
	# print and log
	if not total_image.visible:
		print("[IMAGE]   ", image_index, ".", variations[variation_index])
	else:
		print_file(str(image_index, ": ", image_names[image_index]))
	
	# load images
	var path := self.folder + str(variations[variation_index]) + ".png"
	image.texture = load(path)


# -
func _exit_tree() -> void:
	# get status
	var verb := "finished" if done else "aborted"
	
	# log
	print_file("Session " + verb + " at " + str(OS.get_time()))
	
	# save and close log
	print("[LOG]     Saved to " + file.get_path())
	file.close()


# logs a string to file
func print_file(s: String) -> void:
	print("[LOG]     " + s)
	
	file.store_line(s)


# logs an array to file, comma-separated
func print_array_file(arr: Array) -> void:
	var str_arr := []
	
	for val in arr:
		str_arr.push_back(str(val))
	
	print_file(PoolStringArray(str_arr).join(","))
