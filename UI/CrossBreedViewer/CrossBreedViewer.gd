extends PanelContainer

@onready var parent1Preview = $VBoxContainer/CenterContainer/HBoxContainer/MarginContainer/Parent1Preview
@onready var parent2Preview = $VBoxContainer/CenterContainer/HBoxContainer/MarginContainer2/Parent2Preview
@onready var childrenGrid = $VBoxContainer/MarginContainer2/CenterContainer/ChildrenGrid

const PeaPlant = preload("res://Plant/PeaPlant/PeaPlant.tscn")
const PeaPlant_GD = preload("res://Plant/PeaPlant/GD_PeaPlant.tres")
const ChildContainer = preload("res://UI/CrossBreedViewer/ChildContainer.tscn")

var gene1: Plant = null:
	set(value):
		gene1 = value
		var new_preview = gene1.get_texture_rect()
		new_preview.name = "Parent1Preview"
		parent1Preview.replace_by(new_preview)
		parent1Preview = new_preview
		recalculate_children()
var gene2: Plant = null:
	set(value):
		gene2 = value
		var new_preview = gene2.get_texture_rect()
		new_preview.name = "Parent2Preview"
		parent2Preview.replace_by(new_preview)
		parent2Preview = new_preview
		recalculate_children()
		
func recalculate_children():
	if gene1 and gene2:
		for child in childrenGrid.get_children():
			child.queue_free()
		if gene1.genome_definition != gene2.genome_definition:
			return
		var unique_variations = Genome.generate_unique_genomic_variations(
			gene1.genome.raw_genotype, 
			gene2.genome.raw_genotype)
		var unique_children = Genome.generate_genotypes_from_variation(unique_variations)
		for child_genotype in unique_children:
			var child_container = ChildContainer.instantiate()
			var plant = PeaPlant.instantiate()
			plant.init(PeaPlant_GD.genome_definition, child_genotype)
			plant.hide()
			childrenGrid.add_child(child_container)
			child_container.add_child(plant)
			child_container.add_child(plant.get_texture_rect())
			
