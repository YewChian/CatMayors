extends Node

@onready var cat_resource = preload("res://Cats/Cat.tscn")
var cats : Dictionary
var has_moving_cats: bool = false

var all_names = [
	"Alfred", "Arthur", "Barroth", "Benedict", "Charles",
	"Evelyn", "Winifred", "Theodore", "Gilbert", "Penelope",
	"Henry", "Jasper", "Frederick",  "Malcolm", "Miriam",
	"Eloise", "Beatrice", "Rosalind", "Harold", "Edmund",
	"Agatha", "Ambrose", "Gwendolyn", "Wilfred", "Vincent",
	"Ethel", "Tobias", "Cedric", "Octavia", "Lawrence",
	"Mabel", "Percival", "Lillian", "Rupert", "Sybil",
	"Gideon", "Hugo", "Eleanor", "Gerald",  "Genevieve",
	"Isadora", "Lionel", "Gareth", "Raymond",  "Audrey",
	"Edgar", "Magnus", "Nathaniel", "Florence", "Felicity",
	"Bernard", "Philip", "Chester", "Imogen", "Matilda",
	"Walter", "Augustus", "Winston", "Mortimer", "Adelaide",
	"Elsie", "Cyril", "Sebastian",  "Clementine", "Harriet",
	"Oliver", "Gregory", "Francis", "Josephine", "Blanche",
	"Wilbur", "Alexander", "Roger", "Theodora",  "Margaret",
	"Louis", "Oscar", "Silas", "Bertha", "Constance",
	"Clara", "Alonzo", "Maxwell", "Horatio", "Ethelred",
	"Mildred", "Eustace", "Franklin", "Ophelia", "Dorothy",
	"Gladys", "Edwin", "Ralph", "Hilda", "Rosemary"
]

# cat puns:
# meow
# paws
# purr
# whiskers
# nya
# catnap
# cat
# feline

var personalities = {
	"ruffian": {
		"going home": [
			"Myehehe... let's knock over that cup on the way home.",
		],
		"frequent visit": [
			"Who needs meowsponsibilities when I can go to (SHOP NAME) everyday.",
			"I'm getting too attached to (SHOP NAME) for meow own good.",
		],
		"bored": [
			"If only I could cause a ruckus in more places...",
			"NYAN GETTING SO SICK OF VISITING THE SAME BUILDINGS!",
		]
	},
	"stoner": {
		"going home": [
			"...paws are tired...",
		],
		"frequent visit": [
			"...i like...",
			"...nyat bad...",
		],
		"bored": [
			"...wasn't interested anyways...",
			"...bored...",
		]
	}
}

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
	new_cat.rest_duration_stat = 5 # respresents the amount of time in secoonds a cat needs to rest
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
