extends PanelContainer

@onready var playerInventoryManager = preload("res://UI/Inventory/PlayerInventoryManager.tres")
@onready var inventoryDisplay = %InventoryDisplay
@onready var hotBarDisplay = %HotBarDisplay

func _ready():
	inventoryDisplay.inventory = playerInventoryManager.inventory
	hotBarDisplay.inventory = playerInventoryManager.hotbar
