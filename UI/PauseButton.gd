extends Button



func _on_pressed() -> void:
	get_tree().current_scene.get_node("CommonUI/PauseMenu").visible = !get_tree().current_scene.get_node("CommonUI/PauseMenu").visible
	get_tree().paused = !get_tree().paused
	if text == "Pause/Help":
		text = "Resume"
	else:
		text = "Pause/Help"
