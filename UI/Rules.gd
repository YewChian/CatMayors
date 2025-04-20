extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = "HOW TO PLAY:
	As the mayor of this deserted island, build the best assortment of
	 structures to create the best city for your clan of cats.
	 A rival mayor will also be building on the same island as you,
	 but will be focusing on their clan of cats instead.
	
	OBJECTIVE:
	At the end of X rounds, the player with the highest number of stars wins the game.
	
	RULES:
	Blueprints:
	1. Players may only buy blueprints during the 'Blueprint Shop' Phase.
	2. When players buy a blueprint, the remaining blueprint goes to the rival mayor.
	3. Players take turns purchasing from the 'Blueprint Shop'
	
	Construction:
	1. The color type of a structure is indicated by the color of its ground.
	2. Structures of each color type must be built on tiles of that color type.
	3. Structures that are placed in valid tiles will
	 be built at the end of the turn automatically.
	4. Structures cannot be built on any tile adjacent to
	 any entrance of existing structures.
	5. When built, the tile belonging to the structure's entrance becomes a green tile.

	Structures:
	1. The 'entrance' of a structure is indicated by a golden outline.
	2. Structures cannot be walked on, except their entrances.
	3. Structures can only be visited by one cat at a time.
	
	Cats:
	1. Cats gain stars equivalent to the structure's level each time they visit that structure.
	2. When cats walk 1 tile, they lose 1 curiosity.
	3. Cats will visit the nearest structure first.
	4. Cats will not visit the same structure again, until they return home.
	5. When cats run out of curiosity, they return to their
	 home structure to rest for a certain duration.
	"
