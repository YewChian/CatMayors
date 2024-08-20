extends TextureProgressBar
@onready var structure = get_parent()

func show_activity_progress():
	visible = true
	max_value = structure.activity_duration
	$Timer.start(structure.activity_duration)
	value = $Timer.time_left


func _physics_process(delta):
	value = $Timer.time_left
	

func _on_timer_timeout():
	visible = false
	structure.finish_activity()
