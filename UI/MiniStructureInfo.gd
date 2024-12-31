extends Button

var structure_path : String
@onready var draft_ui = get_tree().current_scene.get_node("UI/DraftUI")
@onready var choose_location_ui = get_tree().current_scene.get_node("UI/ChooseLocationUI")

func _ready():
	initialize("res://Structures/FishingHut.tscn")

func initialize(new_structure_path):
	structure_path = new_structure_path
	var new_structure_node = load(new_structure_path).instantiate()
	new_structure_node.initialize_stats()
	icon = new_structure_node.get_node("Button").icon
	icon.set_size(Vector2(16,16))

	

func _on_button_pressed():
	if UIMan.mode == "DraftUI":
		pass

	if UIMan.mode == "ChooseLocationUI":
		pass
