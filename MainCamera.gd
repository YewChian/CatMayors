extends Camera2D

@export var pan_speed: float = 1.0
var can_pan: bool = true

var start_dist: float
var touch_points: Dictionary = {}

func handle_drag(event: InputEventScreenDrag):
	touch_points[event.index] = event.position

	if touch_points.size() == 1 and can_pan:
		global_position -= event.relative * pan_speed
