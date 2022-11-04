extends Area2D
class_name InteractableArea

@onready var interactionAreaShape = $CollisionShape2D

func on_interact(item: Item):
	pass
	
func can_interact(something: Object) -> bool:
	return true
