extends Control


@onready var wind_left_bar := $WindLeftBar
@onready var wind_right_bar := $WindRightBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	# Initialize UI for the first time
	var current_wind: int =  GameState.obtain_wind_strenght()
	update_ui(current_wind)

	# Connect wind_changed to update_ui
	GameState.wind_changed.connect(update_ui)

func update_ui(cur_wnd: int) -> void:
	match cur_wnd:
		-2:
			wind_left_bar.value = 2
			wind_right_bar.value = 0
		-1:
			wind_left_bar.value = 1
			wind_right_bar.value = 0
		0:
			wind_left_bar.value = 0
			wind_right_bar.value = 0
		1:
			wind_left_bar.value = 0
			wind_right_bar.value = 1
		2:
			wind_left_bar.value = 0
			wind_right_bar.value = 2
		_:
			print("Not possible.")
