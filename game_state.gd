extends Node


const BASE_TURN_DURATION: float = 30
var wind_strenght: Array[int] = [-2, -1, 0, 1, 2]

func _ready():
	randomize()


func obtain_wind_strenght() -> int:
	var wind_id: int = randi() % wind_strenght.size()
	return wind_strenght[wind_id]
