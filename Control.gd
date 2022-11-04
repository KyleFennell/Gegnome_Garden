extends CanvasLayer

@onready var inventory_container = %InventoryContainer
@onready var hotbar = preload("res://UI/Inventory/HotBar.tres")

func _ready():
	pass

func _process(_delta):
	if Input.is_action_just_pressed("toggle_inventory"):
		inventory_container.visible = not inventory_container.visible
	if Input.is_action_just_released("scroll_up"):
		hotbar.increment_selected_index()
	if Input.is_action_just_released("scroll_down"):
		hotbar.decrement_selected_index()
	if Input.is_action_just_pressed("inventory_slot_1"):
		hotbar.selected_index = 0
		hotbar.selection_changed.emit(hotbar.selected_index)
	if Input.is_action_just_pressed("inventory_slot_2"):
		hotbar.selected_index = 1
		hotbar.selection_changed.emit(hotbar.selected_index)
	if Input.is_action_just_pressed("inventory_slot_3"):
		hotbar.selected_index = 2
		hotbar.selection_changed.emit(hotbar.selected_index)
	if Input.is_action_just_pressed("inventory_slot_4"):
		hotbar.selected_index = 3
		hotbar.selection_changed.emit(hotbar.selected_index)
	if Input.is_action_just_pressed("inventory_slot_5"):
		hotbar.selected_index = 4
		hotbar.selection_changed.emit(hotbar.selected_index)
	if Input.is_action_just_pressed("inventory_slot_6"):
		hotbar.selected_index = 5
		hotbar.selection_changed.emit(hotbar.selected_index)
	if Input.is_action_just_pressed("inventory_slot_7"):
		hotbar.selected_index = 6
		hotbar.selection_changed.emit(hotbar.selected_index)
	if Input.is_action_just_pressed("inventory_slot_8"):
		hotbar.selected_index = 7
		hotbar.selection_changed.emit(hotbar.selected_index)
	if Input.is_action_just_pressed("inventory_slot_9"):
		hotbar.selected_index = 8
		hotbar.selection_changed.emit(hotbar.selected_index)
	if Input.is_action_just_pressed("inventory_slot_10"):
		hotbar.selected_index = 9
		hotbar.selection_changed.emit(hotbar.selected_index)
