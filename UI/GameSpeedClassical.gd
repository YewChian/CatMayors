extends Button

func _ready() -> void:
	_on_pressed()
	
	
func _on_pressed():
	Settings.game_speed = 0.5
