extends Structure


func initialize_stats():
	structure_name = "Cat Beds"
	color = "green"
	occupied_coordinates = [
		Vector2(0,0),
		Vector2(0,1),
		Vector2(0,2),
		Vector2(0,3),
	]
	num_cats = 0
	entrance_coordinate = Vector2(0,0)
	activity_duration = 2
	snacks = 0
	tricks = 0
	naps = 0
	snack_stars = 0
	trick_stars = 0
	nap_stars = 1
