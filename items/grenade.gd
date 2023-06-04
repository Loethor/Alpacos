extends RigidBody2D





func explode() -> void:
	print("Explotó la wea")


func _on_explosion_timer_timeout():
	explode()
