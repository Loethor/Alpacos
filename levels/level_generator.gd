extends Node2D

#@export var noise:FastNoiseLite
@export var debug:bool = false
@export var offset_scale:float = 0
@export var height_scale:float = .5

@onready var foreground_sprite:Sprite2D = $ForegroundSprite

@onready var seed_label:Label = $Control/MarginContainer/VBoxContainer/SeedLabel
@onready var offset_label:Label = $Control/MarginContainer/VBoxContainer/OffsetLabel
@onready var height_label:Label = $Control/MarginContainer/VBoxContainer/HeightLabel
@onready var octaves_label:Label = $Control/MarginContainer/VBoxContainer/OctavesLabel

@onready var seed_hscroll:HScrollBar = $Control/MarginContainer2/VBoxContainer2/SeedHS
@onready var octaves_hscroll:HScrollBar = $Control/MarginContainer2/VBoxContainer2/OctavesHS
@onready var height_hscroll:HScrollBar = $Control/MarginContainer2/VBoxContainer2/HeightHS
@onready var offset_hscroll:HScrollBar = $Control/MarginContainer2/VBoxContainer2/OffsetHS


var line := []
var noise:FastNoiseLite = FastNoiseLite.new()


func _ready() -> void:
	randomize()
	_init_noise()
	_generate_map()

	# Show UI in debug mode
	if debug:
		$Control.show()
		_init_ui()

func _generate_map():
	# TODO: select from a list of background images
	var image:Image = load("res://assets/models/background/queixo.png")

	# We need that sweet transparent alpha
	image.convert(Image.FORMAT_RGBA8)

	# Obtain image dimensions
	var width: int  = image.get_size().x
	var height: int = image.get_size().y

	# number of pixels to add in the bottom
	var offset = height * offset_scale

	# Loethor fuckery
	var polygon: PackedVector2Array = PackedVector2Array()

	# i is the position of a pixel in the x dimension
	for i in range(0, width):

		# What this does
		# Calculate a noise for the x position (noise_height)
		# multiply it with the height of the image
		# adds an offset in the bottom (more offset -> surface is higher)
		var noise_height: float = (obtain_normaliced_noise(i) * height * height_scale) - offset

		# used for collision
		line.append(noise_height)
		polygon.append(Vector2(i, noise_height))

		# from 0 (top) until the noise_height set all to transparent
		for j in range(0, noise_height):
			image.set_pixel(i,j, Color.TRANSPARENT)

	# add collision
	# just don't ask, but it works
	polygon.append(Vector2(width,height))
	polygon.append(Vector2(0,height))
	$StaticBody2D/CollisionPolygon2D.polygon = polygon

	# Move it to the center
	foreground_sprite.position = Vector2(width/2.0, height/2.0)
	foreground_sprite.texture = ImageTexture.create_from_image(image)

func obtain_normaliced_noise(x_position:int) -> float:
	# Obtains the noise in x position and
	# returns it in a range from [0 to 1]
	return (noise.get_noise_1d(x_position) + 1)/2

func _init_noise():
	noise.seed = randi()
	noise.fractal_octaves  = 2
	noise.frequency = 0.005
	noise.fractal_weighted_strength  = 0.8


# TODO: manage explosions



######## DEBUG MODE ONLY #######
func _init_ui():
	seed_label.text = "Seed: %s" % str(0)
	offset_label.text = "Offset: %s" % str(offset_scale)
	height_label.text = "Height: %s" % str(height_scale)
	octaves_label.text = "Octaves: %s" % str(noise.fractal_octaves)

func _on_seed_hs_value_changed(value: float) -> void:
	seed_label.text = "Seed: %s" % str(value)
	noise.seed = int(value)
	_generate_map()

func _on_offset_hs_value_changed(value: float) -> void:
	offset_label.text = "Offset: %s" % str(value)
	offset_scale = value
	_generate_map()


func _on_octaves_hs_value_changed(value: float) -> void:
	octaves_label.text = "Octaves: %s" % str(value)
	noise.fractal_octaves = int(value)
	_generate_map()


func _on_height_hs_value_changed(value: float) -> void:
	height_label.text = "Height: %s" % str(value)
	height_scale = value
	_generate_map()

