extends GridContainer

@export var inventory: Resource = null:
		set(value):
			if not value:
				return
			inventory = value
			if is_inside_tree():
				update_inventory()
			if "selected_index" in inventory:
				inventory.connect("selection_changed", self.update_selection)
				
var inventorySlot = preload("res://UI/Inventory/InventorySlot.tscn")

func _ready():
	update_inventory()
	
func _on_items_changed(indexes):
	for item_index in indexes:
		update_inventory_slot(item_index)
		
func update_inventory_slot(item_index):
	var inventory_slot = get_child(item_index)
	var item = inventory.items[item_index]
	if item and item.quantity == 0 and item.remove_when_stack_empty:
		inventory.items[item_index] = null
	else:
		inventory_slot.display_item(item)

func update_inventory():
	if inventory != null:
		for child in get_children():
			child.queue_free()
		for item in inventory.items:
			var inventory_slot = inventorySlot.instantiate()
			inventory_slot.inventory = inventory
			add_child(inventory_slot)
		inventory.connect("items_changed", _on_items_changed)
		for item_index in inventory.items.size():
			update_inventory_slot(item_index)
		if "selected_index" in inventory:
			update_selection(inventory.selected_index)
		
func update_selection(selected_index: int):
	for child in get_children():
		child.selected = false
	get_child(selected_index).selected = true

func _unhandled_input(event):
	if event.is_action_released("ui_left_mouse"):
		if inventory.drag_data is Dictionary:
			inventory.set_item(inventory.drag_data.item_index, inventory.drag_data.item)
