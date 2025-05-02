extends Button

func _on_pressed():
	PlayerMan.mode = "DuelingBot"
	# await MouseketeerBot.initialize_q_table("create")
	await MouseketeerBot.initialize_q_table("load")
	await GreywhiskersBot.initialize_q_table("load")
	await StructureMan.set_name2staticid()
	#print(MouseketeerBot.actionname2index)
	%CommonUI.visible = true
	await PlayerMan.add_initial_structures_to_hand()
	UIMan.enter_mode("DraftUI")
	%TurnTimer.start(Settings.TURN_DURATION/Settings.game_speed)
