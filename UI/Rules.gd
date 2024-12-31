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
	
	Structures:
	1. When built, structures that 'Gain X cats' will
	 create X cats on the belonging to the player
	2. When visited by a cat, structures that
	 'Gain stars' will give the player owning the cat stars
	3. When visited by a cat, structures that 'Gain tricks/snacks/naps' 
	will permanently increase the respective stats of the cat
	4. The 'entrance' of a structure is indicated by a golden outline.
	5. Structures cannot be walked on, except their entrances.
	6. Structures can only be visited by one cat at a time.
	
	Cats:
	1. When cats walk 1 tile, they lose 1 curiosity.
	2. Cats will visit the nearest structure first.
	3. Cats will not visit the same structure again, until they return home.
	2. When cats run out of curiosity, they return to their
	 home structure to rest for a certain duration.
	"
