extends RigidBody2D


@onready var explosion_particles: GPUParticles2D = $ExplosionParticles
@onready var grenade_sprite: Sprite2D = $GrenadeSprite
@onready var grenade_collider: CollisionShape2D = $CollisionShape2D

var explosion_radius: int = 50

func explode() -> void:
	$ExplosionComponent.explode(global_position)
	explosion_particles.emitting = true
	grenade_sprite.visible = false
	grenade_collider.disabled = true

	await get_tree().create_timer(1).timeout
	queue_free()

func _on_explosion_timer_timeout() ->void:
	explode()

func throw(impulse: Vector2) -> void:
	apply_impulse(impulse)

