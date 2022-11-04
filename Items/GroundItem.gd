extends Area2D

@onready var magnet_area = %MagnetArea
@onready var sprite = %Sprite

var item: Item
var tracking_target = null
var tracking_speed = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	update_appearance()

func update_appearance():
	sprite.texture = item.texture
	if "color" in item:
		sprite.material = ShaderMaterial.new()
		sprite.material.shader = load("res://UI/Tinter.gdshader")
		sprite.material.set_shader_param("tint_color", item.color)
		sprite.material.set_shader_param("enabled", true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if tracking_target:
		global_position += (tracking_target.global_position - global_position).normalized() * tracking_speed
		
func _on_magnet_area_area_entered(area: Area2D):
	print(area.get_parent() is Player and area.parent.inventory.can_add_item(item))
	if area.get_parent() is Player and area.parent.inventory.can_add_item(item):
		tracking_target = area
		print("tracking ", area.get_parent().name)
	else:
		print("not tracking because no space in inventory")
		
func _on_collision_area_area_entered(_area: Area2D):
	pass # Replace with function body.
