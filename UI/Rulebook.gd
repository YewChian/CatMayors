extends VBoxContainer

var cur_page_num = 1

var pages = {
	"1": {
		"title": "Rulebook",
		"image": "res://Assets/Cats/MissileWhiteCat/MissileWhiteCat1.png",
		"body": "
			I'm sorry you have to read all this.
			Sections:
			1. Cats
			2. Structures
			3. Tiles
			4. Auras
			5. Curiosity
			6. 
		"
	},
	"2": {
		"title": "Cats and structures",
		"image": "res://Assets/Tutorial/CatEnteringStructure.png",
		"body": "
			Cats earn stars when they visit structures.
		"
	},
	"3": {
		"title": "Phase 1/4: Buying Blueprints",
		"image": "res://Assets/Tutorial/BlueprintShop.png",
		"body": "
			You need to buy blueprints before you can build structures.
			
			Buy a blueprint at Rei's shop. The leftover blueprint will go to your opponent.
			
			If you don't like the current options, you can browse Yoshi's shop or even Tanaka's shop.
		"
		},
	"4": {
		"title": "Phase 2/4: Building Structures",
		"image": "res://Assets/Tutorial/MatchingStructuresToTiles.png",
		"body": "
			You can build structures based on the blueprints you bought.
			
			Make sure to build them on tiles of the same color as the icon on the top right.
			
			The shape of the structure matters too.
			
			Note that cats can't walk through structures, but they can walk through the entrances.
		"
		},
	"5": {
		"title": "Phase 3/4 Observation",
		"image": "res://Assets/Cats/MissileWhiteCat/MissileWhiteCat1.png",
		"body": "
			You can click on structures to view more information while observing your town.
			
			You can click and drag to pan around the map.
		"
		},
	"6": {
		"title": "Phase 4/4 Landscaping",
		"image": "res://Assets/Tutorial/Landscaping.png",
		"body": "
			This is a chance to remove some purple tiles from the island.
			
			You cannot build any structures on purple tiles.
		"
	},
	"7": {
		"title": "When does the game end?",
		"image": "res://Assets/Cats/MissileWhiteCat/MissileWhiteCat1.png",
		"body": "
			Do the same things mentioned above for 4 rounds.
			
			Get the most number of stars to win.
		"
	},
}

func _ready() -> void:
	await show_page(1)


func show_page(page_number: int):
	%SkipTutorial.text = "TO GAME"
	var page_data = pages[str(page_number)]
	var title = page_data["title"]
	var image = page_data["image"]
	var body = page_data["body"]
	
	%TutorialTitle.text = title
	%TutorialImage.texture = load(image)
	%TutorialText.text = body
	%PageNumber.text = str(page_number) + "/" + str(len(pages))


func _on_left_pressed() -> void:
	cur_page_num = max(1, cur_page_num - 1)
	show_page(cur_page_num)


func _on_right_pressed() -> void:
	cur_page_num = min(len(pages), cur_page_num + 1)
	show_page(cur_page_num)


func _on_skip_pressed() -> void:
	await get_tree().current_scene.hide_tutorial()
	get_tree().current_scene.start_game()
