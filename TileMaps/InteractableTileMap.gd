@tool
extends TileMap

signal added_child

@onready var half_cell_size := tile_set.tile_size * 0.5

var TILE_SCENES = {
	1: {
		"scene": preload("res://Farmland/Farmland.tscn")
	}
}

func _ready():
	_replace_tiles_with_scenes()

func _replace_tiles_with_scenes(scene_dictionary: Dictionary = TILE_SCENES):
	for tile_pos in get_used_cells(0):
		var tile_id = get_cell_source_id(0, tile_pos, false)
		if scene_dictionary.has(tile_id):
			var object_scene = scene_dictionary[tile_id]["scene"]
			_replace_tile_with_object(tile_pos, object_scene, get_parent().get_node("YSort/Farmland"))

func _replace_tile_with_object(tile_pos: Vector2, object_scene: PackedScene, parent: Node = get_tree().current_scene):	
	# Spawn the object
	if object_scene:
		var obj = object_scene.instantiate()
		obj.initialise(tile_pos)
		obj.connect("tile_id_changed", _tile_changed)
		var obj_pos = map_to_world(tile_pos)
		obj.global_position = to_global(obj_pos)
		parent.add_child(obj)

func _tile_changed(tile_pos: Vector2i, layer: int = 0, terrain_set: int = 0, tile_id: int = -1):
	if get_cell_source_id(0, tile_pos, false) != -1:
		set_cells_terrain_connect(layer, [tile_pos], terrain_set, tile_id)
		force_update(0)

func _check_tilled_border(tile_pos: Vector2):
	if (get_cell_source_id(0, get_neighbor_cell(tile_pos, TileSet.CELL_NEIGHBOR_BOTTOM_SIDE), false) == 1 or
		get_cell_source_id(0, get_neighbor_cell(tile_pos, TileSet.CELL_NEIGHBOR_TOP_SIDE), false) == 1 or
		get_cell_source_id(0, get_neighbor_cell(tile_pos, TileSet.CELL_NEIGHBOR_LEFT_SIDE), false) == 1 or
		get_cell_source_id(0, get_neighbor_cell(tile_pos, TileSet.CELL_NEIGHBOR_RIGHT_SIDE), false) == 1):
			set_cell(0, tile_pos, 4)
