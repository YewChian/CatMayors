extends CanvasLayer

@onready var structure_instance_info = get_tree().current_scene.get_node("CommonUI/StructureInstanceInfo")

func initialize():
	await %Timeline.update_timeline()

	
func on_touched(event):
	pass
	#var viewport_size : Vector2 = get_viewport().size
	#var event_global_position : Vector2 = (event.position-(viewport_size/2))/UIMan.camera.zoom + UIMan.camera.get_screen_center_position()
	#var event_tile_coordinate : Vector2
	#event_tile_coordinate.x = floor(float(event_global_position.x  + Settings.TILE_LENGTH/2) / Settings.TILE_LENGTH)
	#event_tile_coordinate.y = floor(float(event_global_position.y  + Settings.TILE_LENGTH/2) / Settings.TILE_LENGTH)
	#
	#if StructureMan.get_structure_by_coordinate(event_tile_coordinate) != null:
		#await structure_instance_info.update_info(StructureMan.get_structure_by_coordinate(event_tile_coordinate))

func end_turn():
	pass
