extends Label


func _process(delta):
	text = "Time left: " + str(int(%TurnTimer.time_left))


func _on_turn_timer_timeout():
	await UIMan.exit_mode(PlayerMan.phases[PlayerMan.phase_index])
	await PlayerMan.go_to_next_turn()
	%TurnTimer.start()
