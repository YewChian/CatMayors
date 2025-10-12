extends Button


func _on_pressed():
	%TurnTimer.emit_signal("timeout")
	%TurnTimer.start(Settings.TURN_DURATION[PlayerMan.phases[PlayerMan.phase_index]]/Settings.game_speed)
