extends Resource
class_name Inventory

var drag_data = null

signal items_changed(indexes)

@export var items: Array = []

func can_add_item(new_item: Item) -> bool:
	if not is_full():
		return true
	for i in items.size():
		var item = items[i]
		if item == null:
			return true
		if item.name == new_item.name and item.stackable and new_item.stackable:
			return true
	return false

func can_add_item_to(new_item: Item, index: int) -> bool:
	var item = items[index]
	if item == null:
		return true
	if item.name == new_item.name and item.stackable and new_item.stackable:
		return true
	return false

func add_item(new_item: Item) -> Item:
	if is_full(): 
		return new_item
	for i in items.size():
		var item = items[i]
		if item == null:
			continue
		if item.name == new_item.name and item.stackable and new_item.stackable:
			item.quantity += new_item.quantity
			emit_signal("items_changed", [i])
			return null
	for i in items.size():
		var item = items[i]
		if item == null:
			items[i] = new_item
			emit_signal("items_changed", [i])
			new_item.index = i
			new_item.item_used.connect(on_item_used)
			return null
	return new_item

func add_item_to(new_item: Item, index: int) -> Item:
	var item = items[index]
	if item == null:
		items[index] = new_item
		emit_signal("items_changed", [index])
		return null
	if item.name == new_item.name and item.stackable and new_item.stackable:
		item.quantity += new_item.quantity
		emit_signal("items_changed", [index])
		return null
	return new_item
	
func on_item_used(item: Item):
	if item.quantity == 0 and item.remove_when_stack_empty:
		items[item.index] = null
	items_changed.emit([item.index])

func set_item(item_index: int, item: Item):
	var previous_item = items[item_index]
	items[item_index] = item
	item.index = item_index
	emit_signal("items_changed", [item_index])
	return previous_item
	
func swap_items(item_index: int, target_item_index: int):
	var temp = items[item_index]
	items[item_index] = items[target_item_index]
	items[target_item_index] = temp
	if items[item_index] != null:
		items[item_index].index = item_index
	if items[target_item_index] != null:
		items[target_item_index].index = target_item_index
	emit_signal("items_changed", [item_index, target_item_index])
	
func remove_item(index: int) -> Item:
	var temp = items[index]
	items[index] = null
	emit_signal("items_changed", [index])
	return temp

func shift_click_out(index: int):
	emit_signal("shift_click_out", index)
	emit_signal("items_changed", [index])

func is_full() -> bool:
	return not items.any(is_null)
	
func is_empty() -> bool:
	return items.all(is_null)

func is_null(obj) -> bool:
	return obj == null
