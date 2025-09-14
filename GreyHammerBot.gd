extends Node2D

"""
## for choosing locations

"""
var color = "black"

var prev_state: String = ""
var prev_action: String = ""
var prev_reward: float = 0.0	# keep it to 2d.p.
var num_stars_at_prev_action_end: int = 0
var q_table = []
var epsilon: float = 0.1
var gamma: float = 0.9
var alpha: float = 0.9

# state details
var num_sampled_structures = 5
var num_conn_tile_rings = 4
var max_color_connections: int = -1
var color_connectivity_tiers = {
	"pathetic": 0.2,
	"weak": 0.4,
	"average": 0.6,
	"strong": 0.8,
	"elite": 1.0
}

# action details
var chosen_hand_structure_options = ["0", "1", "2", "3", "4"] 	# assuming that max hand is 5
var origin_structure_options = ["0", "1", "2", "3", "4"] # assuming that we sample from 5 owned structures

var statename2index = {}
var actionname2index = {}
var index2actionname = {}

@onready var choose_location_ui = get_tree().current_scene.get_node("UI/DraftUI")

func initialize_q_table(create_or_load: String):
	match create_or_load:
		"create":
			"""

			state variables:
			1. five of my own structures, sorted by id
			2. five opponent structures, sorted by id
			3. the number of same color connections within 4 rings from the structure, per structure
			4. the ids of the structures in hand, sorted by id
			e.g. five_owned_structures = "0,1,12,-1,-1"
			e.g. nearby_connected_edges_per_structure = "4, 2, 9, 5, 3"
			e.g. hand_structures = "4,1,-1,-1"

			actions:
			1. which hand structure to place
			2. which sampled structure to choose as an origin structure to spiral from

			"""

			# initialize states
			var num_sampled_structure_combinations = Common.n_choose_r(len(StructureData.structures)+1, num_sampled_structures)		# note that +1 is needed to account for "-1" structure id
			var num_color_connectivity_tier_combinations = pow(len(color_connectivity_tiers), num_sampled_structures)
			var num_possible_hands = pow(len(StructureData.structures)+1, PlayerMan.max_hand_size)
			# maxconn is the number of bagel types
			# there are 5 slots
			# so, there are 5 stars and maxconn-1 bars
			# (5 + maxconn-1) actual slots

			var num_col = num_sampled_structures * num_color_connectivity_tier_combinations * num_possible_hands
			
			# extract states
			var sampled_own_structures: Array = get_x_owned_structures(num_sampled_structures, "own")
			var own_structure_static_ids: Array = sampled_own_structures[0]
			var own_structure_ids: Array = sampled_own_structures[1]
			var opponent_structure_static_ids: Array = get_x_owned_structures(num_sampled_structures, "opponent")[0]
			var color_connectivity: Array = get_color_connectivity_within_x_rings(num_conn_tile_rings, own_structure_ids)
			var hand_structures: Array = get_hand_structures()
			
			## initialize actions
			#
			#var num_row = len(chosen_hand_structure_options) * len(origin_structure_options)
			#await initialize_actionname2index()
#
			#q_table.resize(num_row)
			#var new_col = []
			#new_col.resize(num_col)
			#new_col.fill(0)
			#q_table.fill(new_col)
"""

			var num_col = num_unique_structures * num_unique_structures * num_redness_tiers
			await initialize_statename2index(num_unique_structures, num_redness_tiers)

			# initialize actions
			'''
			sequence of 3 subactions: level up, level up, choose_location
			level_up_options: 0, 1 or 2
			choose_location_options: 0 or 1
			num_actions = num_level_up_options * num_choose_location_options
			= 3 * 2 = 6
			'''
			
		
		"load":
			load_q_table()
"""


func get_x_owned_structures(x: int, own_or_opponent: String):
	# get x random structures that you already built
	var built_structures = []	# consists of arrays containing static_id and id (e.g. [[12, 1], [2, 5]]
	for structure in StructureMan.structures.values():
		match own_or_opponent:
			"own": 
				if structure.team_color == color:
					built_structures.append([StructureMan.name2static_id[structure.structure_name], structure.id])
			"opponent":
				if structure.team_color != color:
					built_structures.append([StructureMan.name2static_id[structure.structure_name], structure.id])
	randomize()
	built_structures.shuffle()
	print(built_structures)
	var x_built_structures: Array = []

	for i in range(x):
		if i >= len(built_structures):
			x_built_structures.append([-1,-1])
			continue
		x_built_structures.append(built_structures[i])
	
	x_built_structures.sort()
	var x_built_structures_static_ids = []
	var x_built_structure_ids = []
	for arr in x_built_structures:
		x_built_structures_static_ids.append(arr[0])
		x_built_structure_ids.append(arr[1])
		
	return [x_built_structures_static_ids, x_built_structure_ids]
	

func get_color_connectivity_within_x_rings(x: int, owned_structures_ids: Array):
	var counts = []
	for id in owned_structures_ids:
		var count = 0
		if id == -1:
			counts.append("pathetic")
			continue
		var current_ring: Array[Vector2] = [StructureMan.structures[id].entrance_coordinate]
		var next_ring: Array[Vector2] = []
		var visited: Array[Vector2] = []
		
		for ring_number in range(x):
			for coord in current_ring:
				visited.append(coord)
				for adj_coord in [(coord+Vector2.RIGHT),(coord+Vector2.UP),(coord+Vector2.LEFT),(coord+Vector2.DOWN)]:
					var adj_tile_node = TileMan.get_tile(adj_coord)
					if (	# reject untraversable tiles
						adj_tile_node.color == "null" or
						adj_tile_node.color == "blue" or
						adj_tile_node.color == "purple" 
					):
						#print("rejected cos not traversable")
						continue
					if adj_coord in visited:
						#print("rejected cos visited")
						continue
					if adj_coord in next_ring:
						#print("rejected cos next ring")
						continue
						
					#print("not rejected")
					# check if the count for connected tiles should be incremented
					var origin_tile_node = TileMan.get_tile(coord)
					if adj_tile_node.color == origin_tile_node.color:
						count += 1
					next_ring.append(adj_coord)
				
			current_ring = next_ring
			next_ring = []
		var count_percentage: float = float(count)/max_color_connections
		if count_percentage > color_connectivity_tiers["strong"]:
			counts.append("elite")
		elif count_percentage > color_connectivity_tiers["average"]:
			counts.append("strong")
		elif count_percentage > color_connectivity_tiers["weak"]:
			counts.append("average")
		elif count_percentage > color_connectivity_tiers["pathetic"]:
			counts.append("weak")
		else:
			counts.append("pathetic")
	return counts
	

func get_hand_structures():
	var hand_structure_names = PlayerMan.black_hand
	var hand_structure_ids = []
	
	for i in range(PlayerMan.max_hand_size):
		if i < len(hand_structure_names):
			hand_structure_ids.append(StructureMan.name2static_id[hand_structure_names[i]])
		else:
			hand_structure_ids.append(-1)
	
	hand_structure_ids.sort()
	return Common.arr_to_commastring(hand_structure_ids)
	
	
func get_max_connections(num_rings: int):
	return 4 * pow(num_rings, 2)


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
	# print("new q_table value updated: ", q_table[prev_action_index][prev_state_index])


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


func show_thinking(duration: int):
	get_tree().current_scene.get_node("CommonUI/ThinkingContainer/Thinking").texture = load("res://UI/ThinkingAnimSprites/GreywhiskersThinking.tres")
	get_tree().current_scene.get_node("CommonUI/ThinkingContainer").visible = true
	await get_tree().create_timer(duration/Settings.game_speed).timeout
	get_tree().current_scene.get_node("CommonUI/ThinkingContainer").visible = false


func build_structure():
	print("greywhiskers building structure")
	var choose_location_ui = get_tree().current_scene.get_node("UI/ChooseLocationUI")
	get_tree().current_scene.get_node("CommonUI/ThinkingContainer/Thinking").texture = load("res://UI/ThinkingAnimSprites/GreywhiskersThinking.tres")
	get_tree().current_scene.get_node("CommonUI/ThinkingContainer").visible = true

	var important_coords: Array = get_entrances_with_bot_cats()
	if len(important_coords) == 0:
		important_coords = [Vector2(0,0)]

	var visited_coords = []
	var depth_counter: int = 2	# start with a ring tiles that are 2 depth distance from the important coords
	for target_coord in important_coords:
		for i in range(6):
			print("greywhiskers choose location depth: ", depth_counter)
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
					var new_log: String = "greywhiskers is checking "+structure_button.structure_name+" at "+str(ring_coord)
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
	print("greywhiskers looking for replacements")
	var event_ui = get_tree().current_scene.get_node("UI/EventUI")
	await show_thinking(5)
	var tile_buttons = event_ui.get_node("EventPanelContainer/VBoxContainer/EventOptions").get_children()
	tile_buttons.shuffle()
	await tile_buttons[0].emit_signal("pressed")


func save_q_table():
	var arr_in_bytes = var_to_bytes(q_table)
	var q_table_file = FileAccess.open("user://greywhiskers_q_table.save", FileAccess.WRITE)
	q_table_file.store_buffer(arr_in_bytes)
	q_table_file.close()
	# print("greywhiskers saved its q_table")

	# save its related indexes as well
	arr_in_bytes = var_to_bytes(statename2index)
	var statename2index_file = FileAccess.open("user://greywhiskers_statename2index.save", FileAccess.WRITE)
	statename2index_file.store_buffer(arr_in_bytes)
	statename2index_file.close()
	# print("greywhiskers saved its statename2index")

	arr_in_bytes = var_to_bytes(actionname2index)
	var actionname2index_file = FileAccess.open("user://greywhiskers_actionname2index.save", FileAccess.WRITE)
	actionname2index_file.store_buffer(arr_in_bytes)
	actionname2index_file.close()
	# print("greywhiskers saved its actionname2index")

	arr_in_bytes = var_to_bytes(index2actionname)
	var index2actionname_file = FileAccess.open("user://greywhiskers_index2actionname.save", FileAccess.WRITE)
	index2actionname_file.store_buffer(arr_in_bytes)
	index2actionname_file.close()
	# print("greywhiskers saved its index2actionname")


func load_q_table():
	var packed_arr = FileAccess.get_file_as_bytes("user://greywhiskers_q_table.save")
	var loaded_q_table = bytes_to_var(packed_arr)
	q_table = loaded_q_table

	packed_arr = FileAccess.get_file_as_bytes("user://greywhiskers_statename2index.save")
	var loaded_statename2index = bytes_to_var(packed_arr)
	statename2index = loaded_statename2index

	packed_arr = FileAccess.get_file_as_bytes("user://greywhiskers_actionname2index.save")
	var loaded_actionname2index = bytes_to_var(packed_arr)
	actionname2index = loaded_actionname2index

	packed_arr = FileAccess.get_file_as_bytes("user://greywhiskers_index2actionname.save")
	var loaded_index2actionname = bytes_to_var(packed_arr)
	index2actionname = loaded_index2actionname

	# printerr("loaded: ", loaded_q_table)
	# printerr("statename2index: ", statename2index)
