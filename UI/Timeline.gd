extends PanelContainer


func update_timeline():
	for child in $HBoxContainer.get_children():
		child.queue_free()
	var i : int = 0
	for phase in PlayerMan.phases:
		for color in PlayerMan.turn_color_order:
			var new_label = Label.new()
			$HBoxContainer.add_child(new_label)
			match phase:
				"DraftUI":
					new_label.text = color + "'s Draft"
				"ChooseLocationUI":
					new_label.text = color + "'s Placement"
			if i == (PlayerMan.phase_index * 2) + PlayerMan.turn_index:
				new_label.modulate = Color("a03f00")
			i = (i+1)%(len(PlayerMan.phases)*2)
