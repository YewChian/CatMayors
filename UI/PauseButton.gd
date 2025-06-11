extends Button



func _on_pressed() -> void:
	get_tree().current_scene.show_tutorial("match")
	get_tree().paused = !get_tree().paused
	#if text == "Pause/Help":
		#text = "Resume"
	#else:
		#text = "Pause/Help"
