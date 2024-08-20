extends Button

var structure = preload("res://Structures/Fountain.tscn")


func _on_pressed():
	UIMan.UI.get_node("ChooseLocationUI").new_structure = structure
	UIMan.enter_mode("ChooseLocationUI")
