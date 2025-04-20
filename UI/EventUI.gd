extends CanvasLayer

func initialize():
	await %Timeline.update_timeline()
	get_node("EventPanelContainer").visible = true


func transform_purple_tiles_into(new_color: String):
	var num_tiles = 5 
	var purple_tile_coordinates = []
	for tile in TileMan.tiles.values():
		if tile.color == "purple":
			purple_tile_coordinates.push_back(tile.coordinate)
	randomize()
	purple_tile_coordinates.shuffle()
	purple_tile_coordinates = purple_tile_coordinates.slice(0,num_tiles)
	for coord in purple_tile_coordinates:
		transform_tile_into(new_color, coord)


func transform_tile_into(color: String, coord: Vector2):
	var cross = load("res://UI/RedCrossOnTile.tscn").instantiate()
	get_tree().current_scene.add_child(cross)
	cross.global_position = coord * Settings.TILE_LENGTH
	var num_flashes = 3
	for i in range(num_flashes):
		print("flashing")
		cross.visible = false
		await get_tree().create_timer(1).timeout
		cross.visible = true
		await get_tree().create_timer(1).timeout
	cross.queue_free()
	TileMan.create_tile(color, coord)

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
