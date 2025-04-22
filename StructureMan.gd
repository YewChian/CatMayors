extends Node

var structures : Dictionary
var current_id = 0
@onready var structure_resource = preload("res://Structures/Structure.tscn")

func create_structure(structure_name: String, coordinate: Vector2, team_color: String):
	var new_instantiated_structure = structure_resource.instantiate()
	get_tree().current_scene.get_node("Structures").add_child(new_instantiated_structure)
	new_instantiated_structure.global_position = coordinate * Settings.TILE_LENGTH
	new_instantiated_structure.coordinate = coordinate
	new_instantiated_structure.id = current_id
	structures[current_id] = new_instantiated_structure
	current_id += 1
	
	await new_instantiated_structure.initialize_stats(structure_name, team_color)
	new_instantiated_structure.get_node("EntranceIndicator").position = new_instantiated_structure.entrance_coordinate * Settings.TILE_LENGTH
	var flag_node: Object
	match team_color:
		"black":
			flag_node = new_instantiated_structure.get_node("BlackFlag")
		"white":
			flag_node = new_instantiated_structure.get_node("WhiteFlag")
		"_":
			printerr("why is the team color wrong")
	flag_node.position = new_instantiated_structure.entrance_coordinate * Settings.TILE_LENGTH
	flag_node.visible = true
	flag_node.play("Flag1")

	
	for shifted_coordinate in new_instantiated_structure.occupied_coordinates:
		if shifted_coordinate != new_instantiated_structure.entrance_coordinate:
			await TileMan.create_tile("null", coordinate + shifted_coordinate)
			await TileMan.connect_tiles([coordinate + shifted_coordinate])
		elif shifted_coordinate == new_instantiated_structure.entrance_coordinate:
			await TileMan.create_tile("green", coordinate + shifted_coordinate)
			await TileMan.connect_tiles([coordinate + shifted_coordinate])
		# create collisionshape for structure
		var collider = CollisionShape2D.new()
		new_instantiated_structure.add_child(collider)
		var new_shape = RectangleShape2D.new()
		new_shape.set_size(Vector2(Settings.TILE_LENGTH, Settings.TILE_LENGTH))
		collider.set_shape(new_shape)
		collider.global_position = (coordinate + shifted_coordinate) * Settings.TILE_LENGTH
	
	var structure_data = StructureData.structures[structure_name]
	for effect in structure_data["effects"]:
		if effect == "home" and fulfils_effect_conditions(structure_data["effects"]["home"]["conditions"], "create_structure", new_instantiated_structure, null):
			var num_cats: int = structure_data["effects"]["home"]["num_cats"]
			await new_instantiated_structure.home_cats(num_cats)


func fulfils_effect_conditions(conditions_data: Dictionary, timing: String, structure: Object, cat: Object):
	for condition in conditions_data:
		if condition == "visit":
			if timing != "finish_activity":
				return false
			continue

		if condition == "discovery":
			if timing != "finish_activity":
				return false
			var max_cats = conditions_data["discovery"]
			if structure.num_visits >= max_cats:
				return false
			continue

		if condition == "build":
			if timing != "create_structure":
				return false
			continue

		if condition == "wise":
			if len(cat.visited_structure_entrances) < conditions_data["wise"]:
				return false
			continue

		if condition == "historical":
			if structure.num_visits < conditions_data["historical"]:
				return false
			continue
	return true


func get_structure_by_id(id):
	if structures.has(id):
		return structures[id]
	else:
		return null
		
		
func get_structure_by_coordinate(new_coordinate: Vector2):
	for structure in structures.values():
		if (new_coordinate - structure.coordinate) in structure.occupied_coordinates:
			return structure
	return null
		
