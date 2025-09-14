extends Node2D

func _ready():
	create_map(Settings.SIZE, Settings.GREEN_EXPANSION_PROBABILITY)
	
func disable_player_input():
	await set_process_input(false)

func add_to_log(new_line: String):
	%Log.text = new_line

func create_map(size : int, expansion_probability : float):
	await TileMan.initialize_tile_dictionary(size)
	var max_num_green_tiles : int = size * 0.3
	var max_num_blue_tiles : int = size - max_num_green_tiles
	var min_num_green_tiles : int = 10
	var num_green_tiles : int = 0
	var num_blue_tiles : int = 0
	var num_purple_tiles: int = 0
	
	# Create grass tiles to fill the area specified
	print("grass")
	var potential_green_tile_coordinates : Array[Vector2] = [Vector2(0,0)]
	for coordinate in potential_green_tile_coordinates:
		await TileMan.create_tile("green", coordinate)
		num_green_tiles += 1
		if num_green_tiles >= max_num_green_tiles:
			break
		for neighbor_tile in TileMan.get_neighbor_tiles(TileMan.get_tile(coordinate)).values():
			if neighbor_tile.color == "green":
				continue
			if randf_range(0,1.0) > expansion_probability and num_green_tiles >= min_num_green_tiles:
				continue
			potential_green_tile_coordinates.push_back(neighbor_tile.coordinate)
	
	# create blue tiles
	print("water")
	var potential_blue_tile_coordinates : Array[Vector2] = []
	for tile in TileMan.tiles.values():
		if tile.color != "green":
			continue
		for neighbor_tile in TileMan.get_neighbor_tiles(tile).values():	# replace with blue
			if neighbor_tile.color != "null":
				continue
			potential_blue_tile_coordinates.push_back(neighbor_tile.coordinate)

	for coordinate in potential_blue_tile_coordinates:
		await TileMan.create_tile("blue", coordinate)
		num_blue_tiles += 1
		if num_blue_tiles >= max_num_blue_tiles:
			break
		for neighbor_tile in TileMan.get_neighbor_tiles(TileMan.get_tile(coordinate)).values():
			if neighbor_tile.color != "null":
				continue
			potential_blue_tile_coordinates.push_back(neighbor_tile.coordinate)

	# create hills
	print("hills")
	var max_num_red_tiles : int = max_num_green_tiles / 2
	var num_red_tiles = 0
	var green_tile_coordinates : Array[Vector2] = []
	var red_tile_coordinates : Array[Vector2] = []
	for tile in TileMan.tiles.values():
		if tile.color == "green":
			green_tile_coordinates.push_back(tile.coordinate)
	

	
	var num_origin_red_tiles : int = max_num_red_tiles / 10
	for i in num_origin_red_tiles:
		var random_index = randi_range(0, len(green_tile_coordinates)-1)
		var coordinate_to_replace = green_tile_coordinates[random_index]
		green_tile_coordinates.erase(coordinate_to_replace)
		await TileMan.create_tile("red", coordinate_to_replace)
		num_red_tiles += 1
		for direction in Settings.DIRECTIONS:
			red_tile_coordinates.push_back(coordinate_to_replace + direction)
	
	for coordinate in red_tile_coordinates:
		if num_red_tiles >= max_num_red_tiles:
			break
		randomize()
		if randf_range(0.0,1.0) > Settings.RED_EXPANSION_PROBABILITY:
			continue
		await TileMan.create_tile("red", coordinate)
		num_red_tiles += 1
		for direction in Settings.DIRECTIONS:
			red_tile_coordinates.push_back(coordinate + direction)
			
	print("fishbones")
	var max_num_purple_tiles : int = max_num_green_tiles / 8
	var red_and_green_tiles = red_tile_coordinates.duplicate(true)
	red_and_green_tiles.append_array(green_tile_coordinates)
	randomize()
	red_and_green_tiles.shuffle()
	for coord in red_and_green_tiles.slice(0, max_num_purple_tiles):
		await TileMan.create_tile("purple", coord)
	
	await TileMan.connect_tiles(TileMan.tiles.keys())

func _on_generate_map_pressed():
	create_map(Settings.SIZE, Settings.GREEN_EXPANSION_PROBABILITY)

func show_tutorial(base_screen: String):
	%PauseMenu.visible = true
	for node in %PauseMenu/MarginContainer.get_children():
		node.visible = false
	var tutorial_node = get_node("PauseMenu/MarginContainer/Tutorial")
	tutorial_node.visible = true
	tutorial_node.called_from = base_screen

func hide_tutorial():
	var tutorial_node = get_node("PauseMenu/MarginContainer/Tutorial")
	tutorial_node.visible = false
	%PauseMenu.visible = false
	get_tree().paused = false

func start_game():
	%CommonUI.visible = true
	get_tree().current_scene.get_node("CommonUI/VBoxContainer").visible = true
	await PlayerMan.add_initial_structures_to_hand()
	UIMan.enter_mode("DraftUI")
	%TurnTimer.start(Settings.TURN_DURATION[PlayerMan.phases[PlayerMan.phase_index]]/Settings.game_speed)
	get_tree().current_scene.get_node("CommonUI/VBoxContainer/HBoxContainer/WhoseTurnLabel").text = PlayerMan.turn_color + "'s turn"
	print("Common UI visiblity: ", %CommonUI.visible)
	%Timeline.emphasise()
	emphasise_turn_label()


func emphasise_turn_label():
	var turn_label = %WhoseTurnLabel
	var original_color = Color(1, 1, 1, 1)
	var flash_color = Color(1, 1.5, 1, 1)
	var tween
	for i in range(5):
		tween = get_tree().create_tween()
		tween.tween_property(turn_label, "modulate", flash_color, 0.5/Settings.game_speed)
		await tween.finished
		tween.kill()
		tween = get_tree().create_tween()
		tween.tween_property(turn_label, "modulate", original_color, 0.5/Settings.game_speed)
		await tween.finished
		tween.kill()
