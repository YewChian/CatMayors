extends Button

func _on_pressed() -> void:
	Settings.region = 'Grand Whiskertown'
	for button in get_tree().get_nodes_in_group("RegionButtons"):	# reset modulation on all buttons
		button.modulate = Color(1,1,1,0.4)
	modulate = Color(1, 1, 1, 1)
