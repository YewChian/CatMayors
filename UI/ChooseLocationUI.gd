extends CanvasLayer

var new_structure : String
var is_placeable : bool
@onready var new_structure_marker_node : Object = get_tree().current_scene.get_node("NewStructureMarker")
@onready var structure_instance_info = get_tree().current_scene.get_node("CommonUI/StructureInstanceInfo")


func initialize():
	new_structure = ""
	new_structure_marker_node.visible = true
	new_structure_marker_node.texture = null
	$TipBox/TurnLabel.text = "CAT CONSTRUCTION"
	$TipBox/Tip.text = "Choose 1 structure to place."
	get_tree().current_scene.get_node("CommonUI/VBoxContainer/Timeline").update_timeline()
	$TipBox/Hand.enable_buttons()
	$TipBox/Hand.update_hand_structure_buttons()
	$TipBox/Hand/VBoxContainer/HBoxContainer.visible = true
	$TipBox/ConfirmLocationButton.visible = false
	
	if PlayerMan.mode == "KittenBot" and PlayerMan.turn_color == "white":
		await get_tree().current_scene.disable_player_input()
		await KittenBot.build_structure()


func choose_location():
	new_structure_marker_node.texture = load(StructureData.structures[new_structure]["sprite"])
	new_structure_marker_node.get_node("EntranceIndicator").position = StructureData.structures[new_structure]["entrance_coordinate"] * Settings.TILE_LENGTH
	new_structure_marker_node.offset = StructureData.structures[new_structure]["sprite_offset"]
	await set_marker_position(Vector2(0,0) + Vector2(get_viewport().size/2))
	await check_placeable()
	
	$TipBox/Tip.text = "Touch tile to place structure."


func on_touched(event):
	if PlayerMan.mode == "KittenBot" and PlayerMan.turn_color == "white":
		return
	var viewport_size : Vector2 = get_viewport().size
	var event_global_position : Vector2 = (event.position-(viewport_size/2))/UIMan.camera.zoom + UIMan.camera.get_screen_center_position()
	var event_tile_coordinate : Vector2
	event_tile_coordinate.x = floor(float(event_global_position.x  + Settings.TILE_LENGTH/2) / Settings.TILE_LENGTH)
	event_tile_coordinate.y = floor(float(event_global_position.y  + Settings.TILE_LENGTH/2) / Settings.TILE_LENGTH)
	
	#if StructureMan.get_structure_by_coordinate(event_tile_coordinate) != null:
		#await structure_instance_info.update_info(StructureMan.get_structure_by_coordinate(event_tile_coordinate))
	
	if new_structure == "":
		return
	await set_marker_position(event.position)
	await check_placeable()
	#await highlight_reachable_tiles()
	
	
func check_placeable():
	is_placeable = true
	await check_color_match()
	await check_entrance_blocker()
	if is_placeable == true:
		$TipBox/Tip.text = "Great location."
		new_structure_marker_node.modulate = Color(1, 1, 1, 0.5)
	else:
		new_structure_marker_node.modulate = Color(1, 0, 0, 0.5)
	
	return is_placeable
	

func check_color_match():
	var structure_color = StructureData.structures[new_structure]["color"]
	var occupied_coordinates = StructureData.structures[new_structure]["occupied_coordinates"]
	for shifted_coordinate in occupied_coordinates:
		if TileMan.get_tile(get_marker_position()/Settings.TILE_LENGTH + shifted_coordinate).color != structure_color:
			is_placeable = false
			$TipBox/Tip.text = "Structure does not match color of covered tiles."
			break


func check_entrance_blocker():
	var all_entrance_coordinates : Array[Vector2] = []
	for structure in StructureMan.structures.values():
		all_entrance_coordinates.push_back(structure.get_global_entrance_coordinate())
		
	var occupied_coordinates = StructureData.structures[new_structure]["occupied_coordinates"]
	for shifted_coordinate in occupied_coordinates:
		for direction in Settings.DIRECTIONS:
			if get_marker_position()/Settings.TILE_LENGTH + shifted_coordinate + direction in all_entrance_coordinates:
					$TipBox/Tip.text = "Don't block the entrances of other buildings."
					is_placeable = false
					break


func set_marker_position(event_position : Vector2):
	var event_tile_coordinate = get_coord_from_event_position(event_position)
	await move_marker_and_make_visible(event_tile_coordinate)

func move_marker_and_make_visible(target_coord):
	new_structure_marker_node.set_visible(true)
	new_structure_marker_node.global_position = (target_coord * Settings.TILE_LENGTH)
	

func get_coord_from_event_position(event_position):
	var viewport_size : Vector2 = get_viewport().size
	var event_global_position : Vector2 = (event_position-(viewport_size/2))/UIMan.camera.zoom + UIMan.camera.get_screen_center_position()
	var event_tile_coordinate : Vector2
	event_tile_coordinate.x = floor(float(event_global_position.x  + Settings.TILE_LENGTH/2) / Settings.TILE_LENGTH)
	event_tile_coordinate.y = floor(float(event_global_position.y  + Settings.TILE_LENGTH/2) / Settings.TILE_LENGTH)
	return event_tile_coordinate


func get_marker_position():
	return new_structure_marker_node.global_position


func end_turn():
	if new_structure == "" or is_placeable == false:
		new_structure_marker_node.visible = false
		return
	
	var new_coordinate = get_marker_position()/Settings.TILE_LENGTH
	await StructureMan.create_structure(new_structure, new_coordinate, PlayerMan.turn_color)
	match PlayerMan.turn_color:
		"black":
			PlayerMan.black_hand.erase(new_structure)
		"white":
			PlayerMan.white_hand.erase(new_structure)
	

func _on_pass_pressed():
	PlayerMan.go_to_next_turn()


# implement when polishing
func highlight_reachable_tiles():
	var origin_coord = StructureData.structures[new_structure]["entrance_coordinate"] + (get_marker_position() / Settings.TILE_LENGTH)

	var dummy_rock = load("res://Structures/Rock.tscn").instantiate()
	get_tree().current_scene.add_child(dummy_rock)
	dummy_rock.global_position = origin_coord * Settings.TILE_LENGTH
	
