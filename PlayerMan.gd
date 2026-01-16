extends Node

var mode: String

var black_stars : int = 0
var white_stars : int = 0

var black_hand : Array = []
var white_hand : Array = []

var black_structures: Array = []
var white_structures: Array = []

var black_levels = {
	"Archi": 0,
	"Nature": 0,
	"Farming": 0,
	"Construct": 0,
}
var white_levels = {
	"Archi": 0,
	"Nature": 0,
	"Farming": 0,
	"Construct": 0,
}


#var phases = ["DraftUI", "DraftUI", "ChooseLocationUI", "ChooseLocationUI", "ChooseLocationUI", "ObserveUI", "EventUI"]
var phases = ["DraftUI", "DraftUI", "ChooseLocationUI", "ChooseLocationUI", "ChooseLocationUI", "ObserveUI"]
var phase_index : int = 0
var turn_color : String = "black"
var turn_color_order = ["black", "white"]
var turn_index : int = 0
var round : int = 0
var total_turns: int = 0
var max_hand_size = 5
	

func add_initial_structures_to_hand():
	black_hand.append("Folk House")
	white_hand.append("Folk House")

	
func go_to_next_turn():
	total_turns += 1
	turn_index = (turn_index + 1) % len(turn_color_order)
	if turn_index == 0:
		phase_index = (phase_index + 1) % len(phases)
	if phase_index == 0 and turn_index == 0:
		black_hand = []
		white_hand = []
		round += 1
		turn_color_order.reverse()
	turn_color = turn_color_order[turn_index]
	get_tree().current_scene.get_node("CommonUI/VBoxContainer/HBoxContainer/WhoseTurnLabel").text = turn_color + "'s turn"
	if round == Settings.MAX_ROUNDS:
		end_game()
	else:
		await UIMan.enter_mode(phases[phase_index])
		if mode == "KittenBot" and turn_color == "white":
			return	# don't show the next player button
		if mode == "DuelingBot":
			return	# don't show the next player button
		else:
			await get_tree().current_scene.get_node("CommonUI/NextPlayerReady").show_next_player_button()

func end_game():
	var victory_label = get_tree().current_scene.get_node("CommonUI/VBoxContainer/VictoryLabel")
	victory_label.visible = true
	var title_info = get_tree().current_scene.get_node("CommonUI/VBoxContainer/TitleInfo")
	title_info.visible = true
	if black_stars > white_stars:
		victory_label.text = ("BLACK WINS")
	elif black_stars < white_stars:
		victory_label.text = ("WHITE WINS")
	else:
		victory_label.text = ("TIE GAME??")
	await UIMan.enter_mode("EndUI")
	get_tree().current_scene.get_node("CommonUI/VBoxContainer/HBoxContainer/TimeLeft/TurnTimer").stop()
	get_tree().current_scene.get_node("CommonUI/VBoxContainer/HBoxContainer/TimeLeft").visible = false
