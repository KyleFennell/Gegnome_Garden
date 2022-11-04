extends MarginContainer

@onready var item_texture_rect = $MarginContainer/ItemTexture
@onready var item_quantity_label = $Label
@onready var selected_texture = $SelectedTexture


@export var inventory: Resource = preload("res://UI/Inventory/Inventory.tres")
@export var selected: bool = false:
	set(value):
		if self.selected_texture:
			self.selected_texture.visible = value
		selected = value

func display_item(item: Item):
	if item is Item:
		item_texture_rect.material.set_shader_param("enabled", false)
		item_texture_rect.texture = item.texture
		if item.stackable:
			item_quantity_label.text = str(item.quantity)
		else:
			item_quantity_label.text = ""
		if "color" in item:
			item_texture_rect.material.set_shader_param("enabled", true)
			item_texture_rect.material.set_shader_param("tint_color", item.color)
	else:
		item_texture_rect.material.set_shader_param("enabled", false)
		item_texture_rect.texture = null #TODO replace with empty slot?
		item_quantity_label.text = ""
		
func _get_drag_data(_position):
	var item_index = get_index()
	var item = inventory.remove_item(item_index)
	if item is Item:
		var data = {}
		data.item = item
		data.item_index = item_index
		data.inventory = inventory
		var drag_preview = TextureRect.new()
		drag_preview.texture = item.texture
		set_drag_preview(drag_preview)
		inventory.drag_data = data 
		return data
	
func _can_drop_data(_position, data):
	return data is Dictionary and data.has("item")
	
func _drop_data(_position, data):
	# TODO: fix transfer across inventories
	var my_item_index = get_index()
	var my_item = inventory.items[my_item_index]
	if inventory == data.inventory:
		if my_item != null and my_item.name == data.item.name and my_item.stackable and data.item.stackable:
			inventory.items[my_item_index].quantity += data.item.quantity
			inventory.items_changed.emit_signal([my_item_index])
		else:
			inventory.swap_items(my_item_index, data.item_index)
			inventory.set_item(my_item_index, data.item)
	else:
		# different inventories
		if inventory.can_add_item_to(data.item, my_item_index):
			inventory.add_item_to(data.item, my_item_index)
			#inventory.items_changed.emit([my_item_index])
			data.inventory.remove_item(data.item_index)
			#data.inventory.items_changed.emit([/data.item_index])
			data.inventory.drag_data = null
		else:
			inventory.remove_item(my_item_index)
			data.inventory.add_item_to(my_item, data.item_index)
			inventory.add_item_to(data.item, my_item_index)
			data.inventory.drag_data = null
	inventory.drag_data = null
	
