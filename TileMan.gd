extends Node2D
var tiles : Dictionary = {}
var coordinate_to_id : Dictionary = {}
@onready var astar = AStar2D.new() 
var current_id : int = 0

const TILE_SCENES : Dictionary = {
	"green" : preload("res://Tiles/GreenTile.tscn"),
	"blue" : preload("res://Tiles/BlueTile.tscn"),
	"red" : preload("res://Tiles/RedTile.tscn"),
	#"grey" : preload("res://Tiles/GreyTile.tscn"),
	"null" : preload("res://Tiles/NullTile.tscn"),
	"white" : preload("res://Tiles/WhiteTile.tscn")
}


func initialize_tile_dictionary(num_green_tiles : int):
	var absolute_bounds : int = sqrt(num_green_tiles)
	print("absolute_bounds: ", absolute_bounds)
	for i in range(-absolute_bounds, absolute_bounds):
		for j in range(-absolute_bounds, absolute_bounds):
			create_tile("null", Vector2(i,j))
			

func create_tile(color : String, coordinate : Vector2):
	if get_tile(coordinate) != null:
		await remove_tile(coordinate)
	var new_tile = TILE_SCENES[color].instantiate()
	new_tile.color = color
	new_tile.coordinate = coordinate
	set_tile(coordinate, new_tile, current_id)
	get_tree().current_scene.get_node("Tiles").add_child(new_tile)
	new_tile.global_position = coordinate * Settings.TILE_LENGTH
	match color:
		"green":
			astar.add_point(current_id, coordinate, 1)
			current_id += 1
		"red":
			astar.add_point(current_id, coordinate, 2)
			current_id += 1
		"blue":
			astar.add_point(current_id, coordinate, 1)
			current_id += 1
		"null":
			astar.add_point(current_id, coordinate, 999)
			current_id += 1
		"white":
			astar.add_point(current_id, coordinate, 1)
			current_id += 1
		"_":
			printerr("create_tile error: color of tile not found")
		

func remove_tile(coordinate):
	astar.remove_point(get_id(coordinate))
	get_tile(coordinate).queue_free()
	

func get_tile(coordinate : Vector2):
	if tiles.has(coordinate) == false:
		return null
	else:
		return tiles[coordinate]
	
func get_id(coordinate : Vector2):
	return coordinate_to_id[coordinate]


func set_tile(coordinate : Vector2, tile : Object, new_id : int):
	tiles[coordinate] = tile
	coordinate_to_id[coordinate] = new_id


func get_neighbor_tiles(current_tile : Object):
	# returns dictionary of neighboring tiles
	var neighbor_tiles : Dictionary
	for direction in Settings.DIRECTIONS:
		var new_tile_coordinate : Vector2 = current_tile.coordinate + direction
		if abs(new_tile_coordinate.x) >= Settings.SIZE or abs(new_tile_coordinate.y) >= Settings.SIZE: # boundary tile
			continue
			
		neighbor_tiles[direction] = get_tile(new_tile_coordinate)
	return neighbor_tiles


func connect_tiles(origin_tiles : Array):
	for coordinate in origin_tiles:
		if get_tile(coordinate).color == "blue" or get_tile(coordinate).color == "null":
			continue
		for direction in Settings.DIRECTIONS:
			if get_tile(coordinate+direction).color == "blue" or get_tile(coordinate).color == "null":
				continue
			if astar.are_points_connected(get_id(coordinate), get_id(coordinate+direction)) == true:
				continue
			astar.connect_points(get_id(coordinate), get_id(coordinate+direction))
