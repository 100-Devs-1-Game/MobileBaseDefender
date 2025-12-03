@abstract
class_name VehicleBasePartData
extends Resource

@export var name: String
@export_multiline var description: String

@export var cost: int
@export var weight: int
@export var can_be_built: bool= true
@export var sort_order: String= "h"



@abstract
func get_build_mode_texture()-> Texture2D


func get_stats_str()-> String:
	return "Weight: %dkg " % cost
