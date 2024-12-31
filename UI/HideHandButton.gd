extends Button

func _on_pressed() -> void:
	match UIMan.mode:
		"DraftUI":
			get_tree().current_scene.get_node("UI/DraftUI/Hand/VBoxContainer/HBoxContainer").visible = !get_tree().current_scene.get_node("UI/DraftUI/Hand/VBoxContainer/HBoxContainer").visible
		"ChooseLocationUI":
			get_tree().current_scene.get_node("UI/ChooseLocationUI/TipBox/Hand/VBoxContainer/HBoxContainer").visible = !get_tree().current_scene.get_node("UI/ChooseLocationUI/TipBox/Hand/VBoxContainer/HBoxContainer").visible
