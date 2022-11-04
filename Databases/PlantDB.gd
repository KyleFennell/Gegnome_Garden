extends Node

class_name PlantDB
enum {PEA}

var names = {PEA: "Pea"}

var genomes = {
	PEA: [
		[
			"res://Plant/PeaPlant/T_PeaColor.tres",
		], 
		[
			"res://Plant/PeaPlant/T_PeaHeight.tres",
			"res://Plant/PeaPlant/T_PeaShape.tres",
		]
	]
}

var data = {}

func _init():
	_add_plantData(PEA, genomes[PEA], 2)
	
func _add_plantData(plantEnum: int, genome: Array, ploidy: int):
	data[plantEnum] = Plant.new(Genome.new(genome, ploidy))
