extends Button

var structure_path : String
@onready var choose_location_ui = get_tree().current_scene.get_node("UI/ChooseLocationUI")

func update_texture():
	var structure = load(structure_path).instantiate()
	icon = structure.get_node("Button").icon


func _on_pressed():
	choose_location_ui.new_structure = load(structure_path)
	choose_location_ui.choose_location()
