extends Node

var black_stars : int = 0
var white_stars : int = 0


var black_hand : Array = []
var white_hand : Array = []

var phases = ["DraftUI", "DraftUI", "ChooseLocationUI", "ChooseLocationUI", "ChooseLocationUI"]
var phase_index : int = 0
var turn_color : String = "black"
var turn_color_order = ["black", "white"]
var turn_index : int = 0
var round : int = 0
	
	
func go_to_next_turn():
	turn_index = (turn_index + 1) % len(turn_color_order)
	turn_color = turn_color_order[turn_index]
	if turn_index == 0:
		phase_index = (phase_index + 1) % len(phases)
	if phase_index == 0 and turn_index == 0:
		black_hand = []
		white_hand = []
		round += 1
	if round == 2:
		end_game()
	else:
		await UIMan.enter_mode(phases[phase_index])
		await get_tree().current_scene.get_node("CommonUI/NextPlayerReady").show_next_player_button()


func end_game():
	var victory_label = get_tree().current_scene.get_node("CommonUI/VBoxContainer/VictoryLabel")
	victory_label.visible = true
	if black_stars > white_stars:
		victory_label.text = ("BLACK WINS")
	elif black_stars < white_stars:
		victory_label.text = ("WHITE WINS")
	else:
		victory_label.text = ("TIE GAME??")
	await UIMan.enter_mode("IdleUI")
	get_tree().current_scene.get_node("CommonUI/VBoxContainer/HBoxContainer/TimeLeft/TurnTimer").stop()
	get_tree().current_scene.get_node("CommonUI/VBoxContainer/HBoxContainer/TimeLeft").visible = false
