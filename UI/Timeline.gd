extends PanelContainer

var timeline_icon_path = "res://UI/TimelineIcon.tscn"

func update_timeline():
	for child in $VBoxContainer/TimelineHBox.get_children():
		if child.is_in_group("TimelineIcons") == false:
			continue
		child.queue_free()
	var i : int = 0
	for phase in PlayerMan.phases:
		for color in PlayerMan.turn_color_order:
			var new_icon = load(timeline_icon_path).instantiate()
			$VBoxContainer/TimelineHBox.add_child(new_icon)
			match phase:
				"DraftUI":
					new_icon.texture = load("res://Assets/UI/TimelineIcons/Draft.png")
				"ChooseLocationUI":
					new_icon.texture = load("res://Assets/UI/TimelineIcons/Build.png")
				"ObserveUI":
					new_icon.texture = load("res://Assets/UI/TimelineIcons/Observe.png")
			print($VBoxContainer/TimelineHBox.get_children())
			if i == (PlayerMan.phase_index * 2) + PlayerMan.turn_index:
				new_icon.modulate = Color("eb6c82")
			i = (i+1)%(len(PlayerMan.phases)*2)
	%RoundLabel.text = str(PlayerMan.round + 1) + "/" + str(Settings.MAX_ROUNDS)
	
	await outline_active_cat_icon()

	
	%TimeLeftBar.max_value = %TurnTimer.wait_time

func outline_active_cat_icon():
	var scoreboard = %Scoreboard
	var black_normal_texture = load("res://Assets/UI/BlackCatStarIcon.png")
	var black_outlined_texture = load("res://Assets/UI/BlackCatStarIconOutlined.png")
	var white_normal_texture = load("res://Assets/UI/WhiteCatStarIcon.png")
	var white_outlined_texture = load("res://Assets/UI/WhiteCatStarIconOutlined.png")
	match PlayerMan.turn_color:
		"black":
			scoreboard.get_node("BlackCatTexture").texture = black_outlined_texture
			scoreboard.get_node("WhiteCatTexture").texture = white_normal_texture
			scoreboard.get_node("BlackCatTexture").modulate = Color(1,1,1,1)
			scoreboard.get_node("WhiteCatTexture").modulate = Color(1,1,1,0.3)
		"white":
			scoreboard.get_node("BlackCatTexture").texture = black_normal_texture
			scoreboard.get_node("WhiteCatTexture").texture = white_outlined_texture
			scoreboard.get_node("BlackCatTexture").modulate = Color(1,1,1,1)
			scoreboard.get_node("WhiteCatTexture").modulate = Color(1,1,1,0.3)

func emphasise():
	$VBoxContainer/TimelineHBox.visible = !$VBoxContainer/TimelineHBox.visible
	var initial_modulate = $VBoxContainer/TimelineHBox.modulate
	for i in range(3):
		var flash_tween = get_tree().create_tween()
		flash_tween.tween_property($VBoxContainer/TimelineHBox, "modulate", Color(1.5,1.5,1.5,1), 1/Settings.game_speed)
		await flash_tween.finished
		
		var unflash_tween = get_tree().create_tween()
		unflash_tween.tween_property($VBoxContainer/TimelineHBox, "modulate", initial_modulate, 1/Settings.game_speed)
		await unflash_tween.finished
	$VBoxContainer/TimelineHBox.visible = !$VBoxContainer/TimelineHBox.visible

func _process(delta: float) -> void:
	%TimeLeftBar.value = %TurnTimer.time_left

func _on_round_label_pressed() -> void:
	$VBoxContainer/TimelineHBox.visible = !$VBoxContainer/TimelineHBox.visible
