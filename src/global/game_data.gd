extends Node

@export var campaign: CampaignData
@export_dir var vehicle_parts_dir: String

var parts: Array[VehicleBasePartData]
var parts_class_lookup: Dictionary[Script, VehicleBasePartData]



func _ready() -> void:
	init_parts()


func init_parts():
	for file in ResourceLoader.list_directory(vehicle_parts_dir):
		if file.ends_with("/"):
			continue
		var part: VehicleBasePartData= load(str(vehicle_parts_dir, "/", file))
		parts.append(part)
		parts_class_lookup[part.get_script()]= part

	parts.sort_custom(func(a: VehicleBasePartData, b: VehicleBasePartData):
		return a.sort_order < b.sort_order)


func get_part_from_class(script: Script)-> VehicleBasePartData:
	assert(parts_class_lookup.has(script))
	return parts_class_lookup[script]
