@icon("res://assets/models/icons/charged.svg")
class_name ChargedComponent extends Node

var throw_power: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.throw_power_increased.connect(update_throw_power)

func update_throw_power(new_throw_power: int) -> void:
	throw_power = new_throw_power
	print("updated throw power")
