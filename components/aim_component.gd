@icon("res://assets/models/icons/aim.svg")
class_name AimComponent extends Node

var aim_angle_radians: float

func _ready() -> void:
	SignalBus.aim_changed.connect(update_angle_radians)

func update_angle_radians(new_aim_angle_radians: float) -> void:
	aim_angle_radians = new_aim_angle_radians
