extends Camera2D


const DEAD_ZONE: int = 140
@onready var alpaca = $"../Alpaca"

func _process(_delta) -> void:

	self.position = alpaca.position
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var target = -event.relative
		self.position = alpaca.position + target.normalized() * (target.length() - DEAD_ZONE) 
	else:
		pass
