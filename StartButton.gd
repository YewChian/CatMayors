extends Button

func _on_pressed() -> void:
	get_tree().current_scene.show_tutorial("title")
