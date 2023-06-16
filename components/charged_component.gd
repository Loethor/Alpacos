@icon("res://assets/models/icons/charged.svg")
class_name ChargedComponent extends Node

const THROW_POWER_INCREASE := 50
const THROW_POWER_LIMIT := 1000
var throw_power: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.throw_power_increased.connect(update_throw_power)

func update_throw_power() -> void:
	if throw_power < THROW_POWER_LIMIT:
		throw_power += THROW_POWER_INCREASE
