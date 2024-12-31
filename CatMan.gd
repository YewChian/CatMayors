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

func create_cat(color : String, home_id : int):
	randomize()
	var new_cat = cat_resource.instantiate()
	all_names.shuffle()
	var new_id = all_names.pop_front()
	set_cat(new_id, new_cat)
	new_cat.id = new_id
	await new_cat.set_color(color)
	new_cat.home_id = home_id
	new_cat.max_curiosity = 6
	new_cat.curiosity = 6
	new_cat.snacks = randi_range(1,5)
	new_cat.tricks = randi_range(1,5)
	new_cat.naps = randi_range(1,5)
	await new_cat.update_size()
	get_tree().current_scene.add_child(new_cat)
	var home_structure = StructureMan.get_structure_by_id(home_id)
	new_cat.global_position = (home_structure.entrance_coordinate + home_structure.coordinate) * Settings.TILE_LENGTH
	home_structure.cats.append(new_cat)
	new_cat.add_to_group(color)
	
	new_cat.enter_state("wander")


func set_cat(id : String, cat : Object):
	cats[id] = cat


func get_cat_from_coordinate(new_coordinate : Vector2):
	for cat in cats.values():
		if cat.get_coordinate() == new_coordinate:
			return cat
	return null
