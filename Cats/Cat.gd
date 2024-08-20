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

func set_color(new_color : String):
	color = new_color
	match new_color:
		"black":
			$Bodies.texture = load("res://Assets/Cats/BlackCatBodies.png")
			$Legs.texture = load("res://Assets/Cats/BlackCatLegs.png")
			$Tails.texture = load("res://Assets/Cats/BlackCatTails.png")
		"white":
			$Bodies.texture = load("res://Assets/Cats/WhiteCatBodies.png")
			$Legs.texture = load("res://Assets/Cats/WhiteCatLegs.png")
			$Tails.texture = load("res://Assets/Cats/WhiteCatTails.png")


func update_size():
	if snacks <= 5:
			$Bodies.frame = 0
	elif snacks <= 15:
			$Bodies.frame = 1
	elif snacks <= 30:
			$Bodies.frame = 2
	elif snacks <= 60:
			$Bodies.frame = 3
	elif snacks > 60:
			$Bodies.frame = 4
		
	if tricks <= 5:
			$Tails.frame = 0
	elif tricks <= 15:
			$Tails.frame = 1
	elif tricks <= 30:
			$Tails.frame = 2
	elif tricks <= 60:
			$Tails.frame = 3
	elif tricks > 60:
			$Tails.frame = 4

	if naps <= 5:
			$Legs.frame = 0
	elif naps <= 15:
			$Legs.frame = 1
	elif naps <= 30:
			$Legs.frame = 2
	elif naps <= 60:
			$Legs.frame = 3
	elif naps > 60:
			$Legs.frame = 4

func decide_destination():
	var possible_destinations : Array[Vector2]
	for structure in StructureMan.structures.values():
		var entrance = structure.entrance_coordinate + structure.coordinate
		if entrance == StructureMan.get_structure_by_id(home_id).get_global_entrance_coordinate(): 
			continue	# skip home structure
		if entrance == get_coordinate(): 
			continue	# skip current_structure
		if len(TileMan.astar.get_point_path(TileMan.get_id(get_coordinate()), TileMan.get_id(entrance))) > curiosity:
			continue	# skip faraway structures
		if len(TileMan.astar.get_point_path(TileMan.get_id(get_coordinate()), TileMan.get_id(entrance))) == 0:
			continue	# if path is blocked
		possible_destinations.push_back(entrance)
	
	if len(possible_destinations) > 0:
		randomize()
		possible_destinations.shuffle()
		return possible_destinations.pop_front()
	
	else:
		return StructureMan.get_structure_by_id(home_id).get_global_entrance_coordinate()


		
func go_to_coordinate(target_coordinate : Vector2):
	var path = (TileMan.astar.get_point_path(TileMan.get_id(get_coordinate()), TileMan.get_id(target_coordinate)))
	for coordinate in path:
		curiosity = max(0, curiosity - 1)
		var tween = get_tree().create_tween()
		tween.tween_property(self, "global_position", coordinate*Settings.TILE_LENGTH, 1)
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
	$AnimationPlayer.play("enter_structure")
	await $AnimationPlayer.animation_finished
	interactable_structure.start_activity(self)


func leave_structure():
	$AnimationPlayer.play("leave_structure")
	await $AnimationPlayer.animation_finished
	await update_size()
	enter_state("wander")
	

func gain_snacks(number : int):
	snacks += number
	print("got some snacks: ", number)
	

func gain_tricks(number : int):
	tricks += number
	print("got some tricks: ", number)


func gain_naps(number : int):
	naps += number
	print("got some naps: ", number)
	

func gain_curiosity(number : int):
	curiosity += number
	print("got some curiosity: ", number)

	
func enter_state(new_state : String):
	var previous_state = state
	state = new_state
	match new_state:
		"wander":
			var new_destination = decide_destination()
			if new_destination == get_coordinate():
				print("Cat is already home")
				await get_tree().create_timer(5).timeout
				enter_state("wander")
				
			else:
				await go_to_coordinate(new_destination)
		
		"interact_structure":
			await interact_structure()
		
		"rest":
			if previous_state != "rest":
				$AnimationPlayer.play("enter_structure")
				await $AnimationPlayer.animation_finished
				$AnimationPlayer.play("start_rest")
			await get_tree().create_timer(1).timeout
			curiosity += 1
			if curiosity < max_curiosity:
				enter_state("rest")
			else:
				$AnimationPlayer.play("stop_rest")
				await $AnimationPlayer.animation_finished
				$AnimationPlayer.play("leave_structure")
				await $AnimationPlayer.animation_finished
				enter_state("wander")
				
		"queue":
			await get_tree().create_timer(1).timeout
			enter_state("interact_structure")

func _physics_process(delta):
	$Stats.text = str("snk/trk/nap\n" + str(snacks) + "/" + str(tricks) + "/" + str(naps))
