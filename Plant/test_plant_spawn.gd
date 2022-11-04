extends Node

var PeaPlant = preload("res://Plant/PeaPlant/PeaPlant.tscn")

var genome_definition = [
	[
		"res://Plant/PeaPlant/T_PeaColor.tres" 
	], 
	[
		"res://Plant/PeaPlant/T_PeaHeight.tres",
		"res://Plant/PeaPlant/T_PeaShape.tres"
	]
]

#var genotype = [
#	[
#		["g", "g"], 
#	], 
#	[
#		["h", "H"],
#		["r", "r"]
#	]
#]

func _ready():
	var pea_plant = PeaPlant.instance()
	pea_plant.init(genome_definition)
	add_child(pea_plant)
