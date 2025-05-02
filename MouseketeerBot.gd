extends Node2D

"""
## one brain for drafting structures

"""
var color = "white"

var prev_state: String = ""
var prev_action: String = ""
var prev_reward: float = 0.0	# keep it to 2d.p.
var num_stars_at_prev_action_end: int = 0
var q_table = []
var epsilon: float = 0.15
var gamma: float = 0.9
var alpha: float = 0.9

# state details
var redness_tiers = {
	#  (num_red * 100) / (num_red + num_green) 
	0: 20,
	1: 40,
	2: 60,
	3: -1,	# -1 refers to > the previous tier
}
# action details
var level_up_options = ["common","rare","epic"] 
var draft_options = ["low", "high"] # in alphabetical order of the structure name

var statename2index = {}
var actionname2index = {}
var index2actionname = {}

@onready var draft_ui = get_tree().current_scene.get_node("UI/DraftUI")

func initialize_q_table(create_or_load: String):
	match create_or_load:
		"create":
			"""
			state variables:
			1a. all available common structures (string of integers) ([0:3] pos, 2 integers for each structure)
			1b. (next version) all available rare structures (string of integers) ([4:7] pos, 2 integers for each structure)
			1c. (next version) all available epic structures (string of integers) ([8:11] pos, 2 integers for each structure)
			2. redness (num_red / num_red + num_green) (4 tiers, <20% , <40%, <60%, >60%)

			num_unique_structures = number of unique structures
			num_redness_tiers = how red it is compared to red+green

			number of states = num_s * num_s * redness = 

			actions:
			1. Target structure to draft (0 or 1)
			2. Number of times to click upgrade (1 or 2)

			"""

			# initialize states
			var num_unique_structures = len(StructureData.structures)
			var num_redness_tiers = len(redness_tiers)

			var num_col = num_unique_structures * num_unique_structures * num_redness_tiers
			await initialize_statename2index(num_unique_structures, num_redness_tiers)

			# initialize actions
			"""
			sequence of 3 subactions: level up, level up, draft
			level_up_options: 0, 1 or 2
			draft_options: 0 or 1
			num_actions = num_level_up_options * num_draft_options
			= 3 * 2 = 6
			"""
			var num_row = len(level_up_options) * len(draft_options)
			await initialize_actionname2index()

			q_table.resize(num_row)
			var new_col = []
			new_col.resize(num_col)
			new_col.fill(0)
			q_table.fill(new_col)
		
		"load":
			load_q_table()


func initialize_statename2index(num_unique_structures, num_redness_tiers):
	statename2index = {}
	var cur = ""
	var index = 0
	for i in range(num_unique_structures):
		for j in range(num_unique_structures):
			for k in range(num_redness_tiers):
				cur = ""
				cur += str(i)
				cur += "," 
				cur += str(j)
				cur += ","
				cur += str(k)
				cur += ","
				statename2index[cur] = index
				index += 1


func initialize_actionname2index():
	actionname2index = {}
	var cur = ""
	var index = 0
	for level_up_option in level_up_options:
		for draft_option in draft_options:
			cur = ""
			cur += level_up_option
			cur += "," 
			cur += draft_option
			cur += ","
			actionname2index[cur] = index
			index2actionname[index] = cur
			index += 1


func pick_from_buttons(common_buttons: Array):
	var state_name = get_state_name(common_buttons)
	if prev_state != "":	# update the q_table everytime you enter a new state, unless you just started
		await update_q_table(state_name)
		await save_q_table()
	var sorted_buttons = get_sorted_buttons(common_buttons)
	get_tree().current_scene.get_node("CommonUI/ThinkingContainer").visible = true

	var action_string = ""
	randomize()
	var epsilon_roll = randf()
	if epsilon_roll < epsilon:
		action_string = get_random_action()
		print("mouseketeer made a random action: ", action_string)
	else:
		# every column is a state
		# get the actions along a column
		var state_index = statename2index[state_name]
		var state_column = Common.get_column_from_twodarr(q_table, state_index)
		action_string = index2actionname[Common.argmax(state_column)]
		print("mouseketeer made an argmax action: ", action_string)
		
	var action_string_unpacked = action_string.split(",")
	var i = 0
	for action in action_string_unpacked:
		if i == 0:
			if action == "common":
				i += 1
				continue
			if action == "rare":
				await draft_ui._on_upgrade_button_pressed()
				var rare_buttons = draft_ui.get_node("CatBuildingInfo/VBoxContainer/BlueprintContainer/RareStructureButtons").get_children()
				assert(len(rare_buttons) == 2)
				sorted_buttons = get_sorted_buttons(rare_buttons)
				i += 1
				continue
			if action == "epic":
				await draft_ui._on_upgrade_button_pressed()
				await draft_ui._on_upgrade_button_pressed()
				var epic_buttons = draft_ui.get_node("CatBuildingInfo/VBoxContainer/BlueprintContainer/EpicStructureButtons").get_children()
				assert(len(epic_buttons) == 2)
				sorted_buttons = get_sorted_buttons(epic_buttons)
				i += 1
				continue
		if i == 1:
			if action == "low":
				await sorted_buttons[0]._on_button_pressed()
				i += 1
				continue
			if action == "high":
				await sorted_buttons[1]._on_button_pressed()
				i += 1
				continue

	get_tree().current_scene.get_node("CommonUI/ThinkingContainer").visible = false
	var new_log: String = "MouseketeerBot's pick is: " + action_string
	await get_tree().current_scene.add_to_log(new_log)

	# after picking, save the old state and the reward gained. then, wait till the agent enters the next state before updating the q_table
	var num_stars_at_current_action_end = PlayerMan.white_stars
	var num_opponent_stars = PlayerMan.black_stars
	prev_state = state_name
	prev_action = action_string
	prev_reward = get_reward(num_stars_at_prev_action_end, num_stars_at_current_action_end, num_opponent_stars)
	print("mouseketeer's immediate reward = ", prev_reward)
	num_stars_at_prev_action_end = num_stars_at_current_action_end


func get_reward(prev_stars: int, current_stars: int, opponent_stars: float):
	return snapped((float(current_stars - prev_stars) - (opponent_stars*0.1)), 0.01)	# round to two d.p.


func update_q_table(new_state):
	var prev_state_index = statename2index[prev_state]
	var prev_action_index = actionname2index[prev_action]
	var new_state_index = statename2index[new_state]
	
	var retained_knowledge = (1-alpha) * q_table[prev_action_index][prev_state_index]
	var immediate_reward = alpha * prev_reward
	var future_valuation = gamma * Common.get_column_from_twodarr(q_table, new_state_index).max()
	
	q_table[prev_action_index][prev_state_index] = retained_knowledge + immediate_reward + future_valuation
	print("new q_table value updated: ", q_table[prev_action_index][prev_state_index])


func get_sorted_buttons(button_arr: Array):
	# sort buttons alphabetically by structure name.
	var name2index = {}
	var names = []
	var i = 0
	for button in button_arr:
		name2index[button.structure_name] = i
		names.append(button.structure_name)
		i += 1

	# print("name2index: ", name2index)
	names.sort()
	# print("sorted names: ", names)
	
	var sorted_buttons = []
	for name in names:
		sorted_buttons.append(button_arr[name2index[name]])
	
	# print("sorted_buttons: ")
	# for button in sorted_buttons:
	# 	print(button.structure_name)
	return sorted_buttons
	

func get_random_action():
	randomize()
	var action_index = randi_range(0, len(q_table)-1)
	return index2actionname[action_index]
	

func get_state_name(buttons: Array):
	# get the ids of the available structures from the buttons
	# get the redness based on the redness_tiers
	# combine them to get the state_name
	var state_name = ""
	var available_structure_ids = []
	for button in buttons:
		available_structure_ids.append(StructureMan.name2static_id[button.structure_name])
	assert(len(available_structure_ids) == 2)
	available_structure_ids.sort()
	for id in available_structure_ids:
		state_name += str(id)
		state_name += ","
		
	var num_tiles_per_color: Dictionary = TileMan.get_num_tiles_per_color()
	var redness: float = (num_tiles_per_color["red"] * 100) / (num_tiles_per_color["red"] + num_tiles_per_color["green"])
	var redness_tier: String = ""
	if redness > redness_tiers[2]:
		redness_tier = "3"
	elif redness > redness_tiers[1]:
		redness_tier = "2"
	elif redness > redness_tiers[0]:
		redness_tier = "1"
	else:
		redness_tier = "0"
	assert(redness_tier != "")

	state_name += redness_tier
	state_name += ","
	
	#print("state_name -- structure, structure, redness, :", state_name)
	return state_name


func show_thinking(duration: int):
	get_tree().current_scene.get_node("CommonUI/ThinkingContainer").visible = true
	await get_tree().create_timer(duration).timeout
	get_tree().current_scene.get_node("CommonUI/ThinkingContainer").visible = false


func build_structure():
	print("kittenbot building structure")
	var choose_location_ui = get_tree().current_scene.get_node("UI/ChooseLocationUI")
	get_tree().current_scene.get_node("CommonUI/ThinkingContainer").visible = true

	var important_coords: Array = get_entrances_with_bot_cats()
	if len(important_coords) == 0:
		important_coords = [Vector2(0,0)]

	var visited_coords = []
	var depth_counter: int = 2	# start with a ring tiles that are 2 depth distance from the important coords
	for target_coord in important_coords:
		for i in range(6):
			print("kittenbot choose location depth: ", depth_counter)
			var tile_ring: Array = get_tile_ring_of_x_depth(target_coord, depth_counter)
			randomize()
			tile_ring.shuffle()
			for ring_coord in tile_ring:
				visited_coords.append(ring_coord)
				var hand_cards = get_tree().current_scene.get_node("UI/ChooseLocationUI/TipBox/Hand/VBoxContainer/HBoxContainer").get_children()
				randomize()
				hand_cards.shuffle()
				for structure_button in hand_cards:
					if structure_button.structure_name == "":
						continue
					await structure_button._on_button_pressed()
					var new_entrance_coord = StructureData.structures[structure_button.structure_name]["entrance_coordinate"]
					await choose_location_ui.move_marker_and_make_visible(ring_coord - new_entrance_coord)
					var is_placeable = choose_location_ui.check_placeable()
					var new_log: String = "kittenbot is checking "+structure_button.structure_name+" at "+str(ring_coord)
					print(new_log)
					await get_tree().current_scene.add_to_log(new_log)
					await get_tree().create_timer(0.05/Settings.game_speed).timeout
					if is_placeable == true:
						await get_tree().current_scene.get_node("UI/ChooseLocationUI/TipBox/ConfirmLocationButton")._on_pressed()
						get_tree().current_scene.get_node("CommonUI/ThinkingContainer").visible = false
						return

			depth_counter += 1	

	get_tree().current_scene.get_node("CommonUI/ThinkingContainer").visible = false


func get_entrances_with_bot_cats():
	var coords = []
	for cat in CatMan.cats:
		if CatMan.cats[cat].color == "black":
			continue
		coords.append(StructureMan.get_structure_by_id(CatMan.cats[cat].home_id).entrance_coordinate)
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
	await show_thinking(2)
	var tile_buttons = event_ui.get_node("EventPanelContainer/VBoxContainer/EventOptions").get_children()
	tile_buttons.shuffle()
	await tile_buttons[0].emit_signal("pressed")


func save_q_table():
	var arr_in_bytes = var_to_bytes(q_table)
	var q_table_file = FileAccess.open("user://mouseketeer_q_table.save", FileAccess.WRITE)
	q_table_file.store_buffer(arr_in_bytes)
	q_table_file.close()
	# print("mouseketeer saved its q_table")

	# save its related indexes as well
	arr_in_bytes = var_to_bytes(statename2index)
	var statename2index_file = FileAccess.open("user://mouseketeer_statename2index.save", FileAccess.WRITE)
	statename2index_file.store_buffer(arr_in_bytes)
	statename2index_file.close()
	# print("mouseketeer saved its statename2index")

	arr_in_bytes = var_to_bytes(actionname2index)
	var actionname2index_file = FileAccess.open("user://mouseketeer_actionname2index.save", FileAccess.WRITE)
	actionname2index_file.store_buffer(arr_in_bytes)
	actionname2index_file.close()
	# print("mouseketeer saved its actionname2index")

	arr_in_bytes = var_to_bytes(index2actionname)
	var index2actionname_file = FileAccess.open("user://mouseketeer_index2actionname.save", FileAccess.WRITE)
	index2actionname_file.store_buffer(arr_in_bytes)
	index2actionname_file.close()
	# print("mouseketeer saved its index2actionname")


func load_q_table():
	var packed_arr = FileAccess.get_file_as_bytes("user://mouseketeer_q_table.save")
	var loaded_q_table = bytes_to_var(packed_arr)
	q_table = loaded_q_table

	packed_arr = FileAccess.get_file_as_bytes("user://mouseketeer_statename2index.save")
	var loaded_statename2index = bytes_to_var(packed_arr)
	statename2index = loaded_statename2index

	packed_arr = FileAccess.get_file_as_bytes("user://mouseketeer_actionname2index.save")
	var loaded_actionname2index = bytes_to_var(packed_arr)
	actionname2index = loaded_actionname2index

	packed_arr = FileAccess.get_file_as_bytes("user://mouseketeer_index2actionname.save")
	var loaded_index2actionname = bytes_to_var(packed_arr)
	index2actionname = loaded_index2actionname

	# printerr("loaded: ", loaded_q_table)
	# printerr("statename2index: ", statename2index)
