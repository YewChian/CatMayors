extends TextEdit

func _ready() -> void:
	_on_text_changed()


func _on_text_changed() -> void:
	Settings.game_speed = int(text)
