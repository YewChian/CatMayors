extends CanvasLayer

var new_tile : Resource
var is_placeable : bool
@onready var new_tile_marker_node : Object = get_tree().current_scene.get_node("NewTileMarker")

func initialize():
	var tile_to_place = new_tile.instantiate()
	new_tile_marker_node.texture = tile_to_place.get_node("Sprite2D").texture
	new_tile_marker_node.offset = tile_to_place.get_node("Sprite2D").offset
	await set_marker_position(Vector2(0,0) + Vector2(get_viewport().size/2))
	await check_placeable()
	
	
	$TipPanelContainer/Tip.text = "Touch tile to place tile."
	

func on_touched(event):
	await set_marker_position(event.position)
	await check_placeable()


func check_placeable():
	is_placeable = true
	$AcceptContainer/Confirm.set_disabled(true)
	await check_not_null_tile()
	await check_not_entrance()
	if is_placeable == true:
		$TipPanelContainer/Tip.text = "Great location."
		$AcceptContainer/Confirm.set_disabled(false)
	

func check_not_null_tile():
	if TileMan.get_tile(get_marker_position()/Settings.TILE_LENGTH).color == "null":
		is_placeable = false
		$TipPanelContainer/Tip.text = "black tiles cannot be replaced."


func check_not_entrance():
	for structure in StructureMan.structures.values():
		if get_marker_position()/Settings.TILE_LENGTH == structure.get_global_entrance_coordinate():
			is_placeable = false
			$TipPanelContainer/Tip.text = "can't change tiles on structure entrances"
			break


func set_marker_position(event_position : Vector2):
	new_tile_marker_node.set_visible(true)
	var viewport_size : Vector2 = get_viewport().size
	var event_global_position : Vector2 = (event_position-(viewport_size/2))/UIMan.camera.zoom + UIMan.camera.get_screen_center_position()
	var event_tile_coordinate : Vector2
	event_tile_coordinate.x = floor(float(event_global_position.x  + Settings.TILE_LENGTH/2) / Settings.TILE_LENGTH)
	event_tile_coordinate.y = floor(float(event_global_position.y  + Settings.TILE_LENGTH/2) / Settings.TILE_LENGTH)
	new_tile_marker_node.global_position = (event_tile_coordinate * Settings.TILE_LENGTH)
	

func get_marker_position():
	return new_tile_marker_node.global_position


func _on_confirm_pressed():
	var new_coordinate = get_marker_position()/Settings.TILE_LENGTH
	var tile_name = str(new_tile.instantiate().name)
	var tile_color = tile_name.erase(len(tile_name)-4, 4).to_lower()
	await TileMan.create_tile(tile_color, new_coordinate)
	await TileMan.connect_tiles([new_coordinate])
	UIMan.enter_mode("IdleUI")


func _on_cancel_pressed():
	new_tile_marker_node.set_visible(false)
	UIMan.enter_mode("IdleUI")
