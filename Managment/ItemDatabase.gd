extends Node

var items = Array()

func _ready():
	var directory = Directory.new()
	directory.open("res://Items")
	directory.list_dir_begin()
	
	var fileName = directory.get_next()
	while(fileName):
		if not directory.current_is_dir():
			items.append(load("res://Items/%s" % fileName))
		
		fileName = directory.get_next()
		
func get_item(item_name):
	for i in items:
		if i.name == item_name:
			return i
		
	return null
