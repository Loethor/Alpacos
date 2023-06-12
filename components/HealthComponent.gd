class_name HealthComponent
extends Node

signal health_changed(health)

@export var health: int = 100

func take_damage(damage_amount: int) -> void:
	health -= damage_amount
	if health < 0:
		health = 0
	health_changed.emit(health)

func heal(heal_amount: int) -> void:
	health += heal_amount
	health_changed.emit(health)
