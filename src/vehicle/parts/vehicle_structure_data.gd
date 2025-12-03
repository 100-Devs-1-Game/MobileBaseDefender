class_name VehicleStructureData
extends VehicleBasePartData

@export var hitpoints: int

@export var texture_stages: Array[Texture2D]



func get_build_mode_texture()-> Texture2D:
	return texture_stages[0]


func get_game_mode_texture(stage: int= 0)-> Texture2D:
	return texture_stages[stage]


func get_stats_str()-> String:
	return super() + "Hitpoints: %d" % hitpoints
