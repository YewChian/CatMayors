extends PanelContainer


func update_timeline():
	for child in $VBoxContainer/TimelineHBox.get_children():
		child.queue_free()
	var i : int = 0
	for phase in PlayerMan.phases:
		for color in PlayerMan.turn_color_order:
			var new_label = Label.new()
			$VBoxContainer/TimelineHBox.add_child(new_label)
			new_label.add_theme_font_size_override("font_size", 12)
			new_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			match phase:
				"DraftUI":
					new_label.text = color + "'s \nblueprint\nshop"
				"ChooseLocationUI":
					new_label.text = color + "'s \nconstruction"
				"ObserveUI":
					new_label.text = color + "'s \nobservation"
					
			if i == (PlayerMan.phase_index * 2) + PlayerMan.turn_index:
				new_label.modulate = Color("eb6c82")
			i = (i+1)%(len(PlayerMan.phases)*2)
	%RoundLabel.text = "Round " + str(PlayerMan.round + 1) + "/" + str(Settings.MAX_ROUNDS)


func _on_round_label_pressed() -> void:
	$VBoxContainer/TimelineHBox.visible = !$VBoxContainer/TimelineHBox.visible
