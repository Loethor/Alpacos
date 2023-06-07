extends CharacterBody2D

enum DIRECTION {LEFT, RIGHT}

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

var previous_facing_direction: DIRECTION = DIRECTION.LEFT
var facing_direction: DIRECTION = DIRECTION.LEFT

@onready var alpaco_sprite:Sprite2D = $AlpacoSprite
@onready var aim_sprite:Sprite2D = $AimSprite


func _physics_process(delta):

	# Add the gravity and the air friction.
	if not is_on_floor():
		velocity.y += gravity * delta
		velocity.x = move_toward(velocity.x, 0, AIR_FRICTION)

	# All the actions that can be performed on the exclusively on the floor
	if is_on_floor():

		# Handle forward jump.
		if Input.is_action_just_pressed("forward_jump"):
			velocity.y = FORWARD_JUMP_VELOCITY_Y
			velocity.x = FORWARD_JUMP_VELOCITY_X if facing_direction == DIRECTION.RIGHT else -FORWARD_JUMP_VELOCITY_X
			move_and_slide()

		# Handle in-place jump.
		if Input.is_action_just_pressed("in_place_jump"):
			velocity.y = IN_PLACE_JUMP_VELOCITY_Y
			move_and_slide()

		# Handle flip jump.
		if Input.is_action_just_pressed("flip_jump"):
			velocity.y = FLIP_JUMP_VELOCITY_Y
			velocity.x = FLIP_JUMP_VELOCITY_X if facing_direction == DIRECTION.RIGHT else -FLIP_JUMP_VELOCITY_X
			move_and_slide()

		# Handle inventory.
		if Input.is_action_just_pressed("inventory"):
			open_inventory()

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

	# Handle use.
	if Input.is_action_just_pressed("use"):
		use()


	move_and_slide()

func use():
	print("Used la wea")

func open_inventory():
	print("Se abrió la wea de inventario")

func open_menu():
	print("Se abrió la wea de menu")
