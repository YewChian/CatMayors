extends Node2D


func get_browsed_shop():
	var available_shops = {
		"rei": 0.7,
		"yoshi": 0.2,
		"tanaka": 0.1
	}
	randomize()
	var diceroll = randf_range(0,1)
	if diceroll < available_shops["tanaka"]:
		return "tanaka"
	elif diceroll < (available_shops["yoshi"] + available_shops["tanaka"]):
		return "yoshi"
	else:
		return "rei"
	return ""

func get_draft_pick_from_buttons(buttons: Array):
	get_tree().current_scene.get_node("CommonUI/ThinkingContainer/Thinking").texture = load("res://UI/ThinkingAnimSprites/MouseketeerThinking.tres")
	get_tree().current_scene.get_node("CommonUI/ThinkingContainer").visible = true
	randomize()
	buttons.shuffle()
	var pick = buttons[0]
	for button in buttons:
		if StructureData.structures[button.structure_name]["effects"].has("home"):
			pick = button
			break

	get_tree().current_scene.get_node("CommonUI/ThinkingContainer").visible = false
	return pick


func show_thinking(duration: int):
	get_tree().current_scene.get_node("CommonUI/ThinkingContainer/Thinking").texture = load("res://UI/ThinkingAnimSprites/MouseketeerThinking.tres")
	get_tree().current_scene.get_node("CommonUI/ThinkingContainer").visible = true
	await get_tree().create_timer(duration/Settings.game_speed).timeout
	get_tree().current_scene.get_node("CommonUI/ThinkingContainer").visible = false


func build_structure():
	print("kittenbot building structure")
	var choose_location_ui = get_tree().current_scene.get_node("UI/ChooseLocationUI")
	get_tree().current_scene.get_node("CommonUI/ThinkingContainer/Thinking").texture = load("res://UI/ThinkingAnimSprites/MouseketeerThinking.tres")
	get_tree().current_scene.get_node("CommonUI/ThinkingContainer").visible = true
	await get_tree().create_timer(1/Settings.game_speed)

	var important_coords: Array = get_entrances_with_bot_cats_mostly()
	if len(important_coords) == 0:
		important_coords = [Vector2(0,0)]

	var visited_coords = []
	var depth_counter: int = 2	# start with a ring tiles that are 2 depth distance from the important coords
	var turn_timer_node: Object = get_tree().current_scene.get_node("CommonUI/VBoxContainer/HBoxContainer/TimeLeft/TurnTimer")
	for target_coord in important_coords:
		for i in range(14):
			#if (turn_timer_node.wait_time/(Settings.TURN_DURATION["ChooseLocationUI"]*Settings.game_speed) <= 0.1):
			var tile_ring: Array = get_tile_ring_of_x_depth(target_coord, depth_counter)
			randomize()
			tile_ring.shuffle()
			for ring_coord in tile_ring:
				visited_coords.append(ring_coord)
				var hand_cards = get_tree().current_scene.get_node("UI/ChooseLocationUI/TipBox/Hand/VBoxContainer/HBoxContainer").get_children()
				randomize()
				hand_cards.shuffle()
				for structure_button in hand_cards:
					if (PlayerMan.turn_color != "white"):
						get_tree().current_scene.get_node("CommonUI/ThinkingContainer").visible = false
						return
					if structure_button.structure_name == "":
						continue
					await structure_button._on_button_pressed()
					var new_entrance_coord = StructureData.structures[structure_button.structure_name]["entrance_coordinate"]
					await choose_location_ui.move_marker_and_make_visible(ring_coord - new_entrance_coord)
					var is_placeable = choose_location_ui.check_placeable()
					#var new_log: String = "kittenbot is checking "+structure_button.structure_name+" at "+str(ring_coord)
					#print(new_log)
					#await get_tree().current_scene.add_to_log(new_log)
					await get_tree().create_timer(max(0.01, (0.5 - (i*0.2)))/Settings.game_speed).timeout
					if is_placeable == true:
						await get_tree().current_scene.get_node("UI/ChooseLocationUI/TipBox/ConfirmLocationButton")._on_pressed()
						get_tree().current_scene.get_node("CommonUI/ThinkingContainer").visible = false
						return

			depth_counter += 1	

	get_tree().current_scene.get_node("CommonUI/ThinkingContainer").visible = false


func get_entrances_with_bot_cats_mostly():
	# gets entrances of structures with their cats, but also some non-home buildings if its late into the game
	var coords = []
	for cat in CatMan.cats:
		if CatMan.cats[cat].color == "black":
			continue
		coords.append(StructureMan.get_structure_by_id(CatMan.cats[cat].home_id).entrance_coordinate)
	
	print("initial candidates: ", len(coords))
	if len(coords) > 3:
		var all_structures = StructureMan.structures.keys()
		randomize()
		all_structures.shuffle()
		var num_random_entrances = int(float(len(coords))/3)
		for i in range(num_random_entrances):
			coords.append(StructureMan.structures[all_structures[i]]["entrance_coordinate"])
		print("modified candidates: ", len(coords))
	
	return coords


func get_tile_ring_of_x_depth(origin_coord, x):
	var current_depth = 0
	var tile_ring = []
	var visited = []
	var old_queue = []
	var new_queue = [origin_coord]

	while current_depth <= x:
		old_queue = new_queue
		new_queue = []
		for coord in old_queue:
			var down_coord = Vector2(coord.x, coord.y+1)
			var up_coord = Vector2(coord.x, coord.y-1)
			var right_coord = Vector2(coord.x+1, coord.y)
			var left_coord = Vector2(coord.x-1, coord.y)

			if current_depth == x:
				if left_coord not in visited:
					tile_ring.append(left_coord)
					visited.append(left_coord)
				if right_coord not in visited:
					tile_ring.append(right_coord)
					visited.append(right_coord)
				if up_coord not in visited:
					tile_ring.append(up_coord)
					visited.append(up_coord)
				if down_coord not in visited:
					tile_ring.append(down_coord)
					visited.append(down_coord)

			else:
				if left_coord not in visited:
					new_queue.append(left_coord)
					visited.append(left_coord)
				if right_coord not in visited:
					new_queue.append(right_coord)
					visited.append(right_coord)
				if up_coord not in visited:
					new_queue.append(up_coord)
					visited.append(up_coord)
				if down_coord not in visited:
					new_queue.append(down_coord)
					visited.append(down_coord)

		current_depth += 1

	return tile_ring

func choose_purple_tile_replacements():
	print("kittenbot looking for replacements")
	var event_ui = get_tree().current_scene.get_node("UI/EventUI")
	await show_thinking(5)
	var tile_buttons = event_ui.get_node("EventPanelContainer/VBoxContainer/EventOptions").get_children()
	tile_buttons.shuffle()
	await tile_buttons[0].emit_signal("pressed")


func observe():
	await show_thinking(Settings.TURN_DURATION["ObserveUI"])
