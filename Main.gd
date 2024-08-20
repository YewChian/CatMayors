extends Node2D

func create_map(size : int, expansion_probability : float):
	await TileMan.initialize_tile_dictionary(size)
	var max_num_green_tiles : int = size * 0.3
	var max_num_blue_tiles : int = size - max_num_green_tiles
	var min_num_green_tiles : int = 10
	var num_green_tiles : int = 0
	var num_blue_tiles : int = 0
	
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
	var max_num_red_tiles : int = max_num_green_tiles / 10
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
	
	await TileMan.connect_tiles(TileMan.tiles.keys())

func _on_generate_map_pressed():
	create_map(Settings.SIZE, Settings.GREEN_EXPANSION_PROBABILITY)
