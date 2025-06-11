extends Node

@onready var cat_resource = preload("res://Cats/Cat.tscn")
var cats : Dictionary
var has_moving_cats: bool = false

var all_names = [
	"Poppy", "Molly", "Luna", "Bella", "Daisy",
	"Millie", "Rosie", "Tilly", "Willow", "Lily",
	"Sooty", "Felix", "Alfie", "Misty", "Molly",
	"Poppy", "Casper", "Cookie", "Bailey", "Oreo",
	"Pepsi", "Merlot", "Freddie", "Ziggy", "Harry",
	"Marley", "Cleo", "Provolone", "Casserole", "Babybel",
	"Burger", "Burrito", "Goat", "Maple Syrup", "Dumpling",
	"Loaf", "Pepperoni", "Port", "Tazo", "Yerba",
	"Champagne", "Pop", "Cola", "Martini", "Soda",
	"Cider", "Boba", "Draco Meowfoy", "Harry Pawtter", "Purrsephone",
	"Purrseus", "Oedipuss", "Meowdusa", "Furcules", "Demeowter",
	"Apurrdite", "Pusseidon", "Apawlo", "Catlas", "Lickarus",
	"Hecate", "Bellyrubphon", "King Meowdas", "Purrmes", "Heraclaws"
]

var equipment_data = {
	"none": {},
	"tincan": {
		"zoomies": 1.5,
	},
	"skate": {
		"zoomies": 2.0,
	},
	"missile": {
		"zoomies": 2.5,
	},

}

func create_cat(color : String):
	randomize()
	var new_cat = cat_resource.instantiate()
	all_names.shuffle()
	var new_id = all_names.pop_front()
	set_cat(new_id, new_cat)
	new_cat.id = new_id
	new_cat.color = color
	new_cat.max_curiosity = Settings.BASE_CURIOSITY
	new_cat.curiosity = Settings.BASE_CURIOSITY
	new_cat.snacks = randi_range(1,5)
	new_cat.tricks = randi_range(1,5)
	new_cat.naps = randi_range(1,5)
	new_cat.num_ingredients = 0
	new_cat.num_cooked_ingredients = 0
	new_cat.rest_duration_stat = 15 # respresents the amount of time in secoonds a cat needs to rest
	new_cat.aura = "neutral"
	await new_cat.set_sprite(color, "walking")
	get_tree().current_scene.add_child(new_cat)
	new_cat.add_to_group(color)
	
	return new_cat


func set_cat(id : String, cat : Object):
	cats[id] = cat


func get_cat_from_coordinate(new_coordinate : Vector2):
	for cat in cats.values():
		if cat.get_coordinate() == new_coordinate:
			return cat
	return null
