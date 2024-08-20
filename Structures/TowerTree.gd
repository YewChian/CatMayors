extends Structure


func initialize_stats():
	structure_name = "Tower Tree"
	color = "green"
	occupied_coordinates = [
		Vector2(0,0),
		Vector2(1,0),
		Vector2(2,0),
		Vector2(1,1)
		]
	num_cats = 0
	entrance_coordinate = Vector2(1,1)
	activity_duration = 2
	snacks = 0
	tricks = 0
	naps = 0
	snack_stars = 0
	trick_stars = 1
	nap_stars = 0
