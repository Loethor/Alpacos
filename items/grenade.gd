extends RigidBody2D


@onready var explosion_particles: GPUParticles2D = $ExplosionParticles
@onready var grenade_sprite: Sprite2D = $GrenadeSprite
@onready var grenade_collider: CollisionShape2D = $CollisionShape2D

func explode() -> void:
	print("Explotó la wea")
	explosion_particles.emitting = true
	grenade_sprite.visible = false
	grenade_collider.disabled = true
	await get_tree().create_timer(1).timeout
	print("Se fue a la wea")
	queue_free()

func _on_explosion_timer_timeout() ->void:
	explode()

func throw(impulse: Vector2) -> void:
	apply_impulse(impulse)

