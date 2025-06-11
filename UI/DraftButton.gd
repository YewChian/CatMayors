extends Button

func _on_pressed():
	PlayerMan.mode = "Local"
	get_tree().current_scene.show_tutorial("title")
	get_tree().paused = true
