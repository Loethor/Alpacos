extends RigidBody2D


@onready var explosion_particles: GPUParticles2D = $ExplosionParticles
@onready var grenade_sprite: Sprite2D = $Sprite2D
@onready var grenade_collider: CollisionShape2D = $CollisionShape2D

var explosion_radius: int = 50

var facing_direction: int
var throw_angle_radians: float
var throw_power: int

var parent:Node2D

func _ready() -> void:
	parent = $".."
	_update_throw_properties()

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

	# Update grenade properties
	_update_throw_properties()

	# Start the timer
	$ExplosionTimer.start()

	# Adjust sprite
	$Sprite2D.flip_h = true
	$Sprite2D.show()

	# Calculate the impulse
	var impulse: Vector2 = _calculate_impulse()

	# Start to apply physics
	freeze = false
	apply_impulse(impulse)

	# Reset throw power
	$ChargedComponent.throw_power = 0

	await get_tree().create_timer(0.25).timeout
	remove_collision_exception_with(parent)

func _calculate_impulse() -> Vector2:
	# Because of how the angles are defined, we need to use the
	# facing direction of the father

	return parent.facing_direction * \
		   throw_power * \
		   Vector2(cos(throw_angle_radians), sin(throw_angle_radians))


func _update_throw_properties() -> void:
	throw_angle_radians = $AimComponent.aim_angle_radians
	throw_power = $ChargedComponent.throw_power
	$Sprite2D.rotation = throw_angle_radians
