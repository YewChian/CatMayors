extends CanvasLayer

var new_structure : Resource
var is_placeable : bool
@onready var new_structure_marker_node : Object = get_tree().current_scene.get_node("NewStructureMarker")

func initialize():
	new_structure = null
	new_structure_marker_node.texture = null
	$TipBox/TurnLabel.text = str(PlayerMan.turn_color) + "'s turn."
	$TipBox/Tip.text = "Choose 1 structure to place."
	get_tree().current_scene.get_node("CommonUI/VBoxContainer/Timeline").update_timeline()
	$Hand.enable_buttons()
	$Hand.update_hand_structure_buttons()


func choose_location():
	var structure_to_place = new_structure.instantiate()
	new_structure_marker_node.texture = structure_to_place.get_node("Sprite2D").texture
	new_structure_marker_node.offset = structure_to_place.get_node("Sprite2D").offset
	structure_to_place.initialize_stats()
	new_structure_marker_node.get_node("EntranceIndicator").position = structure_to_place.entrance_coordinate * Settings.TILE_LENGTH
	await set_marker_position(Vector2(0,0) + Vector2(get_viewport().size/2))
	await check_placeable()
	
	$TipBox/Tip.text = "Touch tile to place structure."
	
	

func on_touched(event):
	if new_structure == null:
		return
	await set_marker_position(event.position)
	await check_placeable()


func check_placeable():
	is_placeable = true
	await check_color_match()
	await check_entrance_blocker()
	if is_placeable == true:
		$TipBox/Tip.text = "Great location."
		new_structure_marker_node.modulate = Color(1, 1, 1, 0.5)
	else:
		new_structure_marker_node.modulate = Color(1, 0, 0, 0.5)
	

func check_color_match():
	var structure_to_place = new_structure.instantiate()
	await structure_to_place.initialize_stats()
	for shifted_coordinate in structure_to_place.occupied_coordinates:
		if TileMan.get_tile(get_marker_position()/Settings.TILE_LENGTH + shifted_coordinate).color != structure_to_place.color:
			is_placeable = false
			$TipBox/Tip.text = "Structure does not match color of covered tiles."
			break


func check_entrance_blocker():
	var all_entrance_coordinates : Array[Vector2] = []
	for structure in StructureMan.structures.values():
		all_entrance_coordinates.push_back(structure.get_global_entrance_coordinate())
	
	var structure_to_place = new_structure.instantiate()
	await structure_to_place.initialize_stats()
	for shifted_coordinate in structure_to_place.occupied_coordinates:
		for direction in Settings.DIRECTIONS:
			if get_marker_position()/Settings.TILE_LENGTH + shifted_coordinate + direction in all_entrance_coordinates:
					$TipBox/Tip.text = "Don't block the entrances of other buildings."
					is_placeable = false
					break


func set_marker_position(event_position : Vector2):
	new_structure_marker_node.set_visible(true)
	var viewport_size : Vector2 = get_viewport().size
	var event_global_position : Vector2 = (event_position-(viewport_size/2))/UIMan.camera.zoom + UIMan.camera.get_screen_center_position()
	var event_tile_coordinate : Vector2
	event_tile_coordinate.x = floor(float(event_global_position.x  + Settings.TILE_LENGTH/2) / Settings.TILE_LENGTH)
	event_tile_coordinate.y = floor(float(event_global_position.y  + Settings.TILE_LENGTH/2) / Settings.TILE_LENGTH)
	new_structure_marker_node.global_position = (event_tile_coordinate * Settings.TILE_LENGTH)
	

func get_marker_position():
	return new_structure_marker_node.global_position


func end_turn():
	if new_structure == null or is_placeable == false:
		return
	
	var new_coordinate = get_marker_position()/Settings.TILE_LENGTH
	await StructureMan.create_structure(new_structure, new_coordinate)
	match PlayerMan.turn_color:
		"black":
			PlayerMan.black_hand.erase(new_structure.resource_path)
		"white":
			PlayerMan.white_hand.erase(new_structure.resource_path)
	


func _on_pass_pressed():
	PlayerMan.go_to_next_turn()
