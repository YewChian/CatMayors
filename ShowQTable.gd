extends Button

@onready var q_table_container = get_tree().current_scene.get_node("UI/IdleUI/QTableContainer")

func _on_pressed():
	if q_table_container.visible == true:
		q_table_container.visible = false
		return
	
	var packed_arr = FileAccess.get_file_as_bytes("user://mouseketeer_q_table.save")
	var loaded_q_table = bytes_to_var(packed_arr)
	
	q_table_container.get_node("ScrollContainer/QTableLabel").text = ""
	for row in loaded_q_table:
		for val in row:	
			q_table_container.get_node("ScrollContainer/QTableLabel").text += str(val)
			q_table_container.get_node("ScrollContainer/QTableLabel").text += ", "
		q_table_container.get_node("ScrollContainer/QTableLabel").text += "\n"
		
	q_table_container.visible = true
	get_tree().current_scene.get_node("UI/IdleUI/DebugButtons").visible = false


func _on_hide_q_table_pressed() -> void:
	q_table_container.visible = false
	get_tree().current_scene.get_node("UI/IdleUI/DebugButtons").visible = true
