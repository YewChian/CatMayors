extends Structure


func initialize_stats():
	structure_name = "Fishing Hut"
	color = "green"
	occupied_coordinates = [
		Vector2(0,0),
		Vector2(1,0),
		Vector2(2,0),
		Vector2(0,1),
		Vector2(1,1),
		Vector2(2,1),
	]
	num_cats = 2
	entrance_coordinate = Vector2(1,0)
	activity_duration = 2
	snacks = 2
	tricks = 1
	naps = 1
	snack_stars = 0
	trick_stars = 0
	nap_stars = 0
