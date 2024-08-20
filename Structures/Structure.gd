extends Area2D
class_name Structure

var structure_name : String
var color : String
var occupied_coordinates : Array[Vector2]
var num_cats : int
var coordinate : Vector2
var entrance_coordinate : Vector2
var cats : Array
var id : int
var cats_doing_activity : Array = []
var activity_duration : float
var snacks : int
var tricks : int
var naps : int
var snack_stars : int
var trick_stars : int
var nap_stars : int

func _ready():
	$AnimationPlayer.play("idle")
	

func initialize_stats():
	pass

func initialize_cats():
	for i in range(num_cats):
		CatMan.create_cat(PlayerMan.turn_color, id)

func get_can_enter():
	if len(cats_doing_activity) > 0:
		return false
	else:
		return true

func start_activity(cat : Object):
	cats_doing_activity.push_back(cat)
	$AnimationPlayer.play("start_activity")
	$ActivityProgress.show_activity_progress()

func finish_activity():
	$AnimationPlayer.play("end_activity")
	for active_cat in cats_doing_activity:
		if snacks > 0:
			randomize()
			var earned_snacks = snacks + randi_range(0,2)
			await active_cat.gain_snacks(earned_snacks)
			%FXLabel.text = "+ " + str(earned_snacks)
			$FXAnimationPlayer.play("earn_snacks")
		if tricks > 0:
			randomize()
			var earned_tricks = tricks + randi_range(0,2)
			await active_cat.gain_tricks(earned_tricks)
			%FXLabel.text = "+ " + str(earned_tricks)
			$FXAnimationPlayer.play("earn_tricks")
		if naps > 0:
			randomize()
			var earned_naps = naps + randi_range(0,2)
			await active_cat.gain_naps(earned_naps)
			%FXLabel.text = "+ " + str(earned_naps)
			$FXAnimationPlayer.play("earn_naps")
		if snack_stars > 0:
			var earned_stars = active_cat.snacks * snack_stars
			%FXLabel.text = "+ " + str(earned_stars)
			var cat_color = active_cat.color
			match cat_color:
				"black":
					PlayerMan.black_stars += earned_stars
				"white":
					PlayerMan.white_stars += earned_stars
			$FXAnimationPlayer.play("earn_stars")
		if trick_stars > 0:
			var earned_stars = active_cat.snacks * trick_stars
			%FXLabel.text = "+ " + str(earned_stars)
			var cat_color = active_cat.color
			match cat_color:
				"black":
					PlayerMan.black_stars += earned_stars
				"white":
					PlayerMan.white_stars += earned_stars
			$FXAnimationPlayer.play("earn_stars")
		if nap_stars > 0:
			var earned_stars = active_cat.snacks * nap_stars
			%FXLabel.text = "+ " + str(earned_stars)
			var cat_color = active_cat.color
			match cat_color:
				"black":
					PlayerMan.black_stars += earned_stars
				"white":
					PlayerMan.white_stars += earned_stars
			$FXAnimationPlayer.play("earn_stars")
			
		active_cat.leave_structure()
		cats_doing_activity.erase(active_cat)

func get_global_entrance_coordinate():
	return coordinate + entrance_coordinate
