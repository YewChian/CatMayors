extends CanvasLayer

func initialize():
	await %Timeline.update_timeline()
	get_node("EventPanelContainer").visible = true

	if PlayerMan.mode == "KittenBot" and PlayerMan.turn_color == "white":
		await get_tree().current_scene.disable_player_input()
		await KittenBot.choose_purple_tile_replacements()

	if PlayerMan.mode == "DuelingBot" and PlayerMan.turn_color == "white":
		await get_tree().current_scene.disable_player_input()
		await MouseketeerBot.choose_purple_tile_replacements()

	if PlayerMan.mode == "DuelingBot" and PlayerMan.turn_color == "black":
		await get_tree().current_scene.disable_player_input()
		await GreywhiskersBot.choose_purple_tile_replacements()

func transform_purple_tiles_into(new_color: String):
	var num_tiles = 10
	var purple_tile_coordinates = []
	for tile in TileMan.coord2tile.values():
		if tile.color == "purple":
			purple_tile_coordinates.push_back(tile.coordinate)
	randomize()
	purple_tile_coordinates.shuffle()
	purple_tile_coordinates = purple_tile_coordinates.slice(0,num_tiles)
	for coord in purple_tile_coordinates:
		transform_tile_into(new_color, coord)
	get_tree().current_scene.get_node("CommonUI/VBoxContainer/HBoxContainer/TimeLeft")._on_turn_timer_timeout()


func transform_tile_into(color: String, coord: Vector2):
	var cross = load("res://UI/RedCrossOnTile.tscn").instantiate()
	get_tree().current_scene.add_child(cross)
	cross.global_position = coord * Settings.TILE_LENGTH
	var num_flashes = 3
	for i in range(num_flashes):
		cross.visible = false
		await get_tree().create_timer(0.3/Settings.game_speed).timeout
		cross.visible = true
		await get_tree().create_timer(0.3/Settings.game_speed).timeout
	cross.queue_free()
	TileMan.create_tile(color, coord)
	await get_tree().create_timer(2/Settings.game_speed).timeout

func end_turn():
	pass

func on_touched(event):
	pass

func _on_green_tiles_button_pressed() -> void:
	get_node("EventPanelContainer").visible = false
	await transform_purple_tiles_into("green")


func _on_red_tiles_button_pressed() -> void:
	get_node("EventPanelContainer").visible = false
	await transform_purple_tiles_into("red")


func _on_blue_tiles_button_pressed() -> void:
	get_node("EventPanelContainer").visible = false
	await transform_purple_tiles_into("blue")
