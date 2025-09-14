extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = "# HOW TO PLAY:
	As the mayor of this deserted island, purchase blueprints and
	build structures to create the best city for your clan of cats.

	A rival mayor will also be building on the same island.
	You want your clan of cats to be happier than his clan of cats.
	
	# OBJECTIVE:
	At the end of X rounds, the player with the highest number of stars wins the game.
	
	# FLOW:

	## Phases within each round
	1. Blueprint shopping phase
	2. Structure construction phase
	3. Observation phase
	4. Cleanup phase

	## Blueprint shopping phase:
	1. Blueprints are needed to build structures
	2. When players buy a blueprint, the remaining blueprint goes to the rival mayor.
	3. Players may 'upgrade shop' to gain access to special blueprints
	3. Players take turns purchasing from the 'Blueprint Shop' 
	
	## Structure construction phase:
	1. Structures can be constructed if you own their blueprints
	2. The __color__ of a structure is indicated by the color of its ground.
	3. Structures of __color__ must be built on tiles of the same __color__.
	 be built at the end of the turn automatically.
	4. Structures cannot be built on any tile adjacent to
	 any entrance of existing structures.
	5. When built, the tile belonging to the structure's entrance becomes a gold tile.

	## Observation Phase:
	1. In this phase, you cannot take any action for n seconds

	## Cleanup Phase:
	1. There are purple tiles that cannot be built on.
	2. In this phase, you can choose a specific __color__ tile.
	3. X random purple tiles will change to your chose __color__ tile.

	# RULES

	## Structures:
	1. The 'entrance' of a structure is indicated by a golden outline.
	2. Structures cannot be walked on, except on their entrances.
	3. Structures can only be visited by one cat at a time.
	
	## Cats:
	1. Cats gain stars equivalent to the structure's level each time they visit that structure.
	2. When cats walk 1 tile, they lose 1 curiosity.
	3. Cats start with 5 curiosity
	4. Cats will visit the nearest structure first.
	5. Cats will not visit the same structure again until they *rest*.
	6. When cats run out of curiosity, they return to their
	 home structure to *rest* for a certain duration.
	7. Cats can only walk on red, green and gold tiles.
	"
