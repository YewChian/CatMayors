extends Control


func update_info(structure_node: Object):
	await %StructureInfo.initialize("node", structure_node)
	%StructureInfo.get_node("Button").disabled = true
	%NumVisits.text = "Number of visits: " + str(structure_node.num_visits)
	%CatInfo.text = ""
	for cat in structure_node.cats:
		%CatInfo.text += str(cat.id) + " from Team " + cat.color
		%CatInfo.text += "\n"
		%CatInfo.text += "Earned stars: " + str(cat.earned_stars)
		%CatInfo.text += "\n"
		%CatInfo.text += "Curiosity: " + str(cat.curiosity)
		%CatInfo.text += "\n"
