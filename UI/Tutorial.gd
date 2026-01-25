extends VBoxContainer

var cur_page_num = 1
var called_from: String = ""

var pages = {
	"1": {
		"title": "Pause / Tutorial",
		"image": "res://Assets/Cats/MissileWhiteCat/MissileWhiteCat1.png",
		"body": "
			Welcome to Whiskertown! It's just a deserted island right now.
			
			Build structures to make your cats happier than your opponent's cats.
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
		"title": "Entrances",
		"image": "res://Assets/Tutorial/CatEnteringStructure.png",
		"body": "
			To visit structures, they need to walk into its entrance.

			The entrance is denoted by a yellow box.
		"
	},
	"4": {
		"title": "How cats walk",
		"image": "res://Assets/Tutorial/CatCuriosityCircled.png",
		"body": "
			To walk from tile to tile, cats will consume 1 curiosity.

			Each cat starts with 5 curiosity.
		"
	},
	"5": {
		"title": "How cats decide to walk",
		"image": "res://Assets/Tutorial/CatResting.png",
		"body": "
			Cats will walk to the nearest structure until they run out of curiosity.

			When they run out of curiosity, they will go home to rest for a long time.
		"
	},
	"6": {
		"title": "How cats get blocked",
		"image": "res://Assets/Tutorial/CatAngry.png",
		"body": "
			Cats cant walk over existing structures.

			But they can walk over structure entrances.

			They also can't walk on water.
		"
	},
	"7": {
		"title": "Phase 1/4: Buying Blueprints",
		"image": "res://Assets/Tutorial/BlueprintShop.png",
		"body": "
			First part of a round: Blueprint Shop

			You need to buy blueprints before you can build structures.
		"
		},
	"8": {
		"title": "Phase 2/4: Building Structures",
		"image": "res://Assets/Tutorial/MatchingStructuresToTiles.png",
		"body": "
			Second part of a round: Construction
			
			The icon on the top right of a structure determines the type of tiles you can build on.
			
			The shape of the structure matters too.
		"
		},
	"9": {
		"title": "Phase 3/4 Observation",
		"image": "res://Assets/Cats/MissileWhiteCat/MissileWhiteCat1.png",
		"body": "
			Third part of a round: Observation

			You can click on structures to view more information while observing your town.
			
			You can click and drag to pan around the map.
		"
		},
	"10": {
		"title": "Phase 4/4 Landscaping",
		"image": "res://Assets/Tutorial/Landscaping.png",
		"body": "
			Fourth part of a round: Landscaping

			Purple tiles prevent you from building structures.

			This is a chance to remove some purple tiles from the island.
		"
	},
	"11": {
		"title": "End of Basic Tutorial",
		"image": "res://Assets/Cats/MissileWhiteCat/MissileWhiteCat1.png",
		"body": "
			You can go ahead and start the game.

			If you like to view this tutorial again, hit pause.

			If you want to read the detailed rules, continue with the right arrow.
		"
	},
	"12": {
		"title": "Detailed Rules",
		"image": "res://Assets/Cats/MissileWhiteCat/MissileWhiteCat1.png",
		"body": "
			Continue reading for the detailed rules
		"
	},
	"13": {
		"title": "Cat movement",
		"image": "res://Assets/Cats/MissileWhiteCat/MissileWhiteCat1.png",
		"body": "
			1. Cats move 1 tile per curiosity
			2. Cats always visit the structure with the nearest entrance
				a. If there is more than one nearest structure, cats will visit a random one
			3. Cats can walk on every tile except blue tiles and tiles occupied by structures
			4. Cats can walk on structure entrances
			5. Cats do not consume curiosity when returning home
			6. Cats have their curiosity restored after resting at home
		"
	},
	"14": {
		"title": "Cats visiting structures",
		"image": "res://Assets/Cats/MissileWhiteCat/MissileWhiteCat1.png",
		"body": "
			1. Only 1 cat can visit a structure at a time.
			2. When a cat visits a structure, it stays there for a
				duration specified on the top left of that structure's info
			3. After a cat visits the structure, it gains
				stars equal to the number specified on the 
				top left of that structure's info
			4. After a cat visits the structure, it may gain bonuses if 
				some conditions are fulfilled
		"
	},
	"15": {
		"title": "Auras",
		"image": "res://Assets/Cats/MissileWhiteCat/MissileWhiteCat1.png",
		"body": "
			1. When a cat gains an aura, the aura will be shown with a 
				small speech bubble above the cat.
			2. Generous Aura: The next structure this cat visits will
				gain +1 structure_stars. This means that future cats that
				visit this structure will gain an additional star.
			3. Nosy Aura: If the next structure this cat visits belongs to
				the opposing team, this cat gains bonus stars
			4. Lazy Aura: This cat does not gain stars from the next structure it visits.
			5. Prankster Aura: The next structure this cat visits loses
				1 structure star.
			6. Satisfied Aura: The next structure this cat visits gives
				x2 stars, but this cat loses all its curiosity after the visit
		"
	},
	"16": {
		"title": "Curiosity and Max Curiosity",
		"image": "res://Assets/Cats/MissileWhiteCat/MissileWhiteCat1.png",
		"body": "
			1. When a cat gains curiosity, it will temporarily walk further.
			2. When a cat gains max curiosity, it will permanently walk further
		"
	},
	"17": {
		"title": "Home",
		"image": "res://Assets/Cats/MissileWhiteCat/MissileWhiteCat1.png",
		"body": "
			1. When a structure with 'Home X cats' is built, the player who built
				it gains X number of cats.
			2. These cats will always return to this home structure to rest
		"
	},
	"18": {
		"title": "Rehome",
		"image": "res://Assets/Cats/MissileWhiteCat/MissileWhiteCat1.png",
		"body": "
			1. When a cat visits a structure with 'Rehome' and its conditions are met, the
				cat sets this structurea as its new home. The player's ownership of
				the cat does not change.
		"
	},
	"19": {
		"title": "Gaining Ingredients",
		"image": "res://Assets/Cats/MissileWhiteCat/MissileWhiteCat1.png",
		"body": "
			1. When a cat visits a structure with 'Gain X ingredients' and its conditions are met, 
				the cat gains X ingredients as shown by the fish icon.
			2. If the next structure a cat visits does NOT have 'Gain X ingredients',
				the cat loses all its ingredients
			3. If a cat with ingredients visits a structure with 'Gain X cooked ingredients',
				the cat loses all its ingredients but gains cooked ingredients and a
				large number of stars
		"
	},
	"20": {
		"title": "Cooking Ingredients",
		"image": "res://Assets/Cats/MissileWhiteCat/MissileWhiteCat1.png",
		"body": "
			1. When a cat visits a structure with 'Gain X cooked ingredients' and its conditions are met, 
				the cat gains X cooked ingredients as shown by the sliced fish icon.
			2. If the next structure a cat visits does NOT have 'Gain X cooked ingredients',
				the cat loses all its cooked ingredients
			3. If a cat with cooked ingredients visits a structure with 'Serve X cooked ingredients',
				the cat loses all its ingredients but gains massive number of stars
		"
	},
	"21": {
		"title": "Serving Ingredients",
		"image": "res://Assets/Cats/MissileWhiteCat/MissileWhiteCat1.png",
		"body": "
			1. When a cat visits a structure with 'Serve cooked ingredients' and its conditions are met, 
				the cat gains a massive number of stars per cooked ingredient and loses all cooked ingredients.
		"
	},
	"22": {
		"title": "Browsing Shops",
		"image": "res://Assets/Cats/MissileWhiteCat/MissileWhiteCat1.png",
		"body": "
			1. When you click on 'Browse X', you will be unable to browse the previous
				shop for a turn. You will always start browsing Simple Sketches.
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
	assert(called_from != "")
	if called_from == "title":
		get_tree().current_scene.start_game()
