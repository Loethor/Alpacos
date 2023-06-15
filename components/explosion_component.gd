@icon("res://assets/models/icons/explosion_component.svg")
class_name ExplosionComponent
extends Node

@export var explosion_radius: int = 50

func explode(gl_pos: Vector2) -> void:
	SignalBus.has_exploded.emit(gl_pos, explosion_radius)
