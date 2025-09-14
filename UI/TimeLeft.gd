extends Label

var current_int = int(Settings.TURN_DURATION[PlayerMan.phases[PlayerMan.phase_index]]/Settings.game_speed)

func _process(delta):
	if int(%TurnTimer.time_left) <= 10:
		%TimerAnimationPlayer.play("urgent")
	else:
		%TimerAnimationPlayer.play("RESET")
	text = str(int(%TurnTimer.time_left))


func _on_turn_timer_timeout():
	await UIMan.exit_mode(PlayerMan.phases[PlayerMan.phase_index])
	await PlayerMan.go_to_next_turn()
	%TurnTimer.start(Settings.TURN_DURATION[PlayerMan.phases[PlayerMan.phase_index]]/Settings.game_speed)
	
	
