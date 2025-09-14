extends PanelContainer

func update_hand_structure_buttons():
	var current_hand = []
	var structure_node_resource = load("res://Structures/Structure.tscn")
	if PlayerMan.turn_color == "black":
		current_hand = PlayerMan.black_hand
	elif PlayerMan.turn_color == "white":
		current_hand = PlayerMan.white_hand
	var i = 0
	for card in $VBoxContainer/HBoxContainer.get_children():
		card.structure_name = ""
	for card in $VBoxContainer/HBoxContainer.get_children():
		card.visible = true
		if i >= len(current_hand):
			card.visible = false
			continue
		var new_structure_name = current_hand[i]
		var temp_structure_node = structure_node_resource.instantiate()
		await temp_structure_node.initialize_stats(new_structure_name, PlayerMan.turn_color)
		card.initialize("json", temp_structure_node)
		i += 1


func disable_buttons():
	for card in $VBoxContainer/HBoxContainer.get_children():
		card.disable_button()


func enable_buttons():
	for card in $VBoxContainer/HBoxContainer.get_children():
		card.enable_button()
