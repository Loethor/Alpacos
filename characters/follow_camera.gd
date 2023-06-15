extends Camera2D

const CAMERA_MOVEMENT_TIME:= 0.25
@onready var target := $".."

func _input(event: InputEvent) -> void:

	# Handle camera movement
	if event is InputEventMouseMotion:
		var tween = create_tween()
		tween.tween_property(self, "global_position", event.position, CAMERA_MOVEMENT_TIME)

	# Handle center camera
	if event.is_action_pressed("center_camera"):
		global_position = target.global_position
