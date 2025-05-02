extends Node2D

func argmax(arr: Array):
	# arr should have at least 1 element
	assert(len(arr) > 0)

	var highest = -1
	var i = 0
	var highest_i: Array = []	# array for tiebreaks
	for value in arr:
		if value >= highest:
			highest_i.append(i)
			highest = value
		i += 1
	highest_i.shuffle()
	#print("all argmaxes: ", highest_i, "; highest value: ", highest)
	
	return highest_i[0]


func get_column_from_twodarr(twodarr: Array, index: int):
	# 2darr has to be a 2d array 
	var column = []
	for row in twodarr:
		column.append(row[index])
	return column
