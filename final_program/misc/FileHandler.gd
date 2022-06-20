extends Node


# loads a texture from a path
func load_texture_from_path(path: String) -> Texture:
	# create a new image
	var image := Image.new()
	
	# load from path
	var error := image.load(path)
	assert(error == OK)
	
	# create a new texture from the image
	var texture := ImageTexture.new()
	texture.create_from_image(image)
	
	# return the image
	return texture


# saves a texture to a path
func save_texture_to_path(texture: Texture, path: String) -> void:
	# get the image
	var data: Image = texture.get_data()
	
	# flip the data vertically
	data.flip_y()
	
	# save image
	data.save_png(path)
