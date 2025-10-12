extends CharacterBody2D
class_name Cat

var color : String
var id : String
var home_id : int
var state : String
var snacks : int
var tricks : int
var naps : int
var max_curiosity : int
var curiosity : int
var num_ingredients: int
var num_cooked_ingredients: int
var rest_duration_stat: int
var earned_stars: int = 0
var visited_structure_entrances: Array = []
var aura: String = "neutral"
var aura_duration: int = 0
var move_speed: float = 1
var equipment: String = "none"


func set_sprite(new_color: String, new_vehicle: String):
	var sprite_frames_path: String
	var uppercase_color = new_color[0].to_upper() + new_color.substr(1,-1)
	var uppercase_vehicle = new_vehicle[0].to_upper() + new_vehicle.substr(1,-1)

	sprite_frames_path = "res://Assets/Cats/SpriteFrames/" + uppercase_vehicle + uppercase_color + "CatSF.tres"
	$AnimatedSprite2D.sprite_frames = load(sprite_frames_path)
	$AnimatedSprite2D.play()
	#printerr("visibility: ", %Ingredients.visible)
	#printerr("SF: ", %Ingredients.texture)
	


func decide_destination():
	#printerr("deciding destination")
	var possible_destinations = []
	for structure in StructureMan.structures.values():
		var entrance = structure.entrance_coordinate + structure.coordinate
		if entrance == StructureMan.get_structure_by_id(home_id).get_global_entrance_coordinate(): 
			printerr(structure.structure_name, " is home, skipped by ", id)
			continue	# skip home structure
		if entrance == get_coordinate(): 
			printerr(structure.structure_name, " is current, skipped by ", id)
			continue	# skip current_structure
		if entrance in visited_structure_entrances:
			printerr(structure.structure_name, " is visited, skipped by ", id)
			continue	# skip visited structures
		if len(TileMan.astar.get_point_path(TileMan.get_id(get_coordinate()), TileMan.get_id(entrance)))-1 > curiosity:
			printerr(structure.structure_name, " is faraway, skipped by ", id)
			continue	# skip faraway structures
		if len(TileMan.astar.get_point_path(TileMan.get_id(get_coordinate()), TileMan.get_id(entrance))) == 0:
			printerr(structure.structure_name, " is blocked, skipped by ", id)
			continue	# if path is blocked
		possible_destinations.push_back(entrance)
	printerr("possible destinations: ", possible_destinations)
	
	match aura:
		"adventurous": # skips the nearest destination
			if len(possible_destinations) <= 0:
				return StructureMan.get_structure_by_id(home_id).get_global_entrance_coordinate()
				#print(id, " can reach these places: ",  possible_destinations)
			var shortest_distance = 999999	# arbitrary large number
			var	nearest_destinations = []
			for destination_coord in possible_destinations:
				var distance = destination_coord.distance_to(get_coordinate())
				if distance == shortest_distance:
					nearest_destinations.append(destination_coord)
					continue
				if distance < shortest_distance:
					shortest_distance = distance
					nearest_destinations = []
					nearest_destinations.append(destination_coord)
					continue

			assert(shortest_distance != 999999)
			for destination in nearest_destinations:
				possible_destinations.erase(destination)

			if len(possible_destinations) <= 0:
				return StructureMan.get_structure_by_id(home_id).get_global_entrance_coordinate()
				#print(id, " can reach these places: ",  possible_destinations)
			# look for nearest_destinations again
			shortest_distance = 999999	# arbitrary large number
			nearest_destinations = []
			for destination_coord in possible_destinations:
				var distance = destination_coord.distance_to(get_coordinate())
				if distance == shortest_distance:
					nearest_destinations.append(destination_coord)
					continue
				if distance < shortest_distance:
					shortest_distance = distance
					nearest_destinations = []
					nearest_destinations.append(destination_coord)
					continue

			if len(nearest_destinations) == 1:
				return nearest_destinations[0]
			if len(nearest_destinations) > 1:
				randomize()
				nearest_destinations.shuffle()
				return nearest_destinations.pop_front()
		
		_:
			if len(possible_destinations) <= 0:
				return StructureMan.get_structure_by_id(home_id).get_global_entrance_coordinate()
				#print(id, " can reach these places: ",  possible_destinations)
			# look for nearest_destinations again
			var shortest_distance = 999999	# arbitrary large number
			var	nearest_destinations = []
			for destination_coord in possible_destinations:
				var distance = destination_coord.distance_to(get_coordinate())
				if distance == shortest_distance:
					nearest_destinations.append(destination_coord)
					continue
				if distance < shortest_distance:
					shortest_distance = distance
					nearest_destinations = []
					nearest_destinations.append(destination_coord)
					continue

			if len(nearest_destinations) == 1:
				return nearest_destinations[0]
			if len(nearest_destinations) > 1:
				randomize()
				nearest_destinations.shuffle()
				return nearest_destinations.pop_front()

		
func go_to_coordinate(target_coordinate : Vector2):
	visited_structure_entrances.append(target_coordinate)

	var path = (TileMan.astar.get_point_path(TileMan.get_id(get_coordinate()), TileMan.get_id(target_coordinate)))
	for coordinate in path:
		if coordinate == get_coordinate():
			continue
		curiosity = max(0, curiosity - 1)

		var tween = get_tree().create_tween()
		var move_duration = 1 / (move_speed * Settings.game_speed)
		if CatMan.equipment_data[equipment].has("zoomies"): 
			move_duration *= (1/CatMan.equipment_data[equipment]["zoomies"])
		tween.tween_property(self, "global_position", coordinate*Settings.TILE_LENGTH, move_duration)
		await tween.finished
		tween.kill()

		if TileMan.get_tile(coordinate).color == "white":
			await gain_curiosity(3)
	
	if target_coordinate == StructureMan.get_structure_by_id(home_id).get_global_entrance_coordinate():
		enter_state("rest")
	else:
		enter_state("interact_structure")


func get_coordinate():
	var coordinate : Vector2
	coordinate.x = float(global_position.x)/Settings.TILE_LENGTH
	return floor(global_position/Settings.TILE_LENGTH)
	
	
# when a cat stops at the entrance of a building, 
# 1. it asks the building for permission to enter
# 2. it plays an entrance animation, which makes its sprite invisible.
# 3. it asks for the building to start_activity, and waits till that activity completes
# 4. the cat gains a number of points based on what the building provides
# 5. building gains stars based on the buddy stat of the cat
# 6. the cat plays the exit animation

func interact_structure():
	var interactable_structure = null
	for structure in StructureMan.structures.values():
		if structure.coordinate + structure.entrance_coordinate == get_coordinate():
			interactable_structure = structure
	if interactable_structure == null:
		printerr("No interactable structure found at cat's coordinate, ", self)
		return
	
	var can_enter : bool = interactable_structure.get_can_enter()
	if can_enter == false:
		enter_state("queue")
		return
	interactable_structure.start_activity(self)
	$AnimationPlayer.speed_scale = Settings.game_speed
	$AnimationPlayer.play("enter_structure")
	await $AnimationPlayer.animation_finished


func leave_structure():
	$AnimationPlayer.speed_scale = Settings.game_speed
	$AnimationPlayer.play("leave_structure")
	await $AnimationPlayer.animation_finished
	enter_state("wander")
	

func gain_snacks(number : int):
	snacks += number
	

func gain_tricks(number : int):
	tricks += number


func gain_naps(number : int):
	naps += number
	

func gain_curiosity(number : int):
	curiosity += number
	
	for i in range(number):
		play_gain_resource_animation("curiosity")
		await get_tree().create_timer(0.2/Settings.game_speed).timeout


func gain_max_curiosity(number : int):
	max_curiosity += number
	
	for i in range(number):
		play_gain_resource_animation("max_curiosity")
		await get_tree().create_timer(0.2/Settings.game_speed).timeout
	

func gain_ingredients(number : int):
	num_ingredients += number

	for i in range(number):
		play_gain_resource_animation("ingredients")
		await get_tree().create_timer(0.2/Settings.game_speed).timeout
	
	await update_ingredients_icon()
		
		
func update_ingredients_icon():
	if num_ingredients <= 0:
		%Ingredients.texture = null
	elif num_ingredients > 0 and num_ingredients < 13:
		%Ingredients.texture = load("res://Assets/Cats/Ingredients/Ingredients" + str(num_ingredients) + ".png")
	elif num_ingredients >= 13:
		%Ingredients.texture = load("res://Assets/Cats/Ingredients/Ingredients12.png")


func gain_cooked_ingredients(number : int):
	num_cooked_ingredients += number
	
	for i in range(number):
		play_gain_resource_animation("cooked ingredients")
		await get_tree().create_timer(0.2/Settings.game_speed).timeout
		
	await update_cooked_ingredients_icon()
	await update_ingredients_icon()


func update_cooked_ingredients_icon():
	if num_cooked_ingredients <= 0:
		%CookedIngredients.texture = null
	elif num_cooked_ingredients > 0 and num_cooked_ingredients < 13:
		%CookedIngredients.texture = load("res://Assets/Cats/CookedIngredients/CookedIngredients" + str(num_cooked_ingredients) + ".png")
	elif num_cooked_ingredients >= 13:
		%CookedIngredients.texture = load("res://Assets/Cats/CookedIngredients/CookedIngredients12.png")
		

func gain_stars(number : int):
	for i in range(number):
		earned_stars += 1
		match color:
			"black":
				PlayerMan.black_stars += 1
			"white":
				PlayerMan.white_stars += 1
				
		play_stars_animation(color)
		await get_tree().create_timer(0.2/Settings.game_speed).timeout
	

func play_stars_animation(star_color):
	var rotating_frames = load("res://Assets/UI/RotatingStarFrames.tres")
	var tween = get_tree().create_tween()
	var new_fx = AnimatedSprite2D.new()
	%StarFX.add_child(new_fx)
	new_fx.sprite_frames = load("res://Assets/UI/RotatingStarFrames.tres")
	
	match color:
		"black":
			new_fx.animation = "black"
		"white":
			new_fx.animation = "white"

	new_fx.play()
	tween.tween_property(new_fx, "global_position", new_fx.global_position+Vector2(0, -128), 1.8/Settings.game_speed).set_trans(Tween.TRANS_SPRING)
	await tween.finished
	%StarFX.remove_child(new_fx)
	new_fx.queue_free()
	
func play_gain_resource_animation(resource_type):
	var sprite: Resource
	match resource_type:
		"ingredients":
			sprite = load("res://Assets/Cats/Ingredients/Ingredients1.png")
		"cooked ingredients":
			sprite = load("res://Assets/Cats/CookedIngredients/CookedIngredients1.png")
		"curiosity":
			print("showing curio")
			sprite = load("res://Assets/Cats/CurosityIcon.png")
		"max_curiosity":
			print("showing max curio")
			sprite = load("res://Assets/Cats/MaxCuriosityIcon.png")
			
	var tween = get_tree().create_tween()
	var new_fx = Sprite2D.new()
	%ResourceFX.add_child(new_fx)
	new_fx.texture = sprite

	randomize()
	var spray_x = (randf_range(-16, 16))
	randomize()
	var spray_y = (randf_range(-16, 16))

	tween.tween_property(new_fx, "global_position", new_fx.global_position+Vector2(0, -128) + Vector2(spray_x, spray_y), 0.8/Settings.game_speed).set_trans(Tween.TRANS_SPRING)
	await tween.finished
	%StarFX.remove_child(new_fx)
	new_fx.queue_free()
	
	
func gain_aura(aura_type: String, num_of_visits_duration: int):
	aura = aura_type
	aura_duration = num_of_visits_duration
	%AuraAnimSprite.visible = true
	%AuraAnimSprite.sprite_frames = load("res://Assets/Cats/SpriteFrames/" + aura_type + "_aura_sf.tres")
	%AuraAnimSprite.play()
	#the aura needs to be bigger, and we need all the other aura spriteframes.


func gain_equipment(equipment_type: String):
	equipment = equipment_type
	await set_sprite(color, equipment_type)
	

func decrement_aura_duration():
	aura_duration -= 1
	if aura_duration <= 0:
		aura = "neutral"
		%AuraAnimSprite.visible = false
		
		
	
func enter_state(new_state : String):
	var previous_state = state
	state = new_state
	match new_state:
		"wander":
			var new_destination = decide_destination()
			if new_destination == get_coordinate():
				if curiosity < max_curiosity:
					enter_state("rest")

				elif curiosity == max_curiosity:
					await get_tree().create_timer(5/Settings.game_speed).timeout
					enter_state("wander")
				
			else:
				CatMan.has_moving_cats = true
				await go_to_coordinate(new_destination)
		
		"interact_structure":
			await interact_structure()
		
		"rest":
			$AnimationPlayer.speed_scale = Settings.game_speed
			$AnimationPlayer.play("enter_structure")
			await $AnimationPlayer.animation_finished
			%FX.visible = true
			$AnimationPlayer.play("start_rest")
			await get_tree().create_timer(rest_duration_stat / Settings.game_speed).timeout
			curiosity = max_curiosity
			$AnimationPlayer.speed_scale = Settings.game_speed
			$AnimationPlayer.play("stop_rest")
			await $AnimationPlayer.animation_finished
			$AnimationPlayer.speed_scale = Settings.game_speed
			$AnimationPlayer.play("leave_structure")
			await $AnimationPlayer.animation_finished
			visited_structure_entrances = []
			%FX.visible = false
			enter_state("wander")
				
		"queue":
			await get_tree().create_timer(1/Settings.game_speed).timeout
			enter_state("interact_structure")



func consume_ingredients():
	#curiosity += num_ingredients
	var new_log: String = id + " ate his ingredients!"
	print(new_log)
	await get_tree().current_scene.add_to_log(new_log)
	num_ingredients = 0 
	await update_ingredients_icon()


func consume_cooked_ingredients():
	#curiosity += num_ingredients
	var new_log: String = id + " ate his ingredients!"
	print(new_log)
	await get_tree().current_scene.add_to_log(new_log)
	num_cooked_ingredients = 0 
	await update_cooked_ingredients_icon()
	

func _physics_process(delta):
	$Stats.text = str(curiosity) + " curio"
	$Stats.text += "\n"
	$Stats.text += str(num_ingredients) + " ingrd"
	$Stats.text += "\n"
	$Stats.text += str(num_cooked_ingredients) + " c ingrd"
	$Stats.text += "\n"
	$Stats.text += aura
	%CuriosityLabel.text = str(curiosity)
	
	

func _on_mouse_entered() -> void:
	var cat_instance_info_node = get_tree().current_scene.get_node("CommonUI/VBoxContainer/HBoxContainer2/CatInstanceInfo")
	cat_instance_info_node.visible = true
	await cat_instance_info_node.update_info()
	# maybe highlight the speciic cat's info?
	# or maybe, we shouldnt bring up the menu. we shold just show the cat's name
	

func _on_mouse_exited() -> void:
	var cat_instance_info_node = get_tree().current_scene.get_node("CommonUI/VBoxContainer/HBoxContainer2/CatInstanceInfo")
	cat_instance_info_node.visible = false
