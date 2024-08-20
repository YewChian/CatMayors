extends Node

@onready var UI = get_tree().current_scene.get_node("UI")
@onready var camera = get_tree().current_scene.get_node("Camera2D")

var mode : String

func _ready():
	await enter_mode("IdleUI")

func enter_mode(new_mode : String):
	mode = new_mode
	for mode_node in UI.get_children():
		if mode_node.name != new_mode:
			mode_node.set_visible(false)
		elif mode_node.name == new_mode:
			mode_node.set_visible(true)
			mode_node.initialize()

func exit_mode(current_mode : String):
	for mode_node in UI.get_children():
		if mode_node.name == current_mode:
			await mode_node.end_turn()
			break


func _unhandled_input(event):
	if event is InputEventScreenDrag:
		camera.handle_drag(event)
		
	elif event is InputEventScreenTouch:
		if event.pressed:
			UI.get_node(mode).on_touched(event)
		
		

		

