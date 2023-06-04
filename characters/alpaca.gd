extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -250.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle use.
	if Input.is_action_just_pressed("use"):
		use()

	# Handle jump.
	if Input.is_action_just_pressed("forward_jump") and is_on_floor():
		velocity = Vector2.ZERO
		move_and_slide()
		velocity.y = JUMP_VELOCITY
		velocity.x = JUMP_VELOCITY 
		
	# Handle inventory.
	if Input.is_action_just_pressed("inventory") and is_on_floor():
		open_inventory()
		
	# Handle menu.
	if Input.is_action_just_pressed("menu"):
		open_menu()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if is_on_floor():
		var direction = Input.get_axis("left", "right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func use():
	print("Used la wea")

func open_inventory():
	print("Se abrió la wea de inventario")
	
func open_menu():
	print("Se abrió la wea de menu")
