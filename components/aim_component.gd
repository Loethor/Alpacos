@icon("res://assets/models/icons/aim.svg")
class_name AimComponent extends Node

var aim_angle: float
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.aim_changed.connect(update_angle)

func update_angle(new_aim_angle: float) -> void:
	aim_angle = new_aim_angle
