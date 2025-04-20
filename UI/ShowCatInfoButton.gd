extends Button

@onready var cat_instance_info = get_tree().current_scene.get_node("CommonUI/VBoxContainer/HBoxContainer2/CatInstanceInfo")

func _on_pressed():
	cat_instance_info.visible = !cat_instance_info.visible
	
	if cat_instance_info.visible == true:
		await cat_instance_info.update_info()
