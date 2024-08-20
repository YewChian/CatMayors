extends Control

var structure_path : String
@onready var draft_ui = get_tree().current_scene.get_node("UI/DraftUI")
@onready var choose_location_ui = get_tree().current_scene.get_node("UI/ChooseLocationUI")

func initialize(new_structure_path):
	structure_path = new_structure_path
	var new_structure_node = load(new_structure_path).instantiate()
	new_structure_node.initialize_stats()
	%StructureName.text = new_structure_node.structure_name
	%StructureTexture.texture = new_structure_node.get_node("Button").icon
	%Cats.visible = false
	%StatGains.visible = false
	%Stars.visible = false
	
	if new_structure_node.num_cats > 0:
		%Cats.visible = true
		%Cats.text = "Gain " + str(new_structure_node.num_cats) + " cats."
		
	if new_structure_node.tricks > 0 or new_structure_node.snacks > 0 or new_structure_node.naps > 0:
		%StatGains.visible = true
		%StatGains.text = "On visit, cats gain:\n"
		if new_structure_node.tricks > 0:
			%StatGains.text += str(new_structure_node.tricks) + " tricks\n"
		if new_structure_node.snacks > 0:
			%StatGains.text += str(new_structure_node.snacks) + " snacks\n"
		if new_structure_node.naps > 0:
			%StatGains.text += str(new_structure_node.naps) + " naps\n"
	
	if new_structure_node.trick_stars > 0 or new_structure_node.snack_stars > 0 or new_structure_node.nap_stars > 0:
		%Stars.visible = true
		%Stars.text = "On visit, players gain:\n"
		if new_structure_node.trick_stars > 0:
			%Stars.text += str(new_structure_node.trick_stars) + " stars for every trick\n"
		if new_structure_node.snack_stars > 0:
			%Stars.text += str(new_structure_node.snack_stars) + " stars for every snack\n"
		if new_structure_node.nap_stars > 0:
			%Stars.text += str(new_structure_node.nap_stars) + " stars for every nap\n"
	


func highlight_button(target_button):
	target_button.add_theme_stylebox_override("normal", load("res://Styles/HighlightedButton.tres"))

func unhighlight_button(target_button):
	target_button.add_theme_stylebox_override("normal", load("res://Styles/UnhighlightedButton.tres"))
	

func disable_button():
	get_node("Button").set_deferred("disabled", true)
	
	
func enable_button():
	get_node("Button").set_deferred("disabled", false)

func _on_button_pressed():
	if UIMan.mode == "DraftUI":
		for node in get_parent().get_children():
			if node == self:
				await highlight_button(node.get_node("Button"))
			else:
				await unhighlight_button(node.get_node("Button"))
				
		await draft_ui.set_target_structure_path(structure_path)

	if UIMan.mode == "ChooseLocationUI":
		choose_location_ui.new_structure = load(structure_path)
		choose_location_ui.choose_location()
