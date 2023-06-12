extends Camera2D


@onready var target = $".."

func _process(_delta) -> void:
	self.position = target.get_node("Alpaca").position
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var tween = create_tween()
		tween.tween_property(self, "position", event.position, 0.5)
