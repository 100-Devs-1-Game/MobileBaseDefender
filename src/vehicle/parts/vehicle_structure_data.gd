class_name VehicleStructureData
extends VehicleBasePartData

enum ConnectionSides { HORIZONTAL, VERTICAL, ALL }


@export var hitpoints: int
@export var connection_sides: ConnectionSides

@export var texture_stages: Array[Texture2D]



func get_build_mode_texture()-> Texture2D:
	return texture_stages[0]


func get_game_mode_texture(stage: int= 0)-> Texture2D:
	return texture_stages[stage]
