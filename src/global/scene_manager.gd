extends Node

@export var level_scene: PackedScene

var vehicle_layout: VehicleLayout



func load_level():
	get_tree().change_scene_to_packed(level_scene)
