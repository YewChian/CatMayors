extends Button


func _on_pressed():
	visible = false
	get_tree().paused = false
	get_tree().current_scene.emphasise_turn_label()


func show_next_player_button():
	get_tree().paused = true
	text = PlayerMan.turn_color + "'s turn, click when ready."
	visible = true
