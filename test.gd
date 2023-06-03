extends Node2D



func _ready() -> void:
	var img_width = 10
	var img_height = 5
	var img = Image.create(img_width, img_height, false, Image.FORMAT_RGBA8)

	img.set_pixel(1, 2, Color.RED) # Sets the color at (1, 2) to red.
