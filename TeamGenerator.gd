class_name Team
extends Node2D

@onready var alpaco_scene: PackedScene = load("res://characters/alpaca.tscn")
@onready var level: Node2D = $'/root/LevelGenerator'

var team_name: String
var list_of_alpacos_names: Array[String]
var team_color: Color
var number_of_alpacos: int

func _init(_team_name: String,
			_list_of_alpacos_names: Array[String],
			_team_color: Color,
			_number_of_alpacos: int) -> void:
	team_name = _team_name
	list_of_alpacos_names = _list_of_alpacos_names
	team_color = _team_color
	number_of_alpacos = _number_of_alpacos

func _ready() -> void:
	add_alpacos(number_of_alpacos)

func add_alpacos(_number_of_alpacos: int):
	for i in range(_number_of_alpacos):
		var new_alpaco = load("res://characters/alpaca.tscn").instantiate()
		new_alpaco.name = list_of_alpacos_names[i]
		new_alpaco.position = _find_valid_spawn_location()
		add_child(new_alpaco)

func _find_valid_spawn_location() -> Vector2:
	print(level.bitmap_level)
	return Vector2.ZERO

