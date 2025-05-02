extends TextureProgressBar
@onready var structure = get_parent()

func show_activity_progress(is_cat_spooked: bool):
	visible = true
	var duration: float
	if is_cat_spooked:
		duration = 1.0 / Settings.game_speed
	else:
		duration = structure.activity_duration / Settings.game_speed
		
	max_value = duration
	$Timer.start(duration)
	value = max_value - $Timer.time_left


func _physics_process(delta):
	value = max_value - $Timer.time_left
	

func _on_timer_timeout():
	visible = false
	structure.finish_activity()
