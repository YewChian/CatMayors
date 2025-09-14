extends Button

func _on_pressed():
	PlayerMan.mode = "DuelingBot"
	#await MouseketeerBot.initialize_q_table("create")
	#await GreywhiskersBot.initialize_q_table("create")
	await MouseketeerBot.initialize_q_table("load")
	await GreywhiskersBot.initialize_q_table("load")
	await StructureMan.set_name2staticid()
	#print(MouseketeerBot.actionname2index)
	%CommonUI.visible = true
	await PlayerMan.add_initial_structures_to_hand()
	UIMan.enter_mode("DraftUI")
	%TurnTimer.start(Settings.TURN_DURATION[PlayerMan.phases[PlayerMan.phase_index]]/Settings.game_speed)
	get_tree().current_scene.get_node("CommonUI/VBoxContainer/HBoxContainer/WhoseTurnLabel").text = PlayerMan.turn_color + "'s turn"
