class_name SpawnerDefinition
extends Resource

@export var scene: PackedScene
@export var density: float= 0.2
@export var min_stage: int= 0


func spawn(level: Level, tile_pos: Vector2i):
	var spawner_obj: Node2D= scene.instantiate()
	spawner_obj.position= level.tile_map_floor.map_to_local(tile_pos)
	level.add_child(spawner_obj)
