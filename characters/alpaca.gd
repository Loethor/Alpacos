extends CharacterBody2D

enum DIRECTION {LEFT, RIGHT}

const MOVEMENT_SPEED = 100.0
const AIR_FRICTION = 1.0

const FORWARD_JUMP_VELOCITY_X = 150.0
const FORWARD_JUMP_VELOCITY_Y = -250.0

const IN_PLACE_JUMP_VELOCITY_Y = -300

const FLIP_JUMP_VELOCITY_X = 80
const FLIP_JUMP_VELOCITY_Y = -400
const AIM_SPRITE_DISTANCE = 50

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var previous_facing_direction: DIRECTION = DIRECTION.LEFT
var facing_direction: DIRECTION = DIRECTION.LEFT
var power: int = 0


@onready var alpaco_sprite:Sprite2D = $AlpacoSprite
@onready var aim_sprite:Sprite2D = $AimSprite
@onready var health_component:HealthComponent = $HealthComponent

func _ready() -> void:

	# Not sliding
	floor_stop_on_slope = true
	# Can walk slopes up to 85 deg
	floor_max_angle = deg_to_rad(85)
	# Same speed going up and down
	floor_constant_speed = true

	health_component.health_changed.connect(update_label)
	update_label(health_component.health)

func _physics_process(delta):

	# Add the gravity and the air friction.
	if not is_on_floor():
		velocity.y += gravity * delta
		velocity.x = move_toward(velocity.x, 0, AIR_FRICTION)

	# All the actions that can be performed on the exclusively on the floor
	if is_on_floor():

		# Get the input direction and handle the movement/deceleration.
		var direction = Input.get_axis("left", "right")
		if direction:
			# Store previous facing direction
			previous_facing_direction = facing_direction

			# Update facing direction
			facing_direction = DIRECTION.RIGHT if direction == 1.0 else DIRECTION.LEFT

			# Adjust aim rotation if direction has changed
			if previous_facing_direction != facing_direction:
				# Angle must be mirrowed in x-axis
				aim_sprite.rotation_degrees -= 2*aim_sprite.rotation_degrees

			# Update velocity
			velocity.x = direction * MOVEMENT_SPEED

			# Handle sprite direction
			alpaco_sprite.flip_h = facing_direction == DIRECTION.RIGHT
		else:
			# no input, velocity set to 0
			velocity.x = 0


		# Handle forward jump.
		if Input.is_action_just_pressed("forward_jump"):
			velocity.y = FORWARD_JUMP_VELOCITY_Y
			velocity.x = FORWARD_JUMP_VELOCITY_X if facing_direction == DIRECTION.RIGHT else -FORWARD_JUMP_VELOCITY_X
			move_and_slide()

		# Handle in-place jump.
		if Input.is_action_just_pressed("in_place_jump"):
			velocity.x = 0
			velocity.y = IN_PLACE_JUMP_VELOCITY_Y
			move_and_slide()

		# Handle flip jump.
		if Input.is_action_just_pressed("flip_jump"):
			velocity.y = FLIP_JUMP_VELOCITY_Y
			velocity.x = FLIP_JUMP_VELOCITY_X if facing_direction == DIRECTION.LEFT else -FLIP_JUMP_VELOCITY_X
			move_and_slide()

		# Handle inventory.
		if Input.is_action_just_pressed("inventory"):
			open_inventory()

		# Handle Aim.
		aim_sprite.offset.x = AIM_SPRITE_DISTANCE if facing_direction == DIRECTION.RIGHT else -AIM_SPRITE_DISTANCE
		var aim_direction = Input.get_axis("aim_down", "aim_up")
		var new_rotation = aim_sprite.rotation_degrees

		match facing_direction:
			DIRECTION.RIGHT:
				new_rotation -= aim_direction
			DIRECTION.LEFT:
				new_rotation += aim_direction
		aim_sprite.rotation_degrees = clamp(new_rotation, -90, 90)

	# Handle menu.
	if Input.is_action_just_pressed("menu"):
		open_menu()

	# TODO this is a temporal solution
	# in the future depending on the weapong we don't want this behavior
	# e.g., shotgun should just "shoot" and not hold and release
	# Holding  use.
	if Input.is_action_pressed("use"):
		if power < 1000:
			power += 50

	# Releasing use.
	if Input.is_action_just_released("use"):
		use(power)
		power = 0

	move_and_slide()

# this works temporary and only for grenade
# TODO make this work for any kind of weapon
func use(throw_power: int) -> void:

	# Selected weapon scene
	var grenade_scene: PackedScene = preload("res://items/grenade.tscn")
	var grenade_instance := grenade_scene.instantiate()

	# make it not collide initially with the parent
	grenade_instance.add_collision_exception_with(self)

	# throw angle
	var angle: float = aim_sprite.rotation

	# because of dirty angle hack, we have to manage directions here too
	var throw_direction: Vector2 = Vector2.ZERO
	if facing_direction == DIRECTION.RIGHT:
		throw_direction = throw_power * Vector2(cos(angle), sin(angle))
	else:
		throw_direction = throw_power * Vector2(-cos(angle), -sin(angle))

	# throw the grenade
	grenade_instance.position = self.position
	grenade_instance.throw(throw_direction)
	$"/root/Game".add_child(grenade_instance)

	# give back the colision with parent after 0.25 secs
	await get_tree().create_timer(0.25).timeout
	grenade_instance.remove_collision_exception_with(self)

func open_inventory():
	print("Se abrió la wea de inventario")

func open_menu():
	print("Se abrió la wea de menu")

func take_damage(damage_amount: int):
	health_component.take_damage(damage_amount)

func heal(heal_amount: int):
	health_component.heal(heal_amount)

func update_label(new_health: int):
	$HealthLabel.text = str(new_health)
