extends RigidBody2D


@onready var explosion:GPUParticles2D = $ExplosionParticles
@onready var grenade:Sprite2D = $GrenadeSprite



func explode() -> void:
	print("Explotó la wea")
	explosion.emitting = true
	grenade.visible = false
	await get_tree().create_timer(1).timeout
	print("Se fue a la wea")
	queue_free()
func _on_explosion_timer_timeout() ->void:
	explode()


