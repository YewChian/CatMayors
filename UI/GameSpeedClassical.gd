extends Button

func _ready() -> void:
	_on_pressed()
	
func _on_pressed():
	Settings.game_speed = 0.5
	for button in get_tree().get_nodes_in_group("GameSpeedButtons"):	# reset modulation on all buttons
		button.modulate = Color(1,1,1,0.4)
	modulate = Color(1, 1, 1, 1)
