extends Structure


func initialize_stats():
	structure_name = "Bobcat Yard"
	color = "red"
	occupied_coordinates = [
		Vector2(0,0),
		Vector2(1,0),
		Vector2(0,1),
		Vector2(1,1),
	]
	num_cats = 2
	entrance_coordinate = Vector2(1,1)
	activity_duration = 2
	snacks = 0
	tricks = 2
	naps = 0
	snack_stars = 0
	trick_stars = 0
	nap_stars = 0
