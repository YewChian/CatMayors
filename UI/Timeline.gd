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
				"EventUI":
					new_label.text = color + "'s \nlandscaping"
					
			if i == (PlayerMan.phase_index * 2) + PlayerMan.turn_index:
				new_label.modulate = Color("eb6c82")
			i = (i+1)%(len(PlayerMan.phases)*2)
	%RoundLabel.text = "Round " + str(PlayerMan.round + 1) + "/" + str(Settings.MAX_ROUNDS)

func emphasise():
	$VBoxContainer/TimelineHBox.visible = !$VBoxContainer/TimelineHBox.visible
	var initial_modulate = $VBoxContainer/TimelineHBox.modulate
	for i in range(3):
		print("flashing")
		var flash_tween = get_tree().create_tween()
		flash_tween.tween_property($VBoxContainer/TimelineHBox, "modulate", Color(1.5,1.5,1.5,1), 1/Settings.game_speed)
		await flash_tween.finished
		
		print("unflashing")
		var unflash_tween = get_tree().create_tween()
		unflash_tween.tween_property($VBoxContainer/TimelineHBox, "modulate", initial_modulate, 1/Settings.game_speed)
		await unflash_tween.finished
	$VBoxContainer/TimelineHBox.visible = !$VBoxContainer/TimelineHBox.visible


func _on_round_label_pressed() -> void:
	$VBoxContainer/TimelineHBox.visible = !$VBoxContainer/TimelineHBox.visible
