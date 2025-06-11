extends Button

var target_cat: Object
var is_flashing = false

func _on_pressed():
	assert(target_cat != null)
	if is_flashing == true:
		return
	is_flashing = true
	var initial_modulate = target_cat.modulate
	print(initial_modulate)
	for i in range(5):
		print("flashing")
		var flash_tween = get_tree().create_tween()
		flash_tween.tween_property(target_cat, "modulate", Color(0.4,0.4,1.0,1.0), 0.2)
		await flash_tween.finished
		print(target_cat.modulate)
		
		print("unflashing")
		var unflash_tween = get_tree().create_tween()
		unflash_tween.tween_property(target_cat, "modulate", initial_modulate, 0.2)
		await unflash_tween.finished
		
		print("killed")
		
	is_flashing = false
