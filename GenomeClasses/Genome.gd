extends Node
class_name Genome

var raw_genotype = []
var genotype = {}
var phenotype = {}
var presentations = {}

func _init(_genome_definition: Array = [], _raw_genotype: Array = [], _ploydal: int = 2):
	raw_genotype = _raw_genotype
	create_genome(_genome_definition, _ploydal)
	if raw_genotype != []:
		populate_genome(raw_genotype)

func _ready():
	if genotype.is_empty():
		calculate_genotype()
	if raw_genotype.is_empty():
		calculate_raw_genotype()
	if phenotype.is_empty():
		calculate_phenotype()
	if presentations.is_empty():
		calculate_presentations()

func create_genome(structure: Array, ploydal: int = 2) -> Genome:
# example structure
# structure = [ 
#	[ "res://Plant/PeaPlant/T_PeaColor.tres", ""res://Genome Classes/T_NonCoding.tres"" ], 
#	[ "res://Plant/PeaPlant/T_PeaShape.tres", "res://Plant/PeaPlant/T_PeaHeight.tres" ]
# ]
	name = "Genome"
	for chromosome_no in range(structure.size()):
		var chromosome_group_node = Node.new()
		chromosome_group_node.name = "Chromosome" + str(chromosome_no)
		for i in ploydal:
			var chromosome_node = Node.new()
			chromosome_node.name = "C" + str(i) + "_" + str(chromosome_no)
			for gene in structure[chromosome_no]:
				var gene_node = Gene.new()
				chromosome_node.add_child(gene_node)
				gene_node.name = gene.name
				gene_node.gene = gene
			chromosome_group_node.add_child(chromosome_node)
		add_child(chromosome_group_node)
	return self

func populate_genome(genotype_values: Array) -> void:
# must mirror the structure of the genes in the genome with non coding genes as null or []
# genes = [
#	[ ["G", "g"], [] ]
#	[ ["R", "R"], ["h", "h"] ]
# ]
	raw_genotype = genotype_values
	for chromosome_group_no in genotype_values.size() if genotype_values else 0:
		var chromosome_group = genotype_values[chromosome_group_no]
		for gene_no in chromosome_group.size() if chromosome_group else 0:
			var gene = chromosome_group[gene_no]
			for chromosome_id in gene.size() if gene else 0:
				var allele = gene[chromosome_id]
				var chromosome_group_node = get_child(chromosome_group_no)
				var chromosome_node = chromosome_group_node.get_child(chromosome_id)
				var gene_node = chromosome_node.get_child(gene_no)
				gene_node.value = allele
				

func calculate_genotype() -> Dictionary:
	for group in self.get_children():
		for chromosome in group.get_children():
			for gene in chromosome.get_children():
				if gene.is_non_coding():
					continue
				else:
					if genotype.has(gene.gene):
						genotype[gene.gene].append(gene.value)
					else:
						genotype[gene.gene] = [gene.value]
	return genotype

func calculate_phenotype() -> Dictionary:
	for gene in genotype:
		phenotype[gene] = gene.get_phenotype_from_genotype(genotype[gene])
	return phenotype
	
func calculate_presentations() -> Dictionary:
	for gene in genotype:
		presentations[gene.property] = gene.get_presentation(genotype[gene])
	return presentations
	
func randomise_genotype():
	for group in get_children():
		for chromosome in group.get_children():
			for gene in chromosome.get_children():
				if gene.is_non_coding():
					continue
				else:
					var random_allele = gene.gene.alleles[randi()%gene.gene.alleles.size()]
					gene.value = random_allele if typeof(random_allele) == TYPE_STRING else random_allele[0]
					
	return genotype
	
func calculate_raw_genotype() -> Array:
	for chromosome_i in get_children().size():
		var chromosome = get_child(chromosome_i)
		raw_genotype.append([])
		for group_i in chromosome.get_children().size():
			var group = chromosome.get_child(group_i)
			for gene_i in group.get_children().size():
				if group_i == 0: raw_genotype[chromosome_i].append([])
				var gene = group.get_child(gene_i)
				if not gene.is_non_coding():
					raw_genotype[chromosome_i][gene_i].append(gene.value)
	return raw_genotype
	
static func shuffle_chromosomes(_genotype: Array) -> Array:
	var new_genotype = _genotype.duplicate(true)
	for chromosome_group_i in new_genotype.size():
		var chromosome_group = new_genotype[chromosome_group_i]
		for gene_i in chromosome_group.size():
			var gene = chromosome_group[gene_i]
			if gene.size() < 1:
				break;
			var shuffle_key = gene.size()
			shuffle_key.shuffle()
			for index in gene.size():
				var new_gene = []
				for index in shuffle_key:
					new_gene.append(gene[index])
				new_genotype[chromosome_group_i][gene_i] = new_gene
	return new_genotype
				
static func cross_breed_genotype(genotype1: Array, genotype2: Array) -> Array:
	var child_genotype = []
	if genotype1.size() != genotype2.size(): return []
	for chromosome_group_i in genotype1.size():
		var child_group = cross_breed_chromosome(
			shuffle_chromosomes(genotype1)[chromosome_group_i], 
			shuffle_chromosomes(genotype2)[chromosome_group_i]
		)
		child_genotype.append(child_group)
	return child_genotype

static func cross_breed_chromosome(chromosome1: Array, chromosome2: Array) -> Array:
	var child_chromosome = []
	if chromosome1.size() != chromosome2.size(): return []
	for gene_i in chromosome1.size():
		var gene = cross_breed_gene(chromosome1[gene_i], chromosome2[gene_i])
		child_chromosome.append(gene)
	return child_chromosome
	
static func cross_breed_gene(gene1: Array, gene2: Array) -> Array:
	var child_gene = []
	if gene1 == [] and gene2 == []: return []
	if gene1.size() != gene2.size(): return []
	var gene_swapped = randi()%2 == 0
	for allele_i in gene1.size():
		gene_swapped = !gene_swapped if randi()%gene1.size() == 0 else gene_swapped		#flip with a 1/size chance
		child_gene.append((gene1 if gene_swapped else gene2)[allele_i])
	return child_gene
	
static func generate_genotypes_from_variation(genomic_variations: Array) -> Array:
	var sizes = get_variation_sizes(genomic_variations)
	var prods = [1]
	var total_genotypes = 1
	var genotypes = []
	for s_i in sizes.size():
		var size = sizes[s_i]
		total_genotypes *= size if size != 0 else 1
		prods.append(prods[s_i]*(size if size != 0 else 1))
	# print("sizes ", sizes, " prods ", prods, " total ", total_genotypes)
	for genotype_i in total_genotypes:
		var new_genotype = []
		var gene_count = 0
		for chromosome_i in genomic_variations.size():
			var chromosome = genomic_variations[chromosome_i]
			new_genotype.append([])
			for gene_i in chromosome.size():
				var gene = []
				if sizes[gene_count] != 0:
					var temp = genomic_variations[chromosome_i]
					temp = temp[gene_i]
					var index = prods[gene_i]
					index = genotype_i/index
					var index_1 = sizes[gene_count]
					index = index%index_1
					temp = temp[index]
					gene = genomic_variations[chromosome_i][gene_i][(genotype_i/prods[gene_count])%sizes[gene_count]]
				new_genotype[chromosome_i].append(gene)	
				gene_count += 1
		genotypes.append(new_genotype)
		# print(new_genotype)
	return genotypes
	
static func get_variation_sizes(genomic_variations: Array) -> Array:
	var sizes = []
	for chromosome in genomic_variations:
		for gene in chromosome:
			sizes.append(gene.size())
	return sizes
	
static func generate_genomic_variations(genotype1: Array, genotype2: Array) -> Array:
	var variations_container = []
	for chromosome_i in genotype1.size():
		var chromosome = genotype1[chromosome_i]
		variations_container.append([])
		for gene_i in chromosome.size():
			var gene_variations = get_permutations(
				genotype1[chromosome_i][gene_i],
				genotype2[chromosome_i][gene_i]
			)
			variations_container[chromosome_i].append(gene_variations)
	return variations_container
	
static func get_permutations(arr1: Array, arr2: Array) -> Array:
	var permutations = []
	for i in arr1:
		for j in arr2:
			permutations.append([i, j])
	return permutations

static func generate_unique_genomic_variations(genotype1: Array, genotype2: Array) -> Array:
	var all_genomic_variations = generate_genomic_variations(genotype1, genotype2)
	for chromosome_i in all_genomic_variations.size():
		var chromosome = all_genomic_variations[chromosome_i]
		for gene_i in chromosome.size():
			var unique_variations = []
			for variation in chromosome[gene_i]:
				variation.sort()
				if not variation in unique_variations:
					unique_variations.append(variation)
			all_genomic_variations[chromosome_i][gene_i] = unique_variations
	return all_genomic_variations

