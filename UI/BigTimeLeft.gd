extends Label


func _process(delta):
	text = str(int(%TurnTimer.time_left))
