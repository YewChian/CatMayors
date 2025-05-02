extends Button


func _on_pressed():
	%TurnTimer.emit_signal("timeout")
	%TurnTimer.start(Settings.TURN_DURATION/Settings.game_speed)
