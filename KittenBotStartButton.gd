extends Button

func _on_pressed():
	PlayerMan.mode = "KittenBot"
	%CommonUI.visible = true
	await PlayerMan.add_initial_structures_to_hand()
	UIMan.enter_mode("DraftUI")
	%TurnTimer.start(Settings.TURN_DURATION)
