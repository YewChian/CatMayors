extends Node

var structures : Dictionary = {
	"Fishing Hut" : {	# merchant
		"rarity": "epic",
		"path": "res://Structures/FishingHut.tscn",
		"icon": "res://UI/StructureIcons/FishingHutIcon.tres",
		"sprite": "res://Assets/Structures/FishingHut.png",
		"sprite_offset": Vector2(96, 64),
		"color": "blue",
		"occupied_coordinates": [
			Vector2(0,0),
			Vector2(1,0),
			Vector2(2,0),
			Vector2(3,0),
			Vector2(0,1),
			Vector2(1,1),
			Vector2(2,1),
			Vector2(3,1),
			Vector2(0,2),
			Vector2(1,2),
			Vector2(2,2),
			Vector2(3,2),
		],
		"entrance_coordinate": Vector2(1, 0),
		"activity_duration": 10,
		"structure_stars": 3,
		"flavor": "food source",
		"effects": {
			"home": {
				"conditions": {
					"build": -1,
				},
				"num_cats": 2,
			},
			"gain_ingredients": {
				"conditions": {
					"visit": -1,
				},
				"num_ingredients": 1,
			},
		},
	},
	"Bobcat Workshop" : {
		"rarity": "common", # kingdom, merchant
		"path": "res://Structures/LumbercatYard.tscn",
		"icon": "res://UI/StructureIcons/LumbercatYardIcon.tres",
		"sprite": "res://Assets/Structures/LumbercatYard.png",
		"sprite_offset": Vector2(32, 32),
		"color": "red",
		"occupied_coordinates": [
			Vector2(0,0),
			Vector2(1,0),
			Vector2(0,1),
			Vector2(1,1),
		],
		"entrance_coordinate": Vector2(1, 1),
		"activity_duration": 10,
		"structure_stars": 2,
		"flavor": "improves the levels of nearby buildings",
		"effects": {
			"home": {
				"conditions": {
					"build": -1,
				},
				"num_cats": 1,
			},
			"gain_aura": {
				"conditions": {
					"discovery": 2,
				},
				"type": "generous",
				"duration": 1,
			},
		}
	},
	"Tuna Factory" : {	# merchant
		"rarity": "rare",
		"path": "res://Structures/TunaFactory.tscn",
		"icon": "res://UI/StructureIcons/TunaFactoryIcon.tres",
		"sprite": "res://Assets/Structures/TunaFactory.png",
		"sprite_offset": Vector2(32, 64),
		"color": "green",
		"occupied_coordinates": [
			Vector2(1,0),
			Vector2(0,1),
			Vector2(1,1),
			Vector2(0,2),
			Vector2(1,2),
		],
		"entrance_coordinate": Vector2(0, 2),
		"activity_duration": 10,
		"structure_stars": 2,
		"flavor": "when i grow up, i want to work in a tuna factory",
		"effects": {
			"rehome": {
				"conditions": {
					"discovery": 2,
				},
			},
			"gain_aura": {
				"conditions": {
					"discovery": 2,
				},
				"type": "generous",
				"duration": 3,
			},
			"cook_ingredients": {
				"conditions": {
					"visit": -1,
					"has_ingredients": 1,
				},
				"num_cooked_ingredients_per_ingredient": 3,
				"num_stars_per_ingredient": 2,
			},
		},
	},
	"Rock" : {	# invasion
		"rarity": "rare",
		"path": "res://Structures/Rock.tscn",
		"icon": "res://UI/StructureIcons/Rock.tres",
		"sprite": "res://Assets/Structures/Rock.png",
		"sprite_offset": Vector2(0,0),
		"color": "red",
		"occupied_coordinates": [
			Vector2(0,0),
		],
		"entrance_coordinate": Vector2(0, 0),
		"activity_duration": 1,
		"structure_stars": 0,
		"flavor": "do you live under a rock",
		"effects": {
			"home": {
				"conditions": {
					"build": -1,
				},
				"num_cats": 1,
			}
		},
	},
	"Flowerbed" : { # invasion, kingdom
		"rarity": "common",
		"path": "res://Structures/Flowerbed.tscn",
		"icon": "res://UI/StructureIcons/Flowerbed.tres",
		"sprite": "res://Assets/Structures/Flowerbed.png",
		"sprite_offset": Vector2(0,0),
		"color": "green",
		"occupied_coordinates": [
			Vector2(0,0),
		],
		"entrance_coordinate": Vector2(0, 0),
		"activity_duration": 1,
		"structure_stars": 0,
		"flavor": "we love stepping on flowers",
		"effects": {
			"catffeinate": {
				"conditions": {
					"visit": -1,
				},
				"value": 1
			},
			"terraform": {
				"conditions": {
					"build": -1,
				},
				"coordinates": [	# with respect to 0,0
					Vector2(0,-1),
					Vector2(-1,0),
					Vector2(1,0),
					Vector2(0,1),
				],
				"color": "green",
			}
		},
	},
	"Pile Of Clean Laundry" : {
		"rarity": "epic", # kingdom
		"path": "res://Structures/PileOfCleanLaundry.tscn",
		"icon": "res://UI/StructureIcons/PileOfCleanLaundry.tres",
		"sprite": "res://Assets/Structures/PileOfCleanLaundry.png",
		"sprite_offset": Vector2(0,0),
		"color": "green",
		"occupied_coordinates": [
			Vector2(0,0),
		],
		"entrance_coordinate": Vector2(0, 0),
		"activity_duration": 1,
		"structure_stars": 0,
		"flavor": "perfect resting spot",
		"effects": {
			"rehome": {
				"conditions": {
					"discovery": 1,
				},
			},
			"double_my_stars": {
				"conditions": {
					"discovery": 1,
				}
			},
			"retire": {
				"conditions": {
					"discovery": 1,
				}
			},
		},
	},
	"Floating Planks" : {
		"rarity": "rare", # invasion
		"path": "res://Structures/FloatingPlanks.tscn",
		"icon": "res://UI/StructureIcons/FloatingPlanks.tres",
		"sprite": "res://Assets/Structures/FloatingPlanks.png",
		"sprite_offset": Vector2(0,0),
		"color": "blue",
		"occupied_coordinates": [
			Vector2(0,0),
		],
		"entrance_coordinate": Vector2(0, 0),
		"activity_duration": 1,
		"structure_stars": 0,
		"flavor": "just a few planks",
		"effects": {
			"gain_aura": {
				"conditions": {
					"discovery": 5,
				},
				"type": "nosy",
				"duration": 2,
			},
		},
	},
	"Oak Treehouse" : {	# kingdom
		"rarity": "common",
		"path": "res://Structures/TowerTree.tscn",
		"icon": "res://UI/StructureIcons/TowerTree.tres",
		"sprite": "res://Assets/Structures/TowerTree.png",
		"sprite_offset": Vector2(64, 32),
		"color": "green",
		"occupied_coordinates": [
			Vector2(0,0),
			Vector2(1,0),
			Vector2(2,0),
			Vector2(1,1),
		],
		"entrance_coordinate": Vector2(1, 1),
		"activity_duration": 5,
		"structure_stars": 2,
		"flavor": "must visit",
		"effects": {
			"home": {
				"conditions": {
					"build": -1,
				},
				"num_cats": 1,
			},
			"catffeinate": {
				"conditions": {
					"visit": -1,
				},
				"value": 1
			},
		},
	},
	"Round Fountain" : {	# kingdom
		"rarity": "common",
		"path": "res://Structures/Fountain.tscn",
		"icon": "res://UI/StructureIcons/Fountain.tres",
		"sprite": "res://Assets/Structures/Fountain.png",
		"sprite_offset": Vector2(32, 32),
		"color": "green",
		"occupied_coordinates": [
			Vector2(0,0),
			Vector2(1,0),
			Vector2(0,1),
			Vector2(1,1),
		],
		"entrance_coordinate": Vector2(1, 0),
		"activity_duration": 5,
		"structure_stars": 3,
		"flavor": "meow meow meow meow",
		"effects": {
			"gain_aura": {
				"conditions": {
					"discovery": 1,
				},
				"type": "lazy",
				"duration": 2,
			}
		},
	},
	"Catbed Campground" : {	# invasion
		"rarity": "rare",
		"path": "res://Structures/Catbeds.tscn",
		"icon": "res://UI/StructureIcons/Catbeds.tres",
		"sprite": "res://Assets/Structures/Catbeds.png",
		"sprite_offset": Vector2(0, 96),
		"color": "green",
		"occupied_coordinates": [
			Vector2(0,0),
			Vector2(0,1),
			Vector2(0,2),
			Vector2(0,3),
		],
		"entrance_coordinate": Vector2(0, 0),
		"activity_duration": 5,
		"structure_stars": 0,
		"flavor": "meow meow meow",
		"effects": {
			"rehome": {
				"conditions": {
					"discovery": 4,
				},
			},
			"gain_max_curiosity": {
				"conditions": {
					"discovery": 4,
				},
				"num_max_curiosity": 10
			},
		},
	},
	"Catnip Alley" : {	# invasion
		"rarity": "rare",
		"path": "res://Structures/CatnipAlley.tscn",
		"icon": "res://UI/StructureIcons/CatnipAlley.tres",
		"sprite": "res://Assets/Structures/CatnipAlley.png",
		"sprite_offset": Vector2(32, 32),
		"color": "red",
		"occupied_coordinates": [
			Vector2(0,0),
			Vector2(0,1),
			Vector2(1,1),
		],
		"entrance_coordinate": Vector2(1, 1),
		"activity_duration": 5,
		"structure_stars": 1,
		"flavor": "shhh",
		"effects": {
			"rehome": {
				"conditions": {
					"discovery": 1,
				},
			},
			"gain_max_curiosity": {
				"conditions": {
					"discovery": 1,
				},
				"num_max_curiosity": 10
			},
			"gain_aura": {
				"conditions": {
					"discovery": 1,
				},
				"type": "prankster",
				"duration": 10,
			},
		},
	},
	"Scratch Post" : {	# kingdom
		"rarity": "epic",
		"path": "res://Structures/ScratchPost.tscn",
		"icon": "res://UI/StructureIcons/ScratchPost.tres",
		"sprite": "res://Assets/Structures/ScratchPost.png",
		"sprite_offset": Vector2(32, 32),
		"color": "green",
		"occupied_coordinates": [
			Vector2(0,0),
			Vector2(1,0),
			Vector2(0,1),
			Vector2(1,1),
		],
		"entrance_coordinate": Vector2(0, 0),
		"activity_duration": 5,
		"structure_stars": 2,
		"flavor": "neighborhood post office",
		"effects": {
			"gain_aura": {
				"conditions": {
					"discovery": 5,
				},
				"type": "generous",
				"duration": 1,
			},
			"gain_max_curiosity": {
				"conditions": {
					"discovery": 5,
				},
				"num_max_curiosity": 3 
			},
		},
	},
	"The Catto" : {
		"rarity": "epic",	# kingdom
		"path": "res://Structures/TriComplex.tscn",
		"icon": "res://UI/StructureIcons/TriComplex.tres",
		"sprite": "res://Assets/Structures/TriComplex.png",
		"sprite_offset": Vector2(32, 64),
		"color": "green",
		"occupied_coordinates": [
			Vector2(0,0),
			Vector2(1,0),
			Vector2(0,1),
			Vector2(1,1),
			Vector2(0,2),
			Vector2(1,2),
		],
		"entrance_coordinate": Vector2(0,2),
		"activity_duration": 1,
		"structure_stars": 0, 
		"flavor": "its got a roof",
		"effects": {
			"home": {
				"conditions": {
					"build": -1,
				},
				"num_cats": 4,
			},
			"gain_aura": {
				"conditions": {
					"discovery": 4,
				},
				"type": "prankster",
				"duration": 2,
			},
		},
	},
	"Little Red House" : {	# invasion
		"rarity": "common",
		"path": "res://Structures/LittleRedHouse.tscn",
		"icon": "res://UI/StructureIcons/LittleRedHouse.tres",
		"sprite": "res://Assets/Structures/LittleRedHouse.png",
		"sprite_offset": Vector2(0, 32),
		"color": "green",
		"occupied_coordinates": [
			Vector2(0,0),
			Vector2(0,1),
		],
		"entrance_coordinate": Vector2(0,1),
		"activity_duration": 3,
		"structure_stars": 0,
		"flavor": "cats are colorblind",
		"effects": {
			"home": {
				"conditions": {
					"build": -1,
				},
				"num_cats": 2,
			},
		},
	},
	"Hostel Good Neet" : {	# merchant
		"rarity": "common",
		"path": "res://Structures/HostelGoodNeet.tscn",
		"icon": "res://UI/StructureIcons/HostelGoodNeet.tres",
		"sprite": "res://Assets/Structures/HostelGoodNeet.png",
		"sprite_offset": Vector2(32, 32),
		"color": "green",
		"occupied_coordinates": [
			Vector2(0,0),
			Vector2(1,0),
			Vector2(0,1),
			Vector2(1,1),
		],
		"entrance_coordinate": Vector2(0, 1),
		"activity_duration": 1,
		"structure_stars": 1,
		"flavor": "a haven for lazy cats",
		"effects": {
			"home": {
				"conditions": {
					"build": -1,
				},
				"num_cats": 1,
			},
			"rehome": {
				"conditions": {
					"discovery": 1,
				},
			},
		},
	},
	"Tall Sea Wall" : {	# invasion
		"rarity": "epic",
		"path": "res://Structures/TallSeaWall.tscn",
		"icon": "res://UI/StructureIcons/TallSeaWall.tres",
		"sprite": "res://Assets/Structures/TallSeaWall.png",
		"sprite_offset": Vector2(0, 64),
		"color": "blue",
		"occupied_coordinates": [
			Vector2(0,0),
			Vector2(0,1),
			Vector2(0,2),
		],
		"entrance_coordinate": Vector2(0, 2),
		"activity_duration": 5,
		"structure_stars": 1,
		"flavor": "not many have attempted to scale the wall of mediocrity",
		"effects": {
			"gain_max_curiosity": {
				"conditions": {
					"discovery": 1,
				},
				"num_max_curiosity": 20
			},
		},
	},
	"Shabby Shrine" : {	# invasion
		"rarity": "epic",
		"path": "res://Structures/ShabbyShrine.tscn",
		"icon": "res://UI/StructureIcons/ShabbyShrine.tres",
		"sprite": "res://Assets/Structures/ShabbyShrine.png",
		"sprite_offset": Vector2(0, 32),
		"color": "green",
		"occupied_coordinates": [
			Vector2(0,0),
			Vector2(0,1),
		],
		"entrance_coordinate": Vector2(0,0),
		"activity_duration": 3,
		"structure_stars": 1,
		"flavor": "for well-traveled cats",
		"effects": {
			"gain_stars": {
				"conditions": {
					"visit": -1,
					"wise": 4,
				},
				"num_stars": 5,
			},
			"catffeinate": { 
				"conditions": {
					"visit": -1,
				},
				"value": 1,
			}
		},
	},
	"Town Hall" : { # kingdom
		"rarity": "rare",	
		"path": "res://Structures/TownHall.tscn",
		"icon": "res://UI/StructureIcons/TownHall.tres",
		"sprite": "res://Assets/Structures/TownHall.png",
		"sprite_offset": Vector2(64, 64),
		"color": "green",
		"occupied_coordinates": [
			Vector2(0,0),
			Vector2(1,0),
			Vector2(2,0),
			Vector2(0,1),
			Vector2(1,1),
			Vector2(2,1),
			Vector2(0,2),
			Vector2(1,2),
			Vector2(2,2),
		],
		"entrance_coordinate": Vector2(1, 2),
		"activity_duration": 5,
		"structure_stars": 4,
		"flavor": "its a town hall",
		"effects": {
			"double_structure_stars": {
				"conditions": {
					"discovery": 1,
					"historical": 50,
				},
				"value": -1,
			},
		},
	},
	"Hydrant" : {
		"rarity": "rare",	# kingdom
		"path": "res://Structures/Hydrant.tscn",
		"icon": "res://UI/StructureIcons/Hydrant.tres",
		"sprite": "res://Assets/Structures/Hydrant.png",
		"sprite_offset": Vector2(0,0),
		"color": "green",
		"occupied_coordinates": [
			Vector2(0,0),
		],
		"entrance_coordinate": Vector2(0, 0),
		"activity_duration": 1,
		"structure_stars": 1,
		"flavor": "who would build this?",
		"effects": {
		},
	},
	"Trashcan" : {	# kingdom 	# cat rolls around in a pringles can
		"rarity": "common",
		"path": "res://Structures/Trashcan.tscn",
		"icon": "res://UI/StructureIcons/Trashcan.tres",
		"sprite": "res://Assets/Structures/Trashcan.png",
		"sprite_offset": Vector2(0,0),
		"color": "green",
		"occupied_coordinates": [
			Vector2(0,0),
		],
		"entrance_coordinate": Vector2(0, 0),
		"activity_duration": 5,
		"structure_stars": 1,
		"flavor": "a trashcan",
		"effects": {
			"home": {
				"conditions": {
					"build": -1,
				},
				"num_cats": 1,
			},
			"gain_ingredients": {
				"conditions": {
					"visit": -1,
				},
				"num_ingredients": 1,
			},
			"gain_equipment": {
				"conditions": {
					"discovery": 1,
				},
				"type": "tincan",
			},
		},
	},
	"Bobcat Guild" : {	# kingdom
		"rarity": "rare",
		"path": "res://Structures/WoodWorks.tscn",
		"icon": "res://UI/StructureIcons/WoodWorks.tres",
		"sprite": "res://Assets/Structures/WoodWorks.png",
		"sprite_offset": Vector2(0,32),
		"color": "red",
		"occupied_coordinates": [
			Vector2(0,0),
			Vector2(0,1),
		],
		"entrance_coordinate": Vector2(0, 0),
		"activity_duration": 5,
		"structure_stars": 1,
		"flavor": "meow",
		"effects": {
			"gain_aura": {
				"conditions": {
					"visit": -1,
				},
				"type": "satisfied",
				"duration": 1,
			},
		},
	},
	"Tsubaki Bush" : {	# invasion
		"rarity": "common",
		"path": "res://Structures/BerryBush.tscn",
		"icon": "res://UI/StructureIcons/BerryBush.tres",
		"sprite": "res://Assets/Structures/BerryBush.png",
		"sprite_offset": Vector2(32,0),
		"color": "red",
		"occupied_coordinates": [
			Vector2(0,0),
			Vector2(1,0),
		],
		"entrance_coordinate": Vector2(0, 0),
		"activity_duration": 3,
		"structure_stars": 1,
		"flavor": "a flowery bush",
		"effects": {
			"catffeinate": { 
				"conditions": {
					"visit": -1,
				},
				"value": 2,
			},
		},
	},
	"Fish Gutter" : {	# merchant
		"rarity": "rare",
		"path": "res://Structures/FishGutter.tscn",
		"icon": "res://UI/StructureIcons/FishGutter.tres",
		"sprite": "res://Assets/Structures/FishGutter.png",
		"sprite_offset": Vector2(0,0),
		"color": "green",
		"occupied_coordinates": [
			Vector2(0,0),
		],
		"entrance_coordinate": Vector2(0, 0),
		"activity_duration": 10,
		"structure_stars": 1,
		"flavor": "Don't ask him about his fishbone collection.",
		"effects": {
			"cook_ingredients": {
				"conditions": {
					"visit": -1,
					"has_ingredients": 1,
				},
				"num_cooked_ingredients_per_ingredient": 2,
				"num_stars_per_ingredient": 2,
			},
		},
	},
	"Benches" : {	# invasion, kingdom
		"rarity": "rare",
		"path": "res://Structures/Benches.tscn",
		"icon": "res://UI/StructureIcons/Benches.tres",
		"sprite": "res://Assets/Structures/Benches.png",
		"sprite_offset": Vector2(0,0),
		"color": "red",
		"occupied_coordinates": [
			Vector2(0,0),
		],
		"entrance_coordinate": Vector2(0, 0),
		"activity_duration": 10,
		"structure_stars": 0,
		"flavor": "helps visitors rest",
		"effects": {
			"catffeinate": { 
				"conditions": {
					"visit": -1,
				},
				"value": 3,
			},
			"gain_aura": {
				"conditions": {
					"visit": -1,
				},
				"type": "satisfied",
				"duration": 1,
			},
		},
	},
	"Pawson" : {	# kingdom, merchant
		"rarity": "epic",
		"path": "res://Structures/Pawson.tscn",
		"icon": "res://UI/StructureIcons/Pawson.tres",
		"sprite": "res://Assets/Structures/Pawson.png",
		"sprite_offset": Vector2(32, 32),
		"color": "red",
		"occupied_coordinates": [
			Vector2(0,0),
			Vector2(1,0),
			Vector2(1,1),
		],
		"entrance_coordinate": Vector2(1, 1),
		"activity_duration": 5,
		"structure_stars": 1,
		"flavor": "great desserts. and sushi.",
		"effects": {	# serve ingredients
			"serve_ingredients": {
				"conditions": {
					"visit": -1,
					"has_cooked_ingredients": 1,
				},
				"num_stars_per_cooked_ingredient": 2,
			},
			"gain_aura": {
				"conditions": {
					"discovery": 3,
				},
				"type": "prankster",
				"duration": 1,
			},
		},
	},
	"Quiet Farmhouse" : {	# kingdom
		"rarity": "rare",
		"path": "res://Structures/QuietFarmhouse.tscn",
		"icon": "res://UI/StructureIcons/QuietFarmhouse.tres",
		"sprite": "res://Assets/Structures/QuietFarmhouse.png",
		"sprite_offset": Vector2(32, 32),
		"color": "red",
		"occupied_coordinates": [
			Vector2(0,0),
			Vector2(1,0),
			Vector2(0,1),
			Vector2(1,1),
		],
		"entrance_coordinate": Vector2(0, 0),
		"activity_duration": 3,
		"structure_stars": 3,
		"flavor": "A big house in the hills",
		"effects": {
			"home": {
				"conditions": {
					"build": -1,
				},
				"num_cats": 2,
			},
		},
	},
	"Junkyard" : {	# kingdom	# salvages a missile
		"rarity": "epic",
		"path": "res://Structures/Junkyard.tscn",
		"icon": "res://UI/StructureIcons/Junkyard.tres",
		"sprite": "res://Assets/Structures/Junkyard.png",
		"sprite_offset": Vector2(32, 32),
		"color": "red",
		"occupied_coordinates": [
			Vector2(0,0),
			Vector2(0,1),
			Vector2(1,1),
		],
		"entrance_coordinate": Vector2(0, 0),
		"activity_duration": 1,
		"structure_stars": 1,
		"flavor": "",
		"effects": {
			"home": {
				"conditions": {
					"build": -1,
				},
				"num_cats": 1,
			},
			"gain_equipment": {
				"conditions": {
					"discovery": 1,
				},
				"type": "missile",
			},
		},
	},
	"Skatepark" : {	# sits in a giant rollerblade
		"rarity": "rare",
		"path": "res://Structures/Skatepark.tscn",
		"icon": "res://UI/StructureIcons/Skatepark.tres",
		"sprite": "res://Assets/Structures/Skatepark.png",
		"sprite_offset": Vector2(64, 32),
		"color": "green",
		"occupied_coordinates": [
			Vector2(1,0),
			Vector2(0,1),
			Vector2(1,1),
			Vector2(2,1),
		],
		"entrance_coordinate": Vector2(1, 0),
		"activity_duration": 5,
		"structure_stars": 1,
		"flavor": "",
		"effects": {
			"gain_equipment": {
				"conditions": {
					"discovery": 1,
				},
				"type": "skate",
			},
			"gain_max_curiosity": {
				"conditions": {
					"discovery": 1,
				},
				"num_max_curiosity": 3 
			},
		},
	},
	"Sushi Hut" : {	# merchant, kingdom
		"rarity": "rare",
		"path": "res://Structures/SushiHut.tscn",
		"icon": "res://UI/StructureIcons/SushiHut.tres",
		"sprite": "res://Assets/Structures/SushiHut.png",
		"sprite_offset": Vector2(32,0),
		"color": "red",
		"occupied_coordinates": [
			Vector2(0,0),
			Vector2(1,0),
		],
		"entrance_coordinate": Vector2(1, 0),
		"activity_duration": 10,
		"structure_stars": 2,
		"flavor": "nice date spot",
		"effects": {
			"serve_ingredients": {
				"conditions": {
					"visit": -1,
					"has_cooked_ingredients": 1,
				},
				"num_stars_per_cooked_ingredient": 1,
			},
			"gain_aura": {
				"conditions": {
					"visit": -1,
				},
				"type": "satisfied",
				"duration": 1,
			},
		},
	},
	"Troutmouth Statue" : {	# invasion, kingdom
		"rarity": "rare",
		"path": "res://Structures/TroutmouthStatue.tscn",
		"icon": "res://UI/StructureIcons/TroutmouthStatue.tres",
		"sprite": "res://Assets/Structures/TroutmouthStatue.png",
		"sprite_offset": Vector2(0,0),
		"color": "red",
		"occupied_coordinates": [
			Vector2(0,0),
		],
		"entrance_coordinate": Vector2(0, 0),
		"activity_duration": 3,
		"structure_stars": 0,
		"flavor": "A statue of the legendary explorer, Captain Troutmouth",
		"effects": {
			"catffeinate": { 
				"conditions": {
					"visit": -1,
				},
				"value": 5,
			},
			"gain_aura": {
				"conditions": {
					"visit": -1,
				},
				"type": "nosy",
				"duration": 2,
			},
		},
	},
	"Pirate Library" : {	# invasion
		"rarity": "common",
		"path": "res://Structures/PirateLibrary.tscn",
		"icon": "res://UI/StructureIcons/PirateLibrary.tres",
		"sprite": "res://Assets/Structures/PirateLibrary.png",
		"sprite_offset": Vector2(64, 32),
		"color": "green",
		"occupied_coordinates": [
			Vector2(0,0),
			Vector2(1,0),
			Vector2(2,0),
			Vector2(0,1),
			Vector2(1,1),
		],
		"entrance_coordinate": Vector2(1, 1),
		"activity_duration": 10,
		"structure_stars": 0,
		"flavor": "learn to be a pirate and buy pirate hats here",
		"effects": {
			"gain_max_curiosity": {
				"conditions": {
					"discovery": 3,
				},
				"num_max_curiosity": 10
			},
		},
	},
	"Family House" : {	# merchant
		"rarity": "rare",
		"path": "res://Structures/LargeFamilyHouse.tscn",
		"icon": "res://UI/StructureIcons/LargeFamilyHouse.tres",
		"sprite": "res://Assets/Structures/LargeFamilyHouse.png",
		"sprite_offset": Vector2(32, 64),
		"color": "green",
		"occupied_coordinates": [
			Vector2(0,0),
			Vector2(1,0),
			Vector2(0,1),
			Vector2(1,1),
			Vector2(0,2),
			Vector2(1,2),
		],
		"entrance_coordinate": Vector2(1, 2),
		"activity_duration": 3,
		"structure_stars": 0,
		"flavor": "3 is a big family in the city",
		"effects": {
			"home": {
				"conditions": {
					"build": -1,
				},
				"num_cats": 3,
			},
			"gain_aura": {
				"conditions": {
					"visit": -1,
				},
				"type": "lazy",
				"duration": 1,
			}
		},
	},
	"Ice Cream Trees" : {	# kingdom
		"rarity": "common",
		"path": "res://Structures/IceCreamTrees.tscn",
		"icon": "res://UI/StructureIcons/IceCreamTrees.tres",
		"sprite": "res://Assets/Structures/IceCreamTrees.png",
		"sprite_offset": Vector2(64,0),
		"color": "red",
		"occupied_coordinates": [
			Vector2(0,0),
			Vector2(1,0),
			Vector2(2,0),
		],
		"entrance_coordinate": Vector2(1, 0),
		"activity_duration": 3,
		"structure_stars": 2,
		"flavor": "Cedar trees",
		"effects": {
			"gain_aura": {
				"conditions": {
					"discovery": 1,
				},
				"type": "generous",
				"duration": 1,
			},
		},
	},
	"Maple Grove" : {	# kingdom
		"rarity": "common",
		"path": "res://Structures/MapleGrove.tscn",
		"icon": "res://UI/StructureIcons/MapleGrove.tres",
		"sprite": "res://Assets/Structures/MapleGrove.png",
		"sprite_offset": Vector2(0, 64),
		"color": "green",
		"occupied_coordinates": [
			Vector2(0,0),
			Vector2(0,1),
			Vector2(0,2),
		],
		"entrance_coordinate": Vector2(0, 1),
		"activity_duration": 3,
		"structure_stars": 1,
		"flavor": "Maple trees",
		"effects": {
			"gain_aura": {
				"conditions": {
					"discovery": 2,
				},
				"type": "generous",
				"duration": 1,
			},
		},
	},
	"Big Puddle" : {	# merchant, invasion
		"rarity": "common",
		"path": "res://Structures/BigPuddle.tscn",
		"icon": "res://UI/StructureIcons/BigPuddle.tres",
		"sprite": "res://Assets/Structures/BigPuddle.png",
		"sprite_offset": Vector2(32, 32),
		"color": "green",
		"occupied_coordinates": [
			Vector2(1,0),
			Vector2(0,1),
			Vector2(1,1),
		],
		"entrance_coordinate": Vector2(1, 0),
		"activity_duration": 10,
		"structure_stars": 1,
		"flavor": "Not the kind of puddle to step into",
		"effects": {	# gain ingredients
			"gain_ingredients": {
				"conditions": {
					"visit": -1,
				},
				"num_ingredients": 1,
			},
			"catffeinate": {
				"conditions": {
					"visit": -1,
				},
				"value": 1
			},
		},
	},
	"Onigiri Inn" : {	# merchant, invasion
		"rarity": "rare",
		"path": "res://Structures/OnigiriInn.tscn",
		"icon": "res://UI/StructureIcons/OnigiriInn.tres",
		"sprite": "res://Assets/Structures/OnigiriInn.png",
		"sprite_offset": Vector2(32, 0),
		"color": "green",
		"occupied_coordinates": [
			Vector2(0,0),
			Vector2(1,0),
		],
		"entrance_coordinate": Vector2(0, 0),
		"activity_duration": 10,
		"structure_stars": 2,
		"flavor": "Meow meow",
		"effects": {	
			"rehome": {
				"conditions": {
					"discovery": 1,
				},
			},
			"serve_ingredients": {
				"conditions": {
					"visit": -1,
					"has_cooked_ingredients": 1,
				},
				"num_stars_per_cooked_ingredient": 4,
			},
			"gain_aura": {
				"conditions": {
					"visit": -1,
				},
				"type": "nosy",
				"duration": 2,
			},
		},
	},
	"Smokehouse" : {	# invasion
		"rarity": "rare",
		"path": "res://Structures/Smokehouse.tscn",
		"icon": "res://UI/StructureIcons/Smokehouse.tres",
		"sprite": "res://Assets/Structures/Smokehouse.png",
		"sprite_offset": Vector2(0, 32),
		"color": "red",
		"occupied_coordinates": [
			Vector2(0,0),
			Vector2(0,1),
		],
		"entrance_coordinate": Vector2(0,0),
		"activity_duration": 3,
		"structure_stars": 1,
		"flavor": "cats are colorblind",
		"effects": {
			"cook_ingredients": {
				"conditions": {
					"visit": -1,
				},
				"num_cooked_ingredients_per_ingredient": 2,
				"num_stars_per_ingredient": 3,
			},
			"gain_aura": {
				"conditions": {
					"discovery": 1,
				},
				"type": "prankster",
				"duration": 10,
			},
		},
	},
	"Tall Lily Shrub Path" : {	# invasion
		"rarity": "rare",
		"path": "res://Structures/TallLilyShrubPath.tscn",
		"icon": "res://UI/StructureIcons/TallLilyShrubPath.tres",
		"sprite": "res://Assets/Structures/TallLilyShrubPath.png",
		"sprite_offset": Vector2(64, 0),
		"color": "green",
		"occupied_coordinates": [
			Vector2(0,0),
			Vector2(1,0),
			Vector2(2,0),
		],
		"entrance_coordinate": Vector2(1,0),
		"activity_duration": 1,
		"structure_stars": 0,
		"flavor": "",
		"effects": {
			"catffeinate": {
				"conditions": {
					"visit": -1,
				},
				"value": 3
			}
		},
	},
	"Wide Lily Shrub Path" : {	# invasion
		"rarity": "rare",
		"path": "res://Structures/WideLilyShrubPath.tscn",
		"icon": "res://UI/StructureIcons/WideLilyShrubPath.tres",
		"sprite": "res://Assets/Structures/WideLilyShrubPath.png",
		"sprite_offset": Vector2(0, 64),
		"color": "green",
		"occupied_coordinates": [
			Vector2(0,0),
			Vector2(0,1),
			Vector2(0,2),
		],
		"entrance_coordinate": Vector2(0,1),
		"activity_duration": 1,
		"structure_stars": 0,
		"flavor": "",
		"effects": {
			"catffeinate": {
				"conditions": {
					"visit": -1,
				},
				"value": 3
			}
		},
	},
	"Tall Riverside" : {
		"rarity": "rare",
		"path": "res://Structures/TallRiverside.tscn",
		"icon": "res://UI/StructureIcons/TallRiverside.tres",
		"sprite": "res://Assets/Structures/TallRiverside.png",
		"sprite_offset": Vector2(0, 0),
		"color": "green",
		"occupied_coordinates": [
			Vector2(0,0),
		],
		"entrance_coordinate": Vector2(0,0),
		"activity_duration": 1,
		"structure_stars": 0,
		"flavor": "Running water is a great resource",
		"effects": {
			"terraform": {
				"conditions": {
					"build": -1,
				},
				"coordinates": [	# with respect to 0,0
					Vector2(-1,-1),
					Vector2(0,-1),
					Vector2(-1,0),
				],
				"color": "blue",
			}
		},
	},
	"Folk House" : {	# invasion
		"rarity": "common",
		"path": "res://Structures/FolkHouse.tscn",
		"icon": "res://UI/StructureIcons/FolkHouse.tres",
		"sprite": "res://Assets/Structures/FolkHouse.png",
		"sprite_offset": Vector2(32, 0),
		"color": "green",
		"occupied_coordinates": [
			Vector2(0,0),
			Vector2(1,0),
		],
		"entrance_coordinate": Vector2(0, 0),
		"activity_duration": 1,
		"structure_stars": 1,
		"flavor": "",
		"effects": {
			"home": {
				"conditions": {
					"build": -1,
				},
				"num_cats": 1,
			},
		},
	},
	"Crossroads" : {
		"rarity": "common",
		"path": "res://Structures/Crossroads.tscn",
		"icon": "res://UI/StructureIcons/Crossroads.tres",
		"sprite": "res://Assets/Structures/Crossroads.png",
		"sprite_offset": Vector2(0,0),
		"color": "green",
		"occupied_coordinates": [
			Vector2(0,0),
		],
		"entrance_coordinate": Vector2(0, 0),
		"activity_duration": 1,
		"structure_stars": 0,
		"flavor": "Where to next?",
		"effects": {
			"catffeinate": {
				"conditions": {
					"visit": -1,
				},
				"value": 2
			},
		},
	},
	"Bobcat Hut" : {
		"rarity": "common", # kingdom, merchant
		"path": "res://Structures/BobcatHut.tscn",
		"icon": "res://UI/StructureIcons/BobcatHut.tres",
		"sprite": "res://Assets/Structures/BobcatHut.png",
		"sprite_offset": Vector2(32, 32),
		"color": "red",
		"occupied_coordinates": [
			Vector2(1,0),
			Vector2(0,1),
			Vector2(1,1),
		],
		"entrance_coordinate": Vector2(1, 0),
		"activity_duration": 5,
		"structure_stars": 1,
		"flavor": "Improves your town's ARCHI level",
		"effects": {
			"home": {
				"conditions": {
					"build": -1,
				},
				"num_cats": 1,
			},
			"gain_levels": {
				"conditions": {
					"build": -1,
				},
				"type": "ARCHI",
				"quantity": 1,
			},
		}
	},
}


var removed_structures = {
	"Berry Cauldron" : {	# merchant, invasion
		"rarity": "common",
		"path": "res://Structures/BerryCauldron.tscn",
		"icon": "res://UI/StructureIcons/BerryCauldron.tres",
		"sprite": "res://Assets/Structures/BerryCauldron.png",
		"sprite_offset": Vector2(32,0),
		"color": "green",
		"occupied_coordinates": [
			Vector2(0,0),
			Vector2(1,0),
		],
		"entrance_coordinate": Vector2(1, 0),
		"activity_duration": 3,
		"structure_stars": 1,
		"flavor": "freakishly large cauldron in the woods",
		"effects": {
			"cook_ingredients": {
				"conditions": {
					"visit": -1,
				},
				"num_cooked_ingredients_per_ingredient": 1,
				"num_stars_per_ingredient": 1,
			},
			"gain_aura": { 
				"conditions": {
					"visit": -1,
				},
				"type": "spooked",
				"duration": 1,
			}
		},
	},
	"Scratch Post" : {	# kingdom
		"rarity": "epic",
		"path": "res://Structures/ScratchPost.tscn",
		"icon": "res://UI/StructureIcons/ScratchPost.tres",
		"sprite": "res://Assets/Structures/ScratchPost.png",
		"sprite_offset": Vector2(32, 32),
		"color": "green",
		"occupied_coordinates": [
			Vector2(0,0),
			Vector2(1,0),
			Vector2(0,1),
			Vector2(1,1),
		],
		"entrance_coordinate": Vector2(0, 0),
		"activity_duration": 3,
		"structure_stars": 2,
		"flavor": "neighborhood post office",
		"effects": {
			"rehome": {
				"conditions": {
					"discovery": 1,
				},
			},
			"gain_max_curiosity": {
				"conditions": {
					"discovery": 1,
				},
				"num_max_curiosity": 50 
			},
			"gain_aura": {
				"conditions": {
					"discovery": 1,
				},
				"type": "dutiful",
				"duration": 100,
			},
		},
	},
	"Bobcat Guild" : {	# kingdom
		"rarity": "rare",
		"path": "res://Structures/WoodWorks.tscn",
		"icon": "res://UI/StructureIcons/WoodWorks.tres",
		"sprite": "res://Assets/Structures/WoodWorks.png",
		"sprite_offset": Vector2(0,32),
		"color": "red",
		"occupied_coordinates": [
			Vector2(0,0),
			Vector2(0,1),
		],
		"entrance_coordinate": Vector2(0, 0),
		"activity_duration": 3,
		"structure_stars": 1,
		"flavor": "",
		"effects": {
			"rehome": {
				"conditions": {
					"discovery": 1,
				},
			},
			"gain_aura": {
				"conditions": {
					"discovery": 1,
				},
				"type": "adventurous",
				"duration": 100,
			},
			"gain_max_curiosity": {
				"conditions": {
					"discovery": 1,
				},
				"num_max_curiosity": 10, 
			},
		},
	},
	"Potion Shop" : {	# merchant, invasion
		"rarity": "rare",
		"path": "res://Structures/PotionShop.tscn",
		"icon": "res://UI/StructureIcons/PotionShop.tres",
		"sprite": "res://Assets/Structures/PotionShop.png",
		"sprite_offset": Vector2(0,0),
		"color": "green",
		"occupied_coordinates": [
			Vector2(0,0),
		],
		"entrance_coordinate": Vector2(0, 0),
		"activity_duration": 3,
		"structure_stars": 2,
		"flavor": "all kinds of weird potions sold here",
		"effects": {
			"serve_ingredients": {
				"conditions": {
					"visit": -1,
					"has_cooked_ingredients": 1,
				},
				"num_stars_per_cooked_ingredient": 5,
			},
		},
	},
	# firefly waterfall
	# that cafe with the old golf guy and pasta
}

var region_structures = {
	'Five Island Village': [
		"Fishing Hut",
		"Rock",
		"Flowerbed",
		"Floating Planks",
		"Oak Treehouse",
		"Round Fountain",
		"The Catto",
		"Hostel Good Neet",
		"Tall Sea Wall",
		"Shabby Shrine",
		"Tsubaki Bush",
		"Benches",
		"Ice Cream Trees",
		"Maple Grove",
		"Big Puddle",
		"Tall Lily Shrub Path",
		"Wide Lily Shrub Path",
		"Tall Riverside",
		"Folk House",
		"Crossroads",
		"Troutmouth Statue",
		"Quiet Farmhouse",
		"Bobcat Hut",
		#Fish Market
	],
	'Grand Whiskertown': [
		"Bobcat Workshop",
		"Fishing Hut",
		"Tuna Factory",
		"Rock",
		"Flowerbed",
		"Pile Of Clean Laundry",
		"Floating Planks",
		"Oak Treehouse",
		"Round Fountain",
		"Catbed Campground",
		"Catnip Alley",
		"Scratch Post",
		"The Catto",
		"Little Red House",
		"Hostel Good Neet",
		"Tall Sea Wall",
		"Shabby Shrine",
		"Town Hall",
		"Hydrant",
		"Trashcan",
		"Bobcat Guild",
		"Tsubaki Bush",
		"Fish Gutter",
		"Benches",
		"Pawson",
		"Quiet Farmhouse",
		"Junkyard",
		"Skatepark",
		"Sushi Hut",
		"Troutmouth Statue",
		"Pirate Library",
		"Family House",
		"Ice Cream Trees",
		"Maple Grove",
		"Big Puddle",
		"Onigiri Inn",
		"Smokehouse",
	]
}
