extends Node

var structures : Dictionary
var current_id = 0
var all_structures : Dictionary = {
	"Fishing Hut" : "res://Structures/FishingHut.tscn",
	"Lumbercat Yard" : "res://Structures/LumbercatYard.tscn",
	"Fountain" : "res://Structures/Fountain.tscn",
	"Tower Tree" : "res://Structures/TowerTree.tscn",
	"Catbeds" : "res://Structures/Catbeds.tscn",
	"Rock" : "res://Structures/Rock.tscn",
	"Catnip ALley" : "res://Structures/CatnipAlley.tscn",
	"Scratch Post" : "res://Structures/ScratchPost.tscn",
	"Tuna Factory" : "res://Structures/TunaFactory.tscn",
}


func create_structure(structure_resource : Resource, coordinate : Vector2):
	var new_instantiated_structure = structure_resource.instantiate()
	get_tree().current_scene.get_node("Structures").add_child(new_instantiated_structure)
	new_instantiated_structure.global_position = coordinate * Settings.TILE_LENGTH
	new_instantiated_structure.coordinate = coordinate
	new_instantiated_structure.id = current_id
	structures[current_id] = new_instantiated_structure
	current_id += 1
	
	await new_instantiated_structure.initialize_stats()
	new_instantiated_structure.get_node("EntranceIndicator").position = new_instantiated_structure.entrance_coordinate * Settings.TILE_LENGTH
	
	for shifted_coordinate in new_instantiated_structure.occupied_coordinates:
		if shifted_coordinate == new_instantiated_structure.entrance_coordinate:
			continue
		await TileMan.create_tile("null", coordinate + shifted_coordinate)
	
	await new_instantiated_structure.initialize_cats()

func get_structure_by_id(id):
	if structures.has(id):
		return structures[id]
	else:
		return null
		
		
func get_structure_by_coordinate(new_coordinate):
	for structure in structures.values():
		if new_coordinate in structure.occupied_coordinates:
			return structure
	return null
		
