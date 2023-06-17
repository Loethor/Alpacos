@icon("res://assets/models/icons/aim.svg")
class_name AimComponent extends Node

var aim_angle: float

func _ready() -> void:
	SignalBus.aim_changed.connect(update_angle)

func update_angle(new_aim_angle: float) -> void:
	aim_angle = new_aim_angle
