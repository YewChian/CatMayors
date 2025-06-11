extends TextureRect

func _ready() -> void:
	PlayerMan.turn_index = 0
	PlayerMan.black_stars = 0
	PlayerMan.black_structures = []
	PlayerMan.white_hand = []
	PlayerMan.white_structures = []
	PlayerMan.round = 0
	PlayerMan.phase_index = 0
	StructureMan.structures = {}
	CatMan.cats = {}
	CatMan.has_moving_cats = false
	await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_file("res://Main.tscn")
