extends Resource
class_name Trait

@export var name: String
@export var alleles: Array = []
# example
# C is dominant over all
# c_ch is co-dominant with c_h and pc
# c_h is co_dominant with c_a
# c_a is dominant over c
# c is recessive
# alleles = ["C", ["c_ch", "c_h", c], ["c_h", "c_a"], "c_a", c]
@export var dominant_presentations: Dictionary = {}
@export var codominant_presentations: Dictionary = {}
@export var property: String
# example
# C is black
# c_ch is chinchilla
# c_h is himalayan
# c_a is albino
# c is translucent
# [c_ch, c_h, c] is gray
# [c_h, c_a] is light gray
# dominant_presentations = {
#	"C": Color(0, 0, 0, 1),
#	"c_ch": Color(0.3, 0.3, 0.1, 1),
#	"c_h": Color(0.5, 0.5, 0.65, 1),
#	"c": Color(0.5, 0.5, 0.5, 0.5)
# }
# co_dominant_presentations = {
#	["c_ch", "c_h", "c"]: Color(0.3, 0.3, 0.3, 1),
#	["c_h", "c_a"]: Color(0.8, 0.8, 0.8, 1)
# }
func check_dominance(allele1: String = "", allele2: String = "") -> int:
	#returns 1 if allele1 is dominant, 0 if they are co-dominant, and -1 if allele2 is dominant
	if allele1 == "":
		return -1
	if allele2 == "":
		return 1
	if allele1 == allele2:
		#homozygous "co-dominance"
		return 0
	for val in alleles:
		#if potential for co-dominance
		if typeof(val) == TYPE_ARRAY:
			#check regular dominance
			if val[0] == allele1:
				return 1
			elif val[0] == allele2:
				return -1
		#check regular dominance
		elif val == allele1:
			return 1
		elif val == allele2:
			return -1
	# print("invlaid gene dominance check ", self.name, allele1, allele2)
	return 0
	
func compare_alleles(allele1: String = "", allele2: String = "") -> bool:
	return check_dominance(allele1, allele2) > 0
	
func get_phenotype_from_genotype(genotype: Array) -> Array:
	if genotype.size() == 1:
		return genotype
	genotype.sort_custom(self.compare_alleles)	
	if alleles.has(genotype[0]) or genotype[0] == genotype[1]:
		return [genotype[0]]
	return [genotype[0], genotype[1]]

func get_presentation(genotype: Array):
	var presenting_alleles = get_phenotype_from_genotype(genotype)
	if presenting_alleles.size() == 1:
		return {"property": property, "value": dominant_presentations[presenting_alleles[0]]}
	else:
		for group in codominant_presentations:
			var valid = true
			for allele in genotype:
				if not group.has(allele):
					valid = false
					break;
			if valid:
				return {"property": property, "value": codominant_presentations[group]}
