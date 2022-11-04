extends Area2D

@onready var HighlightedArea = preload("res://ReusuableComponents/HighlightedArea.tres")
@onready var highlightSprite = $HighlightSprite

signal area_changed

func highlight_area() -> Area2D:
	var area = get_area_to_highlight()
	if area != null:
		highlightSprite.global_position = area.global_position
		highlightSprite.show()
	else:
		highlightSprite.hide()
	return area

func get_area_to_highlight() -> Area2D:
	var interaction_areas = get_overlapping_areas()
	var min_dist = 1000000
	var best_area = null
	for area in interaction_areas:
		if area.has_method("can_interact"):
			if area.can_interact(self):
				var dist = global_position.distance_squared_to(area.global_position)
				if dist < min_dist:
					min_dist = global_position.distance_squared_to(area.global_position)
					best_area = area
	if best_area != HighlightedArea.area:
		HighlightedArea.area = best_area
	return best_area
