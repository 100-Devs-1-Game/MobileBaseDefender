extends Node

@export_dir var vehicle_parts_dir: String

var parts_class_lookup: Dictionary[Script, VehicleBasePartData]


func _ready() -> void:
	init_parts_lookup()


func init_parts_lookup():
	for file in ResourceLoader.list_directory(vehicle_parts_dir):
		var part: VehicleBasePartData= load(str(vehicle_parts_dir, "/", file))
		parts_class_lookup[part.get_script()]= part


func get_part_from_class(script: Script)-> VehicleBasePartData:
	assert(parts_class_lookup.has(script))
	return parts_class_lookup[script]
