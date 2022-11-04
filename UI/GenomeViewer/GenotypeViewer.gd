@tool
extends PanelContainer

@onready var gene_container = $VBoxContainer/Body/VBoxContainers/GeneContainer
@onready var GeneRow = preload("res://UI/GenomeViewer/GeneRow.tscn")
@onready var HighlightedArea = preload("res://ReusuableComponents/HighlightedArea.tres")

func _ready():
	HighlightedArea.connect("changed", highlighted_area_changed)

var genotype = null :
	set(value):
		genotype = value
		reset_container()
		populate_chromosome_containers()

func reset_container():
	for child in gene_container.get_children():
		child.queue_free()

func populate_chromosome_containers():
	for gene in genotype:
		var geneRow = GeneRow.instantiate()
		gene_container.add_child(geneRow)
		geneRow.gene = {"trait": gene, "values": genotype[gene]}
		

func highlighted_area_changed():
	if HighlightedArea.area and "plant" in HighlightedArea.area and HighlightedArea.area.plant:
		var plant = HighlightedArea.area.plant
		if plant.genome and plant.genome.genotype:
			genotype = plant.genome.genotype
	else:
		reset_container()
