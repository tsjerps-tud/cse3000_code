extends Control

onready var final_image_viewport: Viewport = $Results/Viewports/FinalImageViewportContainer/Viewport
onready var final_image_shader: ShaderMaterial = final_image_viewport.get_node("Image").material

onready var metric_viewport: Viewport = $Results/Viewports/MetricViewportContainer/Viewport
onready var metric_shader: ShaderMaterial = metric_viewport.get_node("Image").material

onready var metric_label: Label = $Results/MetricLabel

var param_changed := false

var is_optimising := false

var final_params := {
	"colour_score": 0.5,
	"depth_score": 0.5
}


func _ready() -> void:
	# define generation parameters to be optimised
	var params := ["p_near", "p_far", "p_blending"]
	var i := 0
	
	var M: float = 1000.0
	var Mprev := 0.0
	
	var V := 0.0
	var Vprev := 0.0
	
	while true:
		# busy-wait when not optimising
		# (yield() stops and stores the program state until the signal is emitted)
		while not is_optimising:
			yield(get_tree(), "idle_frame")
		
		# get previous metric and parameter value
		Mprev = calculate_metric()
		Vprev = final_image_shader.get_shader_param(params[i])
		
		# update parameter value
		V = clamp(Vprev + sign(randf() - 0.5) * 0.005, 0, 1)
		final_image_shader.set_shader_param(params[i], V)
		
		# wait for update (waiting for 2 frames is required)
		yield(get_tree(), "idle_frame")
		yield(get_tree(), "idle_frame")
		
		# calculate new metric, revert parameter if the new metric is worse
		M = calculate_metric()
		if M > Mprev:
			V = Vprev
			
			final_image_shader.set_shader_param(params[i], V)
		
		set_parameter_value(params[i], V)
		
		# go to next parameter
		i = (i + 1) % params.size()


# find the Parameter node with the given name
func find_parameter(param_name: String) -> Parameter:
	for _p in get_tree().get_nodes_in_group("parameters"):
		var parameter := _p as Parameter
		
		if parameter.param_name == param_name:
			return parameter
	
	assert(false, "Cannot find parameter!")
	
	return null


# set the value of the specified parameter
func set_parameter_value(param_name: String, v) -> void:
	find_parameter(param_name).set_value(v)


# -
func _process(_delta: float) -> void:
	# recalculate metric if parameter changed
	if param_changed and not is_optimising:
		yield(get_tree(), "idle_frame")
		
		calculate_metric()


# recalculates the metric based on the image
func calculate_metric() -> float:
	# get metric image
	var metric_data: Image = metric_viewport.get_texture().get_data()
	
	# lock image
	metric_data.lock()
	
	var metric := 0.0
	
	for y in range(240):
		for x in range(320):
			metric += metric_data.get_pixel(x, y).r
	
	metric /= 320 * 240
	
	# unlock image
	metric_data.unlock()
	
	# set label text
	metric_label.text = "Metric = " + str(metric)
	
	return metric


# sets the specified generation shader param
func set_generation_param(param_name: String, value) -> void:
	final_image_shader.set_shader_param(param_name, value)
	param_changed = true


# returns the specified generation shader param
func get_generation_param(param_name: String):
	return final_image_shader.get_shader_param(param_name)


# sets the specified metric shader param
func set_metric_param(param_name: String, value) -> void:
	metric_shader.set_shader_param(param_name, value)
	param_changed = true


# returns the specified metric shader param
func get_metric_param(param_name: String):
	return metric_shader.get_shader_param(param_name)


# sets the specified final param
func set_final_param(param_name: String, value) -> void:
	final_params[param_name] = value
	
	# set f following the regression
	var colour_score: float = final_params["colour_score"]
	var depth_score: float = final_params["depth_score"]
	
	if depth_score + colour_score == 0:
		return
	
	var new_f := depth_score / (depth_score + colour_score)
	new_f = 0.8465737947152412 * new_f - 0.027980912342896017
	new_f = clamp(new_f, 0, 1)
	
	set_metric_param("f", new_f)
	set_parameter_value("f", new_f)


# toggle optimisation
func _on_OptimisationCheckButton_toggled(button_pressed: bool) -> void:
	is_optimising = button_pressed
