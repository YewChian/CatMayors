extends CanvasLayer

var draftable_structures : Array
var target_structure_path : String

func initialize():
	await %Timeline.update_timeline()
	%DraftTipBox/TurnLabel.text = str(PlayerMan.turn_color) + "'s turn."
	%DraftTipBox/Tip.text = "Choose one structure. The other will go to your opponent."
	$Hand.update_hand_structure_buttons()
	$Hand.disable_buttons()
	await initialize_draftable_structures()
	await set_target_structure_path(draftable_structures[0])
	await update_draftable_structure_buttons()

	
func on_touched(event):
	pass
	

func initialize_draftable_structures():
	draftable_structures = []	
	var all_structures = StructureMan.all_structures.values()
	randomize()
	all_structures.shuffle()
	draftable_structures.push_back(all_structures.pop_front())
	draftable_structures.push_back(all_structures.pop_front())


func update_draftable_structure_buttons():
	var i : int = 0
	for button in %StructureButtons.get_children():
		var new_structure_path = draftable_structures[i]
		var structure_node = load(new_structure_path).instantiate()
		await button.initialize(new_structure_path)
		i += 1


func set_target_structure_path(structure_path : String):
	target_structure_path = structure_path


func end_turn():
	match PlayerMan.turn_color:
		"black":
			PlayerMan.black_hand.push_back(target_structure_path)
			draftable_structures.erase(target_structure_path)
			assert(len(draftable_structures) == 1)
			PlayerMan.white_hand.push_back(draftable_structures[0])
		"white":
			PlayerMan.white_hand.push_back(target_structure_path)
			draftable_structures.erase(target_structure_path)
			assert(len(draftable_structures) == 1)
			PlayerMan.black_hand.push_back(draftable_structures[0])
