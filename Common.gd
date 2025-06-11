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


func arr_to_commastring(arr: Array):
	var output: String = ""
	for e in arr:
		output += str(e)
		output += ","
	return output


func commastring_to_arr(commastring: String):
	var string_arr: Array = commastring.split(",")
	print("string_arr", string_arr)
	var output: Array = []
	for e in string_arr:
		if e == "":
			continue
		output.append(int(e))
	return output


func n_choose_r(n: int, r: int):
	return factorial(n) / (factorial(r) * (n-r))


func factorial(n: int):
	assert(n >= 0)
	if n == 0:
		return 1
	while n > 0:
		n = n*(n-1)
		n -= 1
	return n
