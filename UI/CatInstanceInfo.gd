extends PanelContainer

@onready var cat_info_button = preload("res://UI/CatInfoButton.tscn")
@onready var black_vbox = get_node("CatList/HBoxContainer/BlackVBox")
@onready var white_vbox = get_node("CatList/HBoxContainer/WhiteVBox")

func update_info():
	for element in black_vbox.get_children():
		if element.is_in_group("CatInfoButton") == false:
			continue
		black_vbox.remove_child(element)
		element.queue_free()

	for element in white_vbox.get_children():
		if element.is_in_group("CatInfoButton") == false:
			continue
		white_vbox.remove_child(element)
		element.queue_free()
		
	for name in CatMan.cats:
		var info_button = cat_info_button.instantiate()
		var cat = CatMan.cats[name]
		info_button.target_cat = cat
		var button_text: String = ""
		
		match cat.color:
			"black":
				black_vbox.add_child(info_button)
			"white":
				white_vbox.add_child(info_button)

		button_text += cat.id
		button_text += " " + str(cat.earned_stars) + " S |"
		button_text += " " + str(cat.curiosity) + " C |"
		button_text += " " + str(cat.num_ingredients) + " I |"
		button_text += " " + str(cat.num_cooked_ingredients) + " O |"
		info_button.text = button_text
