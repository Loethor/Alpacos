extends Node2D

@export var noise :FastNoiseLite
@export var debug:bool = false
@export var offset_scale:float = 0.08
@export var high_scale:float = 0.4

@onready var fg:Sprite2D = $FG
@onready var sle:LineEdit = $CanvasLayer/Control/VBoxContainer/HBoxContainer/SeedLineEdit
@onready var ole:LineEdit = $CanvasLayer/Control/VBoxContainer/HBoxContainer2/OctavesLineEdit
@onready var fle:LineEdit = $CanvasLayer/Control/VBoxContainer/HBoxContainer3/FrequencyLineEdit
@onready var wle:LineEdit = $CanvasLayer/Control/VBoxContainer/HBoxContainer4/WeightedFractalLabelLineEdit


var line := []

# for reference, parameters that are ok
#	noise.seed = randi()
#	noise.fractal_octaves  = 2
#	noise.frequency = 0.005
#	noise.fractal_weighted_strength  = 0.8


func _ready() -> void:
	randomize()
	_initialize_ui()
	_generate_map()
	if debug:
		$CanvasLayer/Control.show()


func _generate_map():
	var image = Image.load_from_file("res://assets/queixo.png")
	image.convert(Image.FORMAT_RGBA8)
	var texture = ImageTexture.create_from_image(image)

	fg.texture = texture
	var fg_data:Image = fg.texture.get_image()
	print(fg_data.get_size())
	var w = fg_data.get_size().x
	var h = fg_data.get_size().y
	fg.position = Vector2(w/2,h/2)

	for x in range(0, fg_data.get_width()):
		# Looping in the x axis of the image
		# Calculate a noise for the x position (high)
		# Noise returns a number from -1 to 1, so add 1 and divide by 2 -> 0 to 1
		# We then multiply by 40% of the map height such that the height can cover 80% of the screen
		# Finally we add 8% of the map height to kinda center the terrain
		var offset =  fg_data.get_height() * offset_scale
		var high = ((noise.get_noise_1d(x) + 1)/2 * fg_data.get_height() * high_scale) + offset
		line.append(high)
		for y in range(0, high):
			# from 0 (top) to high all set to transparent
			fg_data.set_pixel(x,y, Color.TRANSPARENT)

	if debug:
		fg_data.save_png("res://queixo_cortado.png")
	fg.texture.set_image(fg_data) # Set the new data as the texture


func _on_property_list_changed() -> void:
	_generate_map()

func _initialize_ui() -> void:
	sle.text = str(noise.seed)
	ole.text = str(noise.fractal_octaves)
	fle.text = str(noise.frequency)
	wle.text = str(noise.fractal_weighted_strength)


func _on_seed_line_edit_text_changed(new_text: String) -> void:
	noise.seed = int(sle.text)
	_generate_map()


func _on_octaves_line_edit_text_changed(new_text: String) -> void:
	noise.fractal_octaves = float(ole.text)
	_generate_map()

func _on_frequency_line_edit_text_changed(new_text: String) -> void:
	noise.frequency = float(fle.text)
	_generate_map()

func _on_weighted_fractal_label_line_edit_text_changed(new_text: String) -> void:
	noise.fractal_weighted_strength = float(wle.text)
	_generate_map()
