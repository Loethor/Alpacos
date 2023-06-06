extends CharacterBody2D


const MOVEMENT_SPEED = 100.0
const AIR_FRICTION = 1.0
const FORWARD_JUMP_VELOCITY_X = 150.0
const FORWARD_JUMP_VELOCITY_Y = -250.0

const IN_PLACE_JUMP_VELOCITY_Y = -300

const FLIP_JUMP_VELOCITY_X = 50
const FLIP_JUMP_VELOCITY_Y = -350
const AIM_SPRITE_DISTANCE = 50

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var facing_direction: float = -1.0

@onready var pivot: Node2D = $Pivot
@onready var alpaco_sprite:Sprite2D = $AlpacoSprite

func _physics_process(delta):
	pivot.get_child(0).position.x = AIM_SPRITE_DISTANCE if facing_direction == 1.0 else -AIM_SPRITE_DISTANCE


	# Add the gravity and the air friction.
	if not is_on_floor():
		velocity.y += gravity * delta
		velocity.x = move_toward(velocity.x, 0, AIR_FRICTION)

	# Handle use.
	if Input.is_action_just_pressed("use"):
		use()

	# Handle forward jump.
	if Input.is_action_just_pressed("forward_jump") and is_on_floor():
		velocity.y = FORWARD_JUMP_VELOCITY_Y
		velocity.x = FORWARD_JUMP_VELOCITY_X if facing_direction == 1.0 else -FORWARD_JUMP_VELOCITY_X
		move_and_slide()

	# Handle in-place jump.
	if Input.is_action_just_pressed("in_place_jump") and is_on_floor():
		velocity.y = IN_PLACE_JUMP_VELOCITY_Y
		move_and_slide()

	# Handle flip jump.
	if Input.is_action_just_pressed("flip_jump") and is_on_floor():
		velocity.y = FLIP_JUMP_VELOCITY_Y
		velocity.x = FLIP_JUMP_VELOCITY_X if facing_direction == -1.0 else -FLIP_JUMP_VELOCITY_X
		move_and_slide()

	# Handle inventory.
	if Input.is_action_just_pressed("inventory") and is_on_floor():
		open_inventory()

	# Handle menu.
	if Input.is_action_just_pressed("menu"):
		open_menu()

	# Handle Aim.
	var aim_direction = Input.get_axis("aim_down", "aim_up")
	if is_on_floor():
		# Aiming up.
		var new_rotation = pivot.rotation_degrees

		if aim_direction > 0:
			new_rotation -= 1 * facing_direction
		elif aim_direction < 0:
			new_rotation += 1 * facing_direction

		pivot.rotation_degrees = clamp(new_rotation, -90, 90)


	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("left", "right")
	if is_on_floor():
		if direction:
			velocity.x = direction * MOVEMENT_SPEED
			facing_direction = direction
		else:
			velocity.x = 0

	alpaco_sprite.flip_h = true if facing_direction == 1.0 else false
	move_and_slide()

func use():
	print("Used la wea")

func open_inventory():
	print("Se abrió la wea de inventario")

func open_menu():
	print("Se abrió la wea de menu")
