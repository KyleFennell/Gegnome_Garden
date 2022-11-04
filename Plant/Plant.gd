extends Sprite2D
class_name Plant

@onready var UIRes = preload("res://UI/UIRes.tres")

var GroudItem = preload("res://Items/GroundItem.tscn")

var genome_definition: Array = []
var genome: Node = null
var partner: Plant = null
var presentations: Dictionary = {}

func init(_genome_definition: Array, _genotype: Array = []):
	genome_definition = _genome_definition
	if _genotype != []:
		genome = Genome.new(_genome_definition, _genotype)
		genome.populate_genome(_genotype)
	else:
		genome = Genome.new(genome_definition)
		genome.randomise_genotype()
	add_child(genome)
	populate_presentations()

func _ready():
	if not genome and genome_definition != []:
		genome = Genome.new(genome_definition)
	if genome:
		populate_presentations()

func populate_presentations():
	for p in genome.presentations:
		var value = genome.presentations[p].value
		match Array(p.split("_")):
			["fruit", "color"]:
				material.set_shader_param("fruit_color", value)
				presentations["fruit_color"] = value
			["sprite", "scale", var attribute]:
				if attribute == "x":
					scale.x = value
				elif attribute == "y":
					scale.y = value
			["item", "texture"]:
				presentations["item_texture"] = value

func get_seed_item() -> SeedItem:
	var seed_item = SeedItem.new().duplicate()
	seed_item.color = presentations["fruit_color"]
	seed_item.genotype = genome.genotype
	seed_item.raw_genotype = genome.raw_genotype
	seed_item.texture = presentations["item_texture"]
	seed_item.stackable = false
	seed_item
	return seed_item 

func harvest(item: Item) -> bool:
	var seed_item
	var count = randi()%(presentations["seed_quantity"]  if "seed_quantity" in presentations else 3)+1
	if item == preload("res://Items/Tools/Tool_Clippers.tres"):
		seed_item = get_seed_item();
	elif item == preload("res://Items/Tools/Tool_Seed_Rake.tres"):
		seed_item = preload("res://Items/Seeds/Pea_Generic.tres")
	else:
		return false
	for i in count:
		var ground_seed_item = GroudItem.instantiate()
		ground_seed_item.item = seed_item.duplicate()
		ground_seed_item.position += position + Vector2(randi()%10-5, randi()%10-5)
		get_parent().add_child(ground_seed_item)
	queue_free()
	return true
		

func get_texture_rect() -> TextureRect:
	var texRec = TextureRect.new()
	texRec.texture = texture
	texRec.material = material
	texRec.stretch_mode = TextureRect.STRETCH_SCALE
	texRec.ignore_texture_size = true
	texRec.minimum_size = texture.get_size()*scale
	return texRec
