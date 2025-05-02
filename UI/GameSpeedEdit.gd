extends TextEdit



func _on_text_changed() -> void:
	Settings.game_speed = int(text)
