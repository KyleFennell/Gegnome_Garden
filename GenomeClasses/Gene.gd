extends Node
class_name Gene

@export var gene: Resource
@export var value: String
@export var tags: Array[String]

func initialise(_gene: Trait = null, _value: String = "", _tags: Array = []) -> void:
	self.gene = _gene if not self.gene else self.gene
	self.value = _value if self.value == "" else self.value
	self.tags = _tags if self.tags == [] else self.tags
	if self.value == "":
		randomize_gene()

func randomize_gene() -> void:
	self.value = gene.values[randi()%gene.values.size()]

func is_non_coding():
	return gene == null or gene.alleles == []
