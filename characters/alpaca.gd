extends CharacterBody2D

enum DIRECTION {LEFT = -1, RIGHT = 1}

const MOVEMENT_SPEED = 100.0
const AIR_FRICTION = 1.0

const FORWARD_JUMP_VELOCITY_X = 150.0
const FORWARD_JUMP_VELOCITY_Y = -250.0

const IN_PLACE_JUMP_VELOCITY_Y = -300

const FLIP_JUMP_VELOCITY_X = 80
const FLIP_JUMP_VELOCITY_Y = -400
const AIM_SPRITE_DISTANCE = 50

const THROW_POWER_INCREASE := 50
const THROW_POWER_LIMIT := 1000

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Player properties
var previous_facing_direction: DIRECTION = DIRECTION.LEFT
var facing_direction: DIRECTION = DIRECTION.LEFT
var throw_power: int = 0
var aim_angle: float = 0.0

# Related to the selected weapon
var has_weapon_selected: bool = false
var SelectedWeaponScene: PackedScene
var selected_weapon_instance

@onready var selected_weapon_sprite := Sprite2D.new()
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

	_init_selected_weapon()


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
			SignalBus.facing_direction_changed.emit(direction)

			# Adjust aim rotation if direction has changed
			if previous_facing_direction != facing_direction:
				# Angle must be mirrowed in x-axis
				aim_sprite.rotation_degrees -= 2*aim_sprite.rotation_degrees

				# Update any component that uses rotation
				SignalBus.aim_changed.emit(aim_sprite.rotation)
				if has_weapon_selected:
					selected_weapon_sprite.rotation_degrees -= 2*selected_weapon_sprite.rotation_degrees

			# Update velocity
			velocity.x = direction * MOVEMENT_SPEED

			# Handle sprite direction
			alpaco_sprite.flip_h = facing_direction == DIRECTION.RIGHT
		else:
			# no input, velocity set to 0
			velocity.x = 0

		# Handle forward jump.
		if Input.is_action_just_pressed("forward_jump"):
			# TODO try with move towards 0 at the movement else
			# and velocity x = 0 here, with move and slide
			# and then the velocity adjustments
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
		# Update selected weapon sprite
		if has_weapon_selected:
			selected_weapon_sprite.offset.x = 20 if facing_direction == DIRECTION.RIGHT else -20

		# Value is -1 if aiming up, 1 if aiming down
		var aim_direction = Input.get_axis("aim_up", "aim_down")
		var new_rotation = aim_sprite.rotation_degrees

		match facing_direction:
			DIRECTION.RIGHT:
				new_rotation += aim_direction
			DIRECTION.LEFT:
				new_rotation -= aim_direction
		aim_sprite.rotation_degrees = clamp(new_rotation, -90, 90)
		# Update all aim users
		SignalBus.aim_changed.emit(aim_sprite.rotation)
		if has_weapon_selected:
			selected_weapon_sprite.rotation_degrees = aim_sprite.rotation_degrees + 180

	# Handle menu.
	if Input.is_action_just_pressed("menu"):
		open_menu()

	if has_weapon_selected:
		# TODO only working for grenade
		if Input.is_action_pressed("use"):
			if throw_power < THROW_POWER_LIMIT:
				throw_power += THROW_POWER_INCREASE
			SignalBus.throw_power_increased.emit(throw_power)

		# Releasing use.
		if Input.is_action_just_released("use"):
			use()
			throw_power = 0

	move_and_slide()

func use() -> void:

	selected_weapon_instance.use()
	has_weapon_selected = false
	selected_weapon_sprite.queue_free()

	# restart select weapons
	selected_weapon_instance = null
	selected_weapon_sprite = Sprite2D.new()

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

func _init_selected_weapon() -> void:
	var GrenadeScene: PackedScene = load("res://items/grenade.tscn")
	SelectedWeaponScene = GrenadeScene
	has_weapon_selected = true
	selected_weapon_instance = SelectedWeaponScene.instantiate()
	selected_weapon_instance.add_collision_exception_with(self)

	selected_weapon_sprite.texture = selected_weapon_instance.get_child(0).texture
	selected_weapon_sprite.offset.x = -20
	selected_weapon_sprite.flip_v = true # why the fuck is this needed?

	add_child(selected_weapon_sprite)
	add_child(selected_weapon_instance)
