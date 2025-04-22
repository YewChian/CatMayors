extends CanvasLayer

var common_draftable_structures: Array
var rare_draftable_structures: Array
var epic_draftable_structures: Array
var target_structure: String
var rarity: String

func initialize():
	await %Timeline.update_timeline()
	%DraftTipBox/TurnLabel.text = "BLUEPRINT SHOP"
	%DraftTipBox/DraftInfoBox/Tip.text = "Buy a structure. The other will go to your opponent."
	$Hand.update_hand_structure_buttons()
	$Hand.disable_buttons()
	rarity = "common"
	%ShopRarityLabel.text = rarity + " shop"
	if PlayerMan.total_turns % (len(PlayerMan.phases)*2) == 2 or PlayerMan.total_turns % (len(PlayerMan.phases)*2) == 3:
		%UpgradeButton.set_deferred("disabled", false)
	else:
		%UpgradeButton.set_deferred("disabled", true)
	
	%CommonStructureButtons.visible = true
	%RareStructureButtons.visible = false
	%EpicStructureButtons.visible = false
	await initialize_draftable_structures()

	await set_target_structure_name(common_draftable_structures[0])
	await update_draftable_structure_buttons()
	var first_button = %CommonStructureButtons.get_child(0)
	await first_button.highlight_button(first_button.get_node("Button"))

	var second_button = %CommonStructureButtons.get_child(1)
	await second_button.unhighlight_button(second_button.get_node("Button"))
	
	
	
	if PlayerMan.turn_color == "white" and PlayerMan.mode == "KittenBot":
		var target_button = KittenBot.get_draft_pick_from_buttons(%CommonStructureButtons.get_children())
		await KittenBot.show_thinking(1)
		var new_log: String = "KittenBot's pick is: " + target_button.structure_name
		await get_tree().current_scene.add_to_log(new_log)
		await target_button._on_button_pressed()
		await KittenBot.show_thinking(0.2)
		await get_tree().current_scene.get_node("UI/DraftUI/CatBuildingInfo/VBoxContainer/ConfirmDraftButton")._on_pressed()

	
func on_touched(event):
	pass
	

func initialize_draftable_structures():
	common_draftable_structures = []	
	rare_draftable_structures = []	
	epic_draftable_structures = []	
	var all_common_structures = []
	var all_rare_structures = []
	var all_epic_structures = []
	for name in StructureData.structures:
		var structure_data = StructureData.structures[name]
		if structure_data["rarity"] == "common":
			all_common_structures.append(name)
		if structure_data["rarity"] == "rare":
			all_rare_structures.append(name)
		if structure_data["rarity"] == "epic":
			all_epic_structures.append(name)
			
	randomize()
	all_common_structures.shuffle()
	all_rare_structures.shuffle()
	all_epic_structures.shuffle()
	common_draftable_structures.push_back(all_common_structures.pop_front())
	common_draftable_structures.push_back(all_common_structures.pop_front())
	rare_draftable_structures.push_back(all_rare_structures.pop_front())
	rare_draftable_structures.push_back(all_rare_structures.pop_front())
	epic_draftable_structures.push_back(all_epic_structures.pop_front())
	epic_draftable_structures.push_back(all_epic_structures.pop_front())
	

func update_draftable_structure_buttons():
	var structure_node_resource = load("res://Structures/Structure.tscn")
	var i : int = 0
	for button in %CommonStructureButtons.get_children():
		var new_structure_name = common_draftable_structures[i]
		var temp_structure_node = structure_node_resource.instantiate()
		await temp_structure_node.initialize_stats(new_structure_name, PlayerMan.turn_color)
		await button.initialize("json", temp_structure_node)
		i += 1
	i = 0
	for button in %RareStructureButtons.get_children():
		var new_structure_name = rare_draftable_structures[i]
		var temp_structure_node = structure_node_resource.instantiate()
		await temp_structure_node.initialize_stats(new_structure_name, PlayerMan.turn_color)
		await button.initialize("json", temp_structure_node)
		i += 1
	i = 0
	for button in %EpicStructureButtons.get_children():
		var new_structure_name = epic_draftable_structures[i]
		var temp_structure_node = structure_node_resource.instantiate()
		await temp_structure_node.initialize_stats(new_structure_name, PlayerMan.turn_color)
		await button.initialize("json", temp_structure_node)
		i += 1


func set_target_structure_name(structure_name : String):
	target_structure = structure_name


func end_turn():
	match PlayerMan.turn_color:
		"black":
			PlayerMan.black_hand.push_back(target_structure)
			match rarity:
				"common":
					common_draftable_structures.erase(target_structure)
					assert(len(common_draftable_structures) == 1)
					PlayerMan.white_hand.push_back(common_draftable_structures[0])
					
				"rare":
					rare_draftable_structures.erase(target_structure)
					assert(len(rare_draftable_structures) == 1)
					PlayerMan.white_hand.push_back(rare_draftable_structures[0])
					
				"epic":
					epic_draftable_structures.erase(target_structure)
					assert(len(epic_draftable_structures) == 1)
					PlayerMan.white_hand.push_back(epic_draftable_structures[0])

		"white":
			PlayerMan.white_hand.push_back(target_structure)
			match rarity:
				"common":
					common_draftable_structures.erase(target_structure)
					assert(len(common_draftable_structures) == 1)
					PlayerMan.black_hand.push_back(common_draftable_structures[0])
					
				"rare":
					rare_draftable_structures.erase(target_structure)
					assert(len(rare_draftable_structures) == 1)
					PlayerMan.black_hand.push_back(rare_draftable_structures[0])
					
				"epic":
					epic_draftable_structures.erase(target_structure)
					assert(len(epic_draftable_structures) == 1)
					PlayerMan.black_hand.push_back(epic_draftable_structures[0])

func _on_upgrade_button_pressed() -> void:
	if rarity == "common":
		rarity = "rare"
		%CommonStructureButtons.visible = false
		%RareStructureButtons.visible = true
		await set_target_structure_name(rare_draftable_structures[0])
	elif rarity == "rare":
		rarity = "epic"
		%RareStructureButtons.visible = false
		%EpicStructureButtons.visible = true
		await set_target_structure_name(epic_draftable_structures[0])
	%ShopRarityLabel.text = rarity + " shop"
	
