extends CanvasLayer

var common_draftable_structures: Array
var rare_draftable_structures: Array
var epic_draftable_structures: Array
var target_structure: String
var rarity: String

func initialize():
	print("initializing draft at turn: ", PlayerMan.total_turns)
	await %Timeline.update_timeline()
	%DraftTipBox/TurnLabel.text = "Rei's Blueprint Shop"
	%DraftTipBox/DraftInfoBox/Tip.text = "Buy a structure. The other will go to your opponent."
	$Hand.update_hand_structure_buttons()
	$Hand.disable_buttons()
	rarity = "common"
	%UpgradeButton.text = "Browse Yoshi's Shop"
	
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
		var browsed_shop = KittenBot.get_browsed_shop()
		assert(browsed_shop != "")
		var available_buttons: Array = []
		match browsed_shop:
			"rei":
				available_buttons = %CommonStructureButtons.get_children()
			"yoshi":
				await _on_upgrade_button_pressed()
				available_buttons = %RareStructureButtons.get_children()
			"tanaka":
				await _on_upgrade_button_pressed()
				await _on_upgrade_button_pressed()
				available_buttons = %EpicStructureButtons.get_children()
				
		assert(available_buttons != [])
		var target_button = KittenBot.get_draft_pick_from_buttons(available_buttons)
		await KittenBot.show_thinking(1)
		var new_log: String = "KittenBot's pick is: " + target_button.structure_name
		await get_tree().current_scene.add_to_log(new_log)
		await target_button._on_button_pressed()
		await KittenBot.show_thinking(1)
		await get_tree().current_scene.get_node("UI/DraftUI/CatBuildingInfo/VBoxContainer/ConfirmDraftButton")._on_pressed()
		return

	if PlayerMan.turn_color == "white" and PlayerMan.mode == "DuelingBot":
		await MouseketeerBot.pick_from_buttons(%CommonStructureButtons.get_children())
		await MouseketeerBot.show_thinking(1)
		await get_tree().current_scene.get_node("UI/DraftUI/CatBuildingInfo/VBoxContainer/ConfirmDraftButton")._on_pressed()
		return

	if PlayerMan.turn_color == "black" and PlayerMan.mode == "DuelingBot":
		await GreywhiskersBot.pick_from_buttons(%CommonStructureButtons.get_children())
		await GreywhiskersBot.show_thinking(1)
		await get_tree().current_scene.get_node("UI/DraftUI/CatBuildingInfo/VBoxContainer/ConfirmDraftButton")._on_pressed()
		return

	
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
	var shop_sfx = get_tree().current_scene.get_node("ShopSFX")
	shop_sfx.stream = load(AudioMan.kaching)
	shop_sfx.volume_db = -6
	shop_sfx.play()
	
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
		%DraftTipBox/TurnLabel.text = "Yoshi's shop"
		%UpgradeButton.text = "Browse Tanaka's shop"
		
	elif rarity == "rare":
		rarity = "epic"
		%RareStructureButtons.visible = false
		%EpicStructureButtons.visible = true
		await set_target_structure_name(epic_draftable_structures[0])
		%DraftTipBox/TurnLabel.text = "Tanaka's shop"
		%UpgradeButton.text = "No more shops to browse"
	
