extends Button

func _on_pressed():
	PlayerMan.mode = "Local"
	for button in get_tree().get_nodes_in_group("GameModeButtons"):	# reset modulation on all buttons
		button.modulate = Color(1,1,1,0.4)
	modulate = Color(1, 1, 1, 1)
