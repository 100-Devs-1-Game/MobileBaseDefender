@abstract
class_name VehicleMountedPartData
extends VehicleBasePartData

enum Category { WEAPON, UTILITY }
enum RotateMode { NONE, TWO_WAY, FOUR_WAY }

@export var category: Category
@export var rotate_mode: RotateMode

@export var power_required: int
@export var build_mode_texture: Texture2D
@export var game_mode_texture: Texture2D
@export var game_mode_scene: PackedScene
@export var full_visual_replacement: bool= false



func get_build_mode_texture()-> Texture2D:
	if not build_mode_texture:
		assert(game_mode_texture)
		return game_mode_texture
	return build_mode_texture


func init(_part_info: VehicleMountedPartInfo, _vehicle: Vehicle):
	pass


func tick(_part_info: VehicleMountedPartInfo, _vehicle: Vehicle,  _tile_pos: Vector2i, _delta: float): 
	pass


func get_power_usage(_part_info: VehicleMountedPartInfo)-> float:
	return power_required


func get_power_production(_part_info: VehicleMountedPartInfo)-> float:
	return 0


func can_rotate()-> bool:
	return rotate_mode != RotateMode.NONE
