extends Node2D

var genotype = [
		[
			["G", "G"] ,
			[]
		],
		[
			["R", "R"],
			["H", "h"]
		]
	]
func _ready():
	var child_genotype = Genome.cross_breed_genotype(genotype, genotype)
	var plant = load("res://Plant/PeaPlant/PeaPlant.tscn").instantiate()
	self.add_child(plant)
	plant.init(load("res://Plant/PeaPlant/GD_PeaPlant.tres").genome_definition, child_genotype)

