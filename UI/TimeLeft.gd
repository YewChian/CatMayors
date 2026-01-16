extends Timer

func _on_timeout() -> void:
	await UIMan.exit_mode(PlayerMan.phases[PlayerMan.phase_index])
	await PlayerMan.go_to_next_turn()
	%TurnTimer.start(Settings.TURN_DURATION[PlayerMan.phases[PlayerMan.phase_index]]/Settings.game_speed)
