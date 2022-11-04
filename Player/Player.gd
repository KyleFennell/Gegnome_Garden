extends CharacterBody2D
class_name Player

@onready var UIRes = preload("res://UI/UIRes.tres")
@onready var inventory = preload("res://UI/Inventory/PlayerInventoryManager.tres")

const MAX_VELOCITY = 80
const ACCELERATION = 400
const FRICTION = 400

@onready var interactionArea = $InteractionArea2D

var plant1 = null
var plant2 = null

var acceleration: Vector2 = Vector2.ZERO

func _ready():
	var starter_seeds = preload("res://Items/Seeds/Pea_Generic.tres").duplicate()
	starter_seeds.quantity = 10
	inventory.add_item(preload("res://Items/Tools/Tool_Clippers.tres"))
	inventory.add_item(preload("res://Items/Tools/Tool_Seed_Rake.tres"))
	inventory.add_item(starter_seeds)
	
func _physics_process(delta: float) -> void:
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector*MAX_VELOCITY, ACCELERATION*delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION*delta)
	
	move_and_slide()
	
func _process(_delta: float) -> void:
	var area = interactionArea.highlight_area()
	if area:
		if Input.is_action_just_pressed("interact") and area.has_method("on_interact"):
			area.on_interact(inventory.hotbar.get_selected_item())
			
		if Input.is_action_just_pressed("test_1") and "plant" in area:
			if area.plant:
				UIRes.CrossBreedViewer.gene1 = area.plant
		if Input.is_action_just_pressed("test_2") and "plant" in area:
			if area.plant:
				UIRes.CrossBreedViewer.gene2 = area.plant
	if Input.is_action_just_pressed("test_3"):
		self.inventory.add_item(load("res://Items/Seeds/Pea_Seed.tres").duplicate())
	if Input.is_action_just_pressed("test_4"):
		var item = load("res://Items/Pea_Round.tres").duplicate()
		item.color = [Color("317545"), Color("f5cb53")][randi()%2]

		item.stackable = false
		self.inventory.add_item(item)

func process_interaction(node: Node):
	if "item" in node:
		inventory.add_item(node.item)

func _on_pickup_area_area_entered(area):
	if inventory.can_add_item(area.item):
		inventory.add_item(area.item)
		area.queue_free()
 
