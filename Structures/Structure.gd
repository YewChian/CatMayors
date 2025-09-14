extends Area2D
class_name Structure

var structure_name : String
var team_color: String
var flags: int
var color : String
var occupied_coordinates : Array
var coordinate : Vector2
var icon: String
var entrance_coordinate : Vector2
var cats : Array
var id : int
var cats_doing_activity : Array = []
var activity_duration : float
var structure_stars: int
var flavor: String
var effects: Dictionary
var earned_stars_here: int

var visited_cats = []
var num_visits: int = 0
var num_rehomed: int = 0

@onready var structure_instance_info = get_tree().current_scene.get_node("CommonUI/VBoxContainer/HBoxContainer2/StructureInstanceInfo")

func _ready():
	$AnimationPlayer.speed_scale = Settings.game_speed
	$AnimationPlayer.play("idle")
	

func initialize_stats(new_structure_name: String, new_team_color: String):
	structure_name = new_structure_name
	color = StructureData.structures[structure_name]["color"]
	%StructureSprite.texture = load(StructureData.structures[structure_name]["sprite"])
	%StructureSprite.offset = StructureData.structures[structure_name]["sprite_offset"]
	icon = StructureData.structures[structure_name]["icon"]
	occupied_coordinates = StructureData.structures[structure_name]["occupied_coordinates"]
	entrance_coordinate = StructureData.structures[structure_name]["entrance_coordinate"]
	activity_duration = StructureData.structures[structure_name]["activity_duration"]
	structure_stars = StructureData.structures[structure_name]["structure_stars"]
	flavor = StructureData.structures[structure_name]["flavor"]
	effects = StructureData.structures[structure_name]["effects"]
	flags = 1
	earned_stars_here = 0
	team_color = new_team_color

	
func home_cats(num_cats: int):
	for i in range(num_cats):
		var new_cat = await CatMan.create_cat(PlayerMan.turn_color)
		new_cat.home_id = id
		new_cat.global_position = (entrance_coordinate + coordinate) * Settings.TILE_LENGTH
		cats.append(new_cat)
		new_cat.enter_state("wander")


func get_can_enter():
	if len(cats_doing_activity) > 0:
		return false
	else:
		return true


func start_activity(cat : Object):
	cats_doing_activity.push_back(cat)

	if (
			cat.num_ingredients > 0
			and effects.has("gain_ingredients") == false
			and effects.has("cook_ingredients") == false
		):
		await cat.consume_ingredients()
	if (
			cat.num_cooked_ingredients > 0
			and effects.has("cook_ingredients") == false
			and effects.has("serve_ingredients") == false
		):
		await cat.consume_cooked_ingredients()

	var is_cat_spooked: bool = false
	if cat.aura == "spooked":
		await cat.decrement_aura_duration()
		is_cat_spooked == true
		var new_log: String = cat.id + "was still spooked at" + structure_name
		print(new_log)
		await get_tree().current_scene.add_to_log(new_log)
				
	$AnimationPlayer.speed_scale = Settings.game_speed
	$AnimationPlayer.play("start_activity")
	$ActivityProgress.show_activity_progress(is_cat_spooked)
	
	show_effects_of_cat_on_structure(cat)
	

func finish_activity():
	$AnimationPlayer.speed_scale = Settings.game_speed
	$AnimationPlayer.play("end_activity")

	for active_cat in cats_doing_activity:
		var lazy_stars_multiplier = 1
		var dutiful_stars_multiplier = 1
		var satisfied_stars_multiplier = 1
		var bonus_stars = 0

		if active_cat.aura == "lazy":
			lazy_stars_multiplier = 0

		match active_cat.aura:
			"neutral":
				pass

			"prankster":
				await active_cat.decrement_aura_duration()
				structure_stars = max(0, structure_stars-1)	# lower the structure stars
				var new_log: String = active_cat.id + " knocked over some stuff at " + structure_name + ", lowering its stars"
				print(new_log)
				await get_tree().current_scene.add_to_log(new_log)
				get_node("EntranceIndicator").frame = structure_stars

			"generous":
				await active_cat.decrement_aura_duration()
				structure_stars += 1
				var new_log: String = active_cat.id + " upgraded " + structure_name
				print(new_log)
				await get_tree().current_scene.add_to_log(new_log)
				get_node("EntranceIndicator").frame = structure_stars

			# lazy: the next structure this cat visits gains the following effect:
			## structure_stars = 0
			"lazy":
				await active_cat.decrement_aura_duration()
				var new_log: String = active_cat.id + " was feeling lazy at " + structure_name
				print(new_log)
				await get_tree().current_scene.add_to_log(new_log)
			
			# inspiring: the next structure a cat visits gains the following effect:
			## if the structure does not have catffeinate, gain catffeinate 3
			## else double it's catffeinate value
			"inspiring":
				await active_cat.decrement_aura_duration()
				if effects.has("catffeinate"):
					effects["catffeinate"]["value"] *= 2
				else:
					effects["catffeinate"] = {}
					effects["catffeinate"]["conditions"] = {"visit": 1}
					effects["catffeinate"]["value"] = 3
				var new_log: String = active_cat.id + " was feeling lazy at " + structure_name
				print(new_log)
				await get_tree().current_scene.add_to_log(new_log)

			# dutiful: doesnt gain stars from structures with <= 3 stars
			"dutiful":
				await active_cat.decrement_aura_duration()
				if structure_stars <= 3:
					dutiful_stars_multiplier = 0
					
				var new_log: String = active_cat.id + " was feeling lazy at " + structure_name
				print(new_log)
				await get_tree().current_scene.add_to_log(new_log)

			# lose all curiosity and gain double the stars
			"satisfied":
				await active_cat.decrement_aura_duration()
				satisfied_stars_multiplier = 2
				active_cat.curiosity = 0

			# gain 2 bonus stars if visited structure is of a different color
			"nosy":
				await active_cat.decrement_aura_duration()
				if team_color != active_cat.color:
					bonus_stars += 2					
				var new_log: String = active_cat.id + " was feeling nosy at " + structure_name
				print(new_log)
				await get_tree().current_scene.add_to_log(new_log)
					

		if effects.has("rehome") and StructureMan.fulfils_effect_conditions(effects["rehome"]["conditions"], "finish_activity", self, active_cat):
			await rehome(active_cat)

		if effects.has("catffeinate") and StructureMan.fulfils_effect_conditions(effects["catffeinate"]["conditions"], "finish_activity", self, active_cat):
			active_cat.curiosity = min(
				(active_cat.curiosity+effects["catffeinate"]["value"]),
				active_cat.max_curiosity
			)

		if effects.has("tire") and StructureMan.fulfils_effect_conditions(effects["tire"]["conditions"], "finish_activity", self, active_cat):
			active_cat.curiosity = max(
				(active_cat.curiosity-effects["tire"]),
				0
			)

		if effects.has("gain_aura") and StructureMan.fulfils_effect_conditions(effects["gain_aura"]["conditions"], "finish_activity", self, active_cat):
			await give_aura_to(effects["gain_aura"], active_cat)

		if effects.has("gain_equipment") and StructureMan.fulfils_effect_conditions(effects["gain_equipment"]["conditions"], "finish_activity", self, active_cat):
			await give_equipment_to(effects["gain_equipment"], active_cat)

		if effects.has("gain_ingredients") and StructureMan.fulfils_effect_conditions(effects["gain_ingredients"]["conditions"], "finish_activity", self, active_cat):
			var gain_ingredients_data = effects["gain_ingredients"]
			active_cat.gain_ingredients(gain_ingredients_data["num_ingredients"])

		if effects.has("gain_max_curiosity") and StructureMan.fulfils_effect_conditions(effects["gain_max_curiosity"]["conditions"], "finish_activity", self, active_cat):
			var gain_max_curiosity_data = effects["gain_max_curiosity"]
			active_cat.gain_max_curiosity(gain_max_curiosity_data["num_max_curiosity"])

		if effects.has("double_my_stars") and StructureMan.fulfils_effect_conditions(effects["double_my_stars"]["conditions"], "finish_activity", self, active_cat):
			await active_cat.gain_stars(active_cat.earned_stars)

		if effects.has("gain_stars") and StructureMan.fulfils_effect_conditions(effects["gain_stars"]["conditions"], "finish_activity", self, active_cat):
			await active_cat.gain_stars(effects["gain_stars"]["num_stars"])

		if effects.has("double_structure_stars") and StructureMan.fulfils_effect_conditions(effects["double_structure_stars"]["conditions"], "finish_activity", self, active_cat):
			structure_stars *= 2
			
		if effects.has("retire") and StructureMan.fulfils_effect_conditions(effects["retire"]["conditions"], "finish_activity", self, active_cat):
			active_cat.max_curiosity = 0

		if effects.has("cook_ingredients") and StructureMan.fulfils_effect_conditions(effects["cook_ingredients"]["conditions"], "finish_activity", self, active_cat):
			var cook_ingredients_data = effects["cook_ingredients"]
			active_cat.gain_stars(cook_ingredients_data["num_stars_per_ingredient"] * active_cat.num_ingredients)
			active_cat.gain_cooked_ingredients(cook_ingredients_data["num_cooked_ingredients_per_ingredient"] * active_cat.num_ingredients)
			active_cat.num_ingredients = 0
			var new_log: String = active_cat.id + " cooked some ingredients at " + structure_name
			print(new_log)
			await get_tree().current_scene.add_to_log(new_log)
		
		if effects.has("serve_ingredients") and StructureMan.fulfils_effect_conditions(effects["serve_ingredients"]["conditions"], "finish_activity", self, active_cat):
			var serve_ingredients_data = effects["serve_ingredients"]
			active_cat.gain_stars(serve_ingredients_data["num_stars_per_cooked_ingredient"] * active_cat.num_cooked_ingredients)
			active_cat.num_cooked_ingredients = 0
			await active_cat.update_cooked_ingredients_icon()
			var new_log: String = active_cat.id + " served some ingredients at " + structure_name
			print(new_log)
			await get_tree().current_scene.add_to_log(new_log)

		var earned_stars = (structure_stars * lazy_stars_multiplier * dutiful_stars_multiplier * satisfied_stars_multiplier) + bonus_stars

		await active_cat.gain_stars(earned_stars)
		earned_stars_here += earned_stars
		if earned_stars_here >= 200:
			flags = 5
		elif earned_stars_here >= 100:
			flags = 4
		elif earned_stars_here >= 50:
			flags = 3
		elif earned_stars_here >= 20:
			flags = 2
			
		await update_flag_sprite()
		
		get_tree().current_scene.add_to_log(str(active_cat.id) + " earned " + str(earned_stars) + " stars from " + structure_name)

		active_cat.leave_structure()
		cats_doing_activity.erase(active_cat)
		num_visits += 1
		visited_cats.append(active_cat.id)


func show_effects_of_cat_on_structure(cat):
	if cat.aura == "generous":
		for relative_coord in occupied_coordinates:
			var coord = relative_coord + coordinate
			var new_anim_sprite = AnimatedSprite2D.new()
			%FX.add_child(new_anim_sprite)
			new_anim_sprite.global_position = coord * Settings.TILE_LENGTH
			new_anim_sprite.sprite_frames = load("res://Assets/Structures/generous_structure_SF.tres")
			new_anim_sprite.play()
		await get_tree().create_timer(3/Settings.game_speed).timeout
		for sprite in %FX.get_children():
			sprite.queue_free()
		return
		
	if cat.aura == "prankster":
		for relative_coord in occupied_coordinates:
			var coord = relative_coord + coordinate
			var new_anim_sprite = AnimatedSprite2D.new()
			%FX.add_child(new_anim_sprite)
			new_anim_sprite.global_position = coord * Settings.TILE_LENGTH
			new_anim_sprite.sprite_frames = load("res://Assets/Structures/prankster_structure_SF.tres")
			new_anim_sprite.play()
		await get_tree().create_timer(3/Settings.game_speed).timeout
		for sprite in %FX.get_children():
			sprite.queue_free()
		return
			
	if effects.has("rehome") and num_rehomed < effects["rehome"]["conditions"]["discovery"]:
		for relative_coord in occupied_coordinates:
			var coord = relative_coord + coordinate
			var new_anim_sprite = AnimatedSprite2D.new()
			%FX.add_child(new_anim_sprite)
			new_anim_sprite.global_position = coord * Settings.TILE_LENGTH
			new_anim_sprite.sprite_frames = load("res://Assets/Structures/rehome_indicator_SF.tres")
			new_anim_sprite.play()
		await get_tree().create_timer(3/Settings.game_speed).timeout
		for sprite in %FX.get_children():
			sprite.queue_free()
		return

func update_flag_sprite():
	var flag_sprite: Object
	
	match team_color:
		"black": flag_sprite = get_node("BlackFlag")
		"white": flag_sprite = get_node("WhiteFlag")
		
	match flags:
		1: flag_sprite.animation = "Flag1"
		2: flag_sprite.animation = "Flag2"
		3: flag_sprite.animation = "Flag3"
		4: flag_sprite.animation = "Flag4"
		5: flag_sprite.animation = "Flag5"
		

func give_aura_to(aura_data, target_cat):
	target_cat.gain_aura(aura_data["type"], aura_data["duration"])


func give_equipment_to(equipment_data, target_cat):
	target_cat.gain_equipment(equipment_data["type"])


func rehome(new_cat: Object):
	var prev_home = StructureMan.get_structure_by_id(new_cat.home_id)
	prev_home.cats.erase(new_cat)
	get_tree().current_scene.add_to_log(str(new_cat.id) + " has moved from " + prev_home.structure_name + " to " + structure_name)
	new_cat.home_id = id
	cats.append(new_cat)
	num_rehomed += 1


func get_global_entrance_coordinate():
	return coordinate + entrance_coordinate


#func _on_mouse_entered() -> void:
	#structure_instance_info.visible = true
	#await structure_instance_info.update_info(self)
	#
#
#func _on_mouse_exited() -> void:
	#structure_instance_info.visible = false
	

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			var cursor_sfx = get_tree().current_scene.get_node("CursorSFX")
			cursor_sfx.stream = load(AudioMan.mouse_click)
			cursor_sfx.volume_db = 20
			cursor_sfx.play()
			
			structure_instance_info.visible = true
			await structure_instance_info.update_info(self)
