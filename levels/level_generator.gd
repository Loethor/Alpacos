extends Node2D

#@export var noise:FastNoiseLite
@export var debug:bool = false
@export var offset_scale:float = -0.2
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
var image: Image

func _ready() -> void:
	randomize()
	_init_noise()
	_generate_map()
	SignalBus.has_exploded.connect(explode_on_terrain)

	# Show UI in debug mode
	if debug:
		$Control.show()
		_init_ui()

func _init_noise():
	noise.seed = randi()
	noise.fractal_octaves  = 2
	noise.frequency = 0.005
	noise.fractal_weighted_strength  = 0.8

func _generate_map():
	# TODO: select from a list of background images
	image = load("res://assets/models/background/queixo.png")

#	# We need that sweet transparent alpha
	image.convert(Image.FORMAT_RGBA8)

#	# resizing if needed
#	foreground_sprite.texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED
#	image.resize(1920,1080)

	# Obtain image dimensions
	var width: int  = image.get_size().x
	var height: int = image.get_size().y


	# number of pixels to add in the bottom
	var offset = height * offset_scale


	# i is the position of a pixel in the x dimension
	for i in range(0, width):

		# What this does
		# Calculate a noise for the x position (noise_height)
		# multiply it with the height of the image
		# adds an offset in the bottom (more offset -> surface is higher)
		var noise_height: float = (obtain_normaliced_noise(i) * height * height_scale) - offset

		# used for collision
		line.append(noise_height)
#		polygon.append(Vector2(i, noise_height))

		# from 0 (top) until the noise_height set all to transparent
		for j in range(0, noise_height):
			image.set_pixel(i,j, Color.TRANSPARENT)

	create_collision_based_on_image(image)

	# Move it to the center
	foreground_sprite.position = Vector2(width/2.0, height/2.0)
	foreground_sprite.texture = ImageTexture.create_from_image(image)

func obtain_normaliced_noise(x_position:int) -> float:
	# Obtains the noise in x position and
	# returns it in a range from [0 to 1]
	return (noise.get_noise_1d(x_position) + 1)/2

func create_collision_based_on_image(im: Image) -> void:
	var polygons: Array[PackedVector2Array] = _obtain_collision_polygon(im)
	print(polygons.size())

	# if the terrain is divided in multiple pieces, we need a collision
	# for each piece, and a polygon for each collider
	_delete_old_colliders()
	_create_new_colliders(polygons)

	for i in range(0,polygons.size()):
		var new_collider := CollisionPolygon2D.new()
		new_collider.polygon = polygons[i]
		$StaticBody2D.add_child(new_collider)

func _obtain_collision_polygon(im: Image) -> Array[PackedVector2Array]:
	var bitmap_level: BitMap = BitMap.new()
	bitmap_level.create_from_image_alpha(im)
	print(bitmap_level)

	var polygons: Array[PackedVector2Array] = bitmap_level.opaque_to_polygons(
		Rect2(
			Vector2.ZERO,
			im.get_size()
		),
		2.0 # a lower epsilon corresponds to more points in the polygons.
	)
	return polygons

func _delete_old_colliders() -> void:
	for i in range($StaticBody2D.get_child_count()):
		$StaticBody2D.get_child(i).queue_free()

func _create_new_colliders(pols: Array[PackedVector2Array]) -> void:
	for i in range(0,pols.size()):
		var new_collider := CollisionPolygon2D.new()
		new_collider.polygon = pols[i]
		$StaticBody2D.add_child(new_collider)

func explode_on_terrain(at_position: Vector2, explosion_radius: int) -> void:
	# If the image has dimensions image_size
	# and a halo surroding it of size explosion_radius
	# We only calculate the explosion of terrain if
	# the location is inside of that rectangle of size
	# 2 * explosion_radius + image_size.x
	#                  *
	# 2 * explosion_radius + image_size.y
	#
	# ************halo************
	# *//////////image///////////*
	# *//////////image///////////*
	# *//////////image///////////*
	# ************halo************

	var image_rect = image.get_used_rect()
	image_rect.grow(explosion_radius)
	if !image_rect.has_point(at_position):
		return

	var image_size: Vector2i = image.get_size()

	var limit_x_min = max(at_position.x - explosion_radius, 0)
	var limit_x_max = min(at_position.x + explosion_radius, image_size.x)
	var limit_y_min = max(at_position.y - explosion_radius, 0)
	var limit_y_max = min(at_position.y + explosion_radius, image_size.y)

	for i in range(limit_x_min, limit_x_max):
		for j in range(limit_y_min, limit_y_max):
			var radius = (at_position.x - i) * (at_position.x - i) + (at_position.y - j) * (at_position.y - j)
			if radius < explosion_radius * explosion_radius:
				image.set_pixel(i,j, Color.TRANSPARENT)

	# updating the texture in the sprite (faster then creating it from zero!)
	foreground_sprite.texture.update(image)
	# updating the collisions
	create_collision_based_on_image(image)


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

