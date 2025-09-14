extends Button


func _on_pressed() -> void:
	if PlayerMan.mode != "DuelingBot":
		printerr("not in DuelingBot mode, ignoring button press")
		return
	
	await MouseketeerBot.save_q_table()
