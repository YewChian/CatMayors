extends Structure


func initialize_stats():
	structure_name = "Tuna Factory"
	color = "green"
	occupied_coordinates = [
		Vector2(1,0),
		Vector2(0,1),
		Vector2(1,1),
		Vector2(0,2),
		Vector2(1,2),
	]
	num_cats = 1
	entrance_coordinate = Vector2(0,2)
	activity_duration = 2
	snacks = 2
	tricks = 1
	naps = 0
	snack_stars = 0
	trick_stars = 0
	nap_stars = 0
	
