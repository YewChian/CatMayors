extends Button

func _on_pressed():
	PlayerMan.mode = "KittenBot"
	get_tree().current_scene.show_tutorial("title")
	get_tree().paused = true
