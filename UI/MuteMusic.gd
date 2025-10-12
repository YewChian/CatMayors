extends Button

var is_music_on = true
@onready var bgm = get_tree().current_scene.get_node("BGM")

func _ready() -> void:
	bgm.playing = false	# for debugging to disable BGM

func _on_pressed() -> void:
	if is_music_on:
		is_music_on = false
		text = "MUSIC OFF"
		bgm.playing = false
		
	else:
		is_music_on = true
		text = "MUSIC ON"
		bgm.playing = true
