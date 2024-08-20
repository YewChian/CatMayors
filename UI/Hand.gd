extends PanelContainer

func update_hand_structure_buttons():
	var current_hand = []
	if PlayerMan.turn_color == "black":
		current_hand = PlayerMan.black_hand
	elif PlayerMan.turn_color == "white":
		current_hand = PlayerMan.white_hand
	var i = 0
	for card in $VBoxContainer/HBoxContainer.get_children():
		card.structure_path = ""
	for card in $VBoxContainer/HBoxContainer.get_children():
		card.visible = true
		if i >= len(current_hand):
			card.visible = false
			continue
		card.initialize(current_hand[i])
		i += 1


func disable_buttons():
	for card in $VBoxContainer/HBoxContainer.get_children():
		card.disable_button()


func enable_buttons():
	for card in $VBoxContainer/HBoxContainer.get_children():
		card.enable_button()
