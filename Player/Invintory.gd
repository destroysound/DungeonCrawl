extends Node
class_name Invintory

signal invintory_changed

export var _items = Array() setget set_items, get_items

func set_items(new_items):
	_items = new_items
	emit_signal("invintory_changed", self)
	
func get_items():
	return _items

func get_item(index):
	return _items[index]

func add_item(item_name, quantity):
	if quantity <= 0:
		print("cant add a negative number of items")
		return
	
	var item = ItemDatabase.get_item(item_name)
	if not item:
		print("could not find item")
		return
		
	var remaining_quantity = quantity
	var max_stack_size = item.max_stack_size if item.stackable else 1
	
	if item.stackable:
		for i in range(_items.size()):
			if remaining_quantity == 0:
				break 
				
			var invintory_item = _items[i]
			
			if invintory_item.item_reference.name != item.name:
				continue
				
			if invintory_item.quantity < max_stack_size:
				var original_quantity = invintory_item.quantity
				invintory_item.quantity = min(original_quantity + remaining_quantity, max_stack_size)
				remaining_quantity -= invintory_item.quantity - original_quantity
	while remaining_quantity > 0:
		var new_item = {
			item_reference = item,
			quantity = min(remaining_quantity, max_stack_size)
		}
		_items.append(new_item)
		remaining_quantity -= new_item.quantity
	
	emit_signal("invintory_changed", self)
