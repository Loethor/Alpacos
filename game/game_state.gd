extends Node

signal wind_changed(current_wind)

const BASE_TURN_DURATION: float = 30

var wind_strenght: Array[int] = [-2, -1, 0, 1, 2]
var prev_wind_id: int = 0

func _ready():
	randomize()
	obtain_wind_strenght()

func obtain_wind_strenght() -> int:
	var wind_id: int = randi() % wind_strenght.size()

	while prev_wind_id == wind_id:
		wind_id = randi() % wind_strenght.size()
	prev_wind_id = wind_id

	wind_changed.emit(wind_strenght[wind_id])

	return wind_strenght[wind_id]
