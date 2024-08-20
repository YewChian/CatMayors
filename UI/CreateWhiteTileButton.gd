extends Button

var tile = preload("res://Tiles/WhiteTile.tscn")

func _on_pressed():
	UIMan.UI.get_node("ChooseTileLocationUI").new_tile = tile
	UIMan.enter_mode("ChooseTileLocationUI")
