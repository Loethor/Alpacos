extends RigidBody2D


@onready var explosion_particles: GPUParticles2D = $ExplosionParticles
@onready var grenade_sprite: Sprite2D = $GrenadeSprite
@onready var grenade_collider: CollisionShape2D = $CollisionShape2D

var explosion_radius: int = 50

func _on_explosion_timer_timeout() ->void:
	explode()

func explode() -> void:
	SignalBus.has_exploded.emit(global_position, explosion_radius)

	# Handle emission and hidings
	explosion_particles.emitting = true
	grenade_sprite.visible = false
	grenade_collider.disabled = true

	await get_tree().create_timer(1).timeout
	queue_free()

func use() -> void:
	var throw_angle: float = $AimComponent.aim_angle
	var throw_power: int = $ChargedComponent.throw_power

	var impulse: Vector2 = _calculate_impulse(throw_angle, throw_power)
	apply_impulse(Vector2.ZERO)

	$ChargedComponent.throw_power = 0

func _calculate_impulse(throw_angle: float, throw_power: int) -> Vector2:
	if true:
		return throw_power * Vector2(cos(throw_angle), sin(throw_angle))
	else:
		return throw_power * Vector2(-cos(throw_angle), -sin(throw_angle))
