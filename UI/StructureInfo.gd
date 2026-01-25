extends Control

var structure_name : String
@onready var draft_ui = get_tree().current_scene.get_node("UI/DraftUI")
@onready var choose_location_ui = get_tree().current_scene.get_node("UI/ChooseLocationUI")
var button_mode: String = "Expanded"

func initialize(json_or_node: String, structure_node: Object):
	match json_or_node:
		"json":
			structure_name = structure_node.structure_name
			var structure_dict = StructureData.structures[structure_name]
			%NumStructureStars.text = str(structure_dict["structure_stars"]) + " stars"
			%StructureName.text = structure_name
			%Duration.text = str(structure_dict["activity_duration"]) + " sec"
			%ColorIcon.texture = load("res://Assets/" + structure_dict["color"].substr(0,1).to_upper() + structure_dict["color"].substr(1,-1) + "Tile.png")
			%StructureTexture.texture = load(structure_dict["icon"])
			%InfoEntranceIndicator.position = structure_dict["entrance_coordinate"] * Settings.TILE_LENGTH
			%Color.visible = false
			%Color.text = str(structure_dict["color"] + " structure")
			
			%Effects.text = ""
			var effects = structure_dict["effects"]
			await update_structure_effects(effects)
			# %Effects.text += "\n"
			# %Effects.text += "\"" + structure_dict["flavor"] + "\""
			# %Effects.text += "\n"
		
		"node":
			structure_name = structure_node.structure_name
			%NumStructureStars.text = str(structure_node.structure_stars) + " stars"
			%StructureName.text = structure_name
			%Duration.text = str(structure_node.activity_duration) + "s"
			%StructureTexture.texture = load(structure_node.icon)
			%InfoEntranceIndicator.position = structure_node.entrance_coordinate * Settings.TILE_LENGTH

			%Color.visible = false
			%Color.text = str(structure_node.color + " structure")
			
			%Effects.text = ""
			var effects = structure_node.effects
			await update_structure_effects(effects)

			%Effects.text += "\n"
			%Effects.text += "\"" + structure_node.flavor + "\""
			%Effects.text += "\n"


func update_structure_effects(effects: Dictionary):
	for effect in effects:
		if effect == "home":
			await print_conditions(effects[effect]["conditions"])
			%Effects.text += "HOME " + str(effects["home"]["num_cats"]) + " cats."
			%Effects.text += "\n"

		if effect == "catffeinate":
			await print_conditions(effects[effect]["conditions"])
			%Effects.text += "Gain " + str(effects["catffeinate"]["value"]) + " curiosity"
			%Effects.text += "\n"

		if effect == "double_structure_stars":
			await print_conditions(effects[effect]["conditions"])
			%Effects.text += "Double the structure stars of this structure"
			%Effects.text += "\n"
		
		if effect == "tire":
			await print_conditions(effects[effect]["conditions"])
			%Effects.text += "Lose " + str(effects["tire"]["value"]) + " curiosity"
			%Effects.text += "\n"

		if effect == "gain_aura":
			await print_conditions(effects[effect]["conditions"])
			var aura_data = effects["gain_aura"]
			await print_aura_description(aura_data)

		if effect == "gain_max_curiosity":
			await print_conditions(effects[effect]["conditions"])
			%Effects.text += "Gain " + str(effects["gain_max_curiosity"]["num_max_curiosity"]) + " max curiosity"
			%Effects.text += "\n"
		
		if effect == "gain_stars":
			await print_conditions(effects[effect]["conditions"])
			%Effects.text += "Gain +" + str(effects["gain_stars"]["num_stars"]) + " stars"
			%Effects.text += "\n"
		
		if effect == "gain_levels":
			await print_conditions(effects[effect]["conditions"])
			%Effects.text += "Gain +" + str(effects["gain_levels"]["value"]) + " " +  str(effects["gain_levels"]["type"]) +" levels."
			%Effects.text += "\n"

		if effect == "gain_ingredients":
			await print_conditions(effects[effect]["conditions"])
			%Effects.text += "Gain " + str(effects["gain_ingredients"]["num_ingredients"]) + " ingredients."
			%Effects.text += "\n"
			%Effects.text += "Cats holding ingredients gain double stars."
			%Effects.text += "\n"

		if effect == "cook_ingredients":
			await print_conditions(effects[effect]["conditions"])
			%Effects.text += "Lose all ingredients. Then, gain " + str(effects["cook_ingredients"]["num_cooked_ingredients_per_ingredient"]) + " cooked ingredients and " + str(effects["cook_ingredients"]["num_stars_per_ingredient"]) + " stars per ingredient lost this way."
			%Effects.text += "\n"
			%Effects.text += "Cats holding cooked ingredients gain double stars."
			%Effects.text += "\n"

		if effect == "serve_ingredients":
			await print_conditions(effects[effect]["conditions"])
			%Effects.text += "Gain " + str(effects["serve_ingredients"]["num_stars_per_cooked_ingredient"]) + " stars per cooked ingredient held by visiting cat"
			%Effects.text += "\n"
			%Effects.text += "Cooked ingredients can be served for stars"
			%Effects.text += "\n"

		if effect == "gain_equipment":
			await print_conditions(effects[effect]["conditions"])
			%Effects.text += "Gain a " + str(effects[effect]["type"])
			%Effects.text += "\n"
			await print_equipment_description(effects[effect])

		if effect == "rehome":
			await print_conditions(effects[effect]["conditions"])
			%Effects.text += "The visiting cat makes this structure its new home"
			%Effects.text += "\n"

		if effect == "retire":
			await print_conditions(effects[effect]["conditions"])
			%Effects.text += "Lose all curiosity"
			%Effects.text += "\n"

		if effect == "double_my_stars":
			await print_conditions(effects[effect]["conditions"])
			%Effects.text += "Gain stars equal to the stars earned by the visiting cat"
			%Effects.text += "\n"
		
		if effect == "terraform":
			await print_conditions(effects[effect]["conditions"])
			%Effects.text += "Change nearby tiles to " + str(effects[effect]["color"]) + " tiles"
			%Effects.text += "\n"

		
func print_conditions(all_conditions: Dictionary):
	for condition in all_conditions:
		var value = all_conditions[condition]
		if condition == "build":
			%Effects.text += "\n"
			%Effects.text += "When built,"
			%Effects.text += "\n"
		
		if condition == "thirsty":
			%Effects.text += "\n"
			%Effects.text += "When built next to at least " + str(value) + " connected blue tiles,"
			%Effects.text += "\n"

		if condition == "visit":
			%Effects.text += "\n"
			%Effects.text += "When visited,"
			%Effects.text += "\n"
		
		if condition == "discovery":
			%Effects.text += "\n"
			%Effects.text += "When visited by the first " + str(value) + " cats,"
			%Effects.text += "\n"
		
		if condition == "level":
			%Effects.text += "if " + str(value["type"]) + " level >= " + str(value["value"]) + ","
			%Effects.text += "\n"
				
		if condition == "wise":
			%Effects.text += "\n"
			%Effects.text += "When visited by a cat that has visited >" + str(value) + " unique structures,"
			%Effects.text += "\n"
				
		if condition == "historical":
			%Effects.text += "\n"
			%Effects.text += "When visited, if this structure has been visited more than " + str(value) + " times,"
			%Effects.text += "\n"


func print_equipment_description(data):
	var type = data["type"]
	for effect in CatMan.equipment_data[type].keys():
		if effect == "zoomies":
			%Effects.text += type + " gives a movement speed multiplier of " + str(CatMan.equipment_data[type][effect])
			%Effects.text += "\n"
			

func print_aura_description(data):
	var type = data["type"]
	var duration = data["duration"]

	if type == "inspiring":
		%Effects.text += "Gain a Inspiring Aura for " + str(duration) + " visits"
		%Effects.text += "\n"
		%Effects.text += "(Inspiring cats give other cats more curiosity)"
		%Effects.text += "\n"

	if type == "lazy":
		%Effects.text += "Gain a Lazy Aura for " + str(duration) + " visits"
		%Effects.text += "\n"
		%Effects.text += "(Lazy cats don't earn stars)"
		%Effects.text += "\n"

	if type == "generous":
		%Effects.text += "Gain a Generous Aura for " + str(duration) + " visits"
		%Effects.text += "\n"
		%Effects.text += "(Generous cats make structures give more stars)"
		%Effects.text += "\n"

	if type == "prankster":
		%Effects.text += "Gain a Prankster Aura for " + str(duration) + " visits"
		%Effects.text += "\n"
		%Effects.text += "(Prankster cats make structures give less stars)"
		%Effects.text += "\n"

	if type == "spooked":
		%Effects.text += "Gain a Spooked Aura for " + str(duration) + " visits"
		%Effects.text += "\n"
		%Effects.text += "(Spooked cats finish activities in 1 second)"
		%Effects.text += "\n"

	if type == "greedy":
		%Effects.text += "Gain a Greedy Aura for " + str(duration) + " visits"
		%Effects.text += "\n"
		%Effects.text += "(Greedy cats buy more items)"
		%Effects.text += "\n"

	if type == "adventurous":
		%Effects.text += "Gain a Adventurous Aura for " + str(duration) + " visits"
		%Effects.text += "\n"
		%Effects.text += "(Adventurous cats always skip the nearest structure)"
		%Effects.text += "\n"

	if type == "dutiful":
		%Effects.text += "Gain a dutiful Aura for " + str(duration) + " visits"
		%Effects.text += "\n"
		%Effects.text += "(Dutiful cats don't gain stars from structures of 3 stars or less)"
		%Effects.text += "\n"

	if type == "satisfied":
		%Effects.text += "Gain a satisfied Aura for " + str(duration) + " visits"
		%Effects.text += "\n"
		%Effects.text += "(Satisfied cats gain double the stars at the cost of their remaining curiosity)"
		%Effects.text += "\n"

	if type == "nosy":
		%Effects.text += "Gain a nosy Aura for " + str(duration) + " visits"
		%Effects.text += "\n"
		%Effects.text += "(Nosy cats gain bonus stars from opponent's structures)"
		%Effects.text += "\n"


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
			 	
		await draft_ui.set_target_structure_name(structure_name)

	if UIMan.mode == "ChooseLocationUI":
		choose_location_ui.new_structure = structure_name
		choose_location_ui.choose_location()
		choose_location_ui.get_node("TipBox/Hand/VBoxContainer/HBoxContainer").visible = false
		choose_location_ui.get_node("TipBox/ConfirmLocationButton").visible = true
