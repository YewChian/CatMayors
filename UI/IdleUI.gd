extends CanvasLayer


func initialize():
	pass
	
	
func on_touched(event):
	var event_tile_coordinate : Vector2 = get_event_tile_coordinate(event)
	var target_cat = CatMan.get_cat_from_coordinate(event_tile_coordinate)
	if target_cat != null:
		update_cat_info(target_cat)
	var target_structure = StructureMan.get_structure_by_coordinate(event_tile_coordinate)
	if target_structure != null:
		update_structure_info(target_structure)
	

func get_event_tile_coordinate(event):
	var viewport_size : Vector2 = get_viewport().size
	var event_global_position : Vector2 = (event.position-(viewport_size/2))/UIMan.camera.zoom + UIMan.camera.get_screen_center_position()
	var event_tile_coordinate : Vector2
	event_tile_coordinate.x = floor(float(event_global_position.x  + Settings.TILE_LENGTH/2) / Settings.TILE_LENGTH)
	event_tile_coordinate.y = floor(float(event_global_position.y  + Settings.TILE_LENGTH/2) / Settings.TILE_LENGTH)
	return event_tile_coordinate


func update_cat_info(cat: Object):
	%CatTexture.texture = cat.get_node("Sprite2D").texture
	%NameLabel.text = str(cat.id)
	%CuriosityLabel.text = str(cat.curiosity)
	%SnacksLabel.text = str(cat.snacks)
	%TricksLabel.text = str(cat.tricks)
	%NapsLabel.text = str(cat.naps)


func update_structure_info(structure: Object):
	%BuildingTexture.texture = structure.get_node("Sprite2D").texture
	%BuildingNameLabel.text = str(structure.structure_name)
	%TilesLabel.text = str(structure.color)
	%BuildingSnacksLabel.text = str(structure.snacks)
	%BuildingTricksLabel.text = str(structure.tricks)
	%BuildingNapsLabel.text = str(structure.naps)
	%NapStarsLabel.text = str(structure.nap_stars)
	%SnackStarsLabel.text = str(structure.snack_stars)
	%TrickStarsLabel.text = str(structure.trick_stars)
