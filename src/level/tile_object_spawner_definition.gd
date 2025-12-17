class_name TileObjectSpawnerDefinition
extends SpawnerDefinition

@export var tile_id: int


func spawn(level: Level, tile_pos: Vector2i):
	level.tile_map_objects.set_cell(tile_pos, 0, Vector2i.ZERO, tile_id)
