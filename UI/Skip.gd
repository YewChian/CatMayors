extends Button


func _on_pressed():
	%TurnTimer.emit_signal("timeout")
	%TurnTimer.start(20)
