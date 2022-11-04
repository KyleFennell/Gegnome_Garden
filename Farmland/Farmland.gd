extends InteractableArea

enum {
	DIRT,
	TILLED,
	GROWING,
	HARVESTABLE
}

signal tile_id_changed
signal changed_state

var tile_pos = Vector2.ZERO
var state:
	set(value):
		state = value
		emit_signal("changed_state")
		
var plant: Plant = null

func initialise(_tile_pos: Vector2):
	self.tile_pos = _tile_pos
	
func _ready():
	state = DIRT
	pass 

func on_interact(item: Item = null):
	if state == DIRT:
		state = TILLED
		emit_signal("tile_id_changed", tile_pos, 1, 1, 0)
		return
	if item == null: return
	if item.item_type == Item.ITEM_TYPE.SEED:
		if state == TILLED:
			create_plant(item)
			state = HARVESTABLE
			item.use()
			return
	elif item.item_type == Item.ITEM_TYPE.TOOL:
		if state == HARVESTABLE:
			plant.harvest(item)
			plant = null
			state = TILLED
			return

func can_interact(something: Object):
	return true

var PeaPlant = preload("res://Plant/PeaPlant/PeaPlant.tscn")

func create_plant(seed: SeedItem = null):
	var pea_plant = PeaPlant.instantiate()
	if seed != null:
		pea_plant.init(load("res://Plant/PeaPlant/GD_PeaPlant_with_shape.tres").genome_definition, seed.raw_genotype)
	else:
		pea_plant.init(load("res://Plant/PeaPlant/GD_PeaPlant_with_shape.tres").genome_definition)
	add_child(pea_plant)
	pea_plant.position.y -= 4
	plant = pea_plant
