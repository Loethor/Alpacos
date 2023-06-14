extends Node2D

var path_to_image: String = "res://assets/models/background/queixo.png"

func _ready() -> void:
	var level = LevelGenerator.new(path_to_image)
	$Level.add_child(level)
	var team1: Team = Team.new("Titanic", ["Jack", "Rose"], Color.BLUE, 2)
	var team2: Team = Team.new("Star Wars", ["Luke", "Leia"], Color.RED, 2)
	$Teams.add_child(team1)
	$Teams.add_child(team2)
