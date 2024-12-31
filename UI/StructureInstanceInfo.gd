extends Control

var structure_instance: Object
@onready var observe_ui = get_tree().current_scene.get_node("UI/ObserveUI")

func initialize():
	pass

func update_info(new_structure_instance):
	structure_instance = new_structure_instance
	%StructureName.visible = true
	%StructureName.text = structure_instance.structure_name
	%StructureTexture.texture = structure_instance.get_node("Button").icon
	%InstanceEntranceIndicator.position = structure_instance.entrance_coordinate * Settings.TILE_LENGTH
	%Cats.visible = false
	%StatGains.visible = false
	%Stars.visible = false
	%Residents.visible = false
	
	if structure_instance.num_cats > 0:
		%Cats.visible = true
		%Cats.text = "Gain " + str(structure_instance.num_cats) + " cats."
		
	if structure_instance.tricks > 0 or structure_instance.snacks > 0 or structure_instance.naps > 0:
		%StatGains.visible = true
		%StatGains.text = "On visit, cats gain:\n"
		if structure_instance.tricks > 0:
			%StatGains.text += str(structure_instance.tricks) + " tricks\n"
		if structure_instance.snacks > 0:
			%StatGains.text += str(structure_instance.snacks) + " snacks\n"
		if structure_instance.naps > 0:
			%StatGains.text += str(structure_instance.naps) + " naps\n"
	
	if structure_instance.trick_stars > 0 or structure_instance.snack_stars > 0 or structure_instance.nap_stars > 0:
		%Stars.visible = true
		%Stars.text = "On visit, players gain:\n"
		if structure_instance.trick_stars > 0:
			%Stars.text += str(structure_instance.trick_stars) + " stars for every trick\n"
		if structure_instance.snack_stars > 0:
			%Stars.text += str(structure_instance.snack_stars) + " stars for every snack\n"
		if structure_instance.nap_stars > 0:
			%Stars.text += str(structure_instance.nap_stars) + " stars for every nap\n"

	%NumVisits.visible = true
	%NumVisits.text = "Visited " + str(structure_instance.num_visits) + " times."
	
	if len(structure_instance.cats) > 0:
		%Residents.visible = true
		%Residents.text = "Resident Info:\n"
		for cat in structure_instance.cats:
			%Residents.text += str(cat.id) + " from team " + str(cat.color) + "\n"
			%Residents.text += "Earned " + str(cat.earned_stars) + " stars" + "\n"
			%Residents.text += "Curiosity (movement range): " + str(cat.max_curiosity) + "\n"
			%Residents.text += "snk/trk/nap\n" + str(cat.snacks) + "/" + str(cat.tricks) + "/" + str(cat.naps) + "\n"
			
