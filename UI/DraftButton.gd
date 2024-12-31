extends Button

func _on_pressed():
	%CommonUI.visible = true
	UIMan.enter_mode("DraftUI")
	%TurnTimer.start(Settings.TURN_DURATION)
