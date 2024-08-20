extends Button

func _on_pressed():
	UIMan.enter_mode("DraftUI")
	%TurnTimer.start()
