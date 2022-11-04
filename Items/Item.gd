extends Resource
class_name Item

enum ITEM_TYPE {
	ITEM,
	SEED,
	TOOL
}

@export var name: String = ""
@export var texture: Texture
@export var quantity: int = 1
@export var stackable: bool = true
@export var remove_when_stack_empty: bool = true
@export var quantity_depletes: bool = true
@export var item_type: ITEM_TYPE = ITEM_TYPE.ITEM
var index: int = -1

signal item_used

func use():
	if quantity_depletes:
		quantity = quantity -1
	item_used.emit(self)
