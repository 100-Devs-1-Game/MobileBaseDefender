class_name MinimapData
extends Resource

@export_storage var size: Vector2i
@export_storage var factor: float
@export var target: Rect2i
@export_storage var texture: Texture2D



func get_local_pos(global_pos: Vector2)-> Vector2:
	return global_pos * factor / 128.0 + Vector2(size) / 2
