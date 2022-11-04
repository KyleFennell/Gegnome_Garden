extends Resource
class_name PlayerInventoryManager

var inventory = preload("res://UI/Inventory/Inventory.tres")
var hotbar = preload("res://UI/Inventory/HotBar.tres")

func can_add_item(item: Item) -> bool:
	return inventory.can_add_item(item) or hotbar.can_add_item(item)

func add_item(item: Item) -> Item:
	var leftovers = null
	leftovers = hotbar.add_item(item)
	if leftovers:
		leftovers = inventory.add_item(leftovers)
	return leftovers
