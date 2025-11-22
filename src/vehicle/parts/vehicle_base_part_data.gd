@abstract
class_name VehicleBasePartData
extends Resource

@export var name: String
@export_multiline var description: String

@export var unlock_cost: int
@export var weight: int



@abstract
func get_build_mode_texture()-> Texture2D
