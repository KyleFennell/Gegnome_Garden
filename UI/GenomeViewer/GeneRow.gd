extends HBoxContainer

@onready var geneNameLabel = $Panel/GeneNameLabel
@onready var genotypeLabel = $Panel2/GenotypeLabel

var gene = null :
	set(value):
		gene = value
		geneNameLabel.text = gene["trait"].name
		genotypeLabel.text = "".join(gene["values"])
