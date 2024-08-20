extends OptionButton



func _on_item_selected(index):
	PlayerMan.turn_color = get_item_text(index)
