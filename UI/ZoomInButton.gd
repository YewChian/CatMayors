extends Button


func _on_pressed() -> void:
	get_tree().current_scene.get_node("Camera2D").zoom += Vector2(0.1, 0.1)
