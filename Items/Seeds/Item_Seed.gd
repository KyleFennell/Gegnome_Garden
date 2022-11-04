extends Item
class_name SeedItem

@export var raw_genotype: Array
@export var genotype: Dictionary
@export var identified: bool = false
@export var color: Color

func _init():
	self.item_type = ITEM_TYPE.SEED
