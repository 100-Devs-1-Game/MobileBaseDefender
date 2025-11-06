class_name VehicleMountedPartData
extends VehicleBasePartData

enum Category { WEAPON, UTILITY }
enum RotateMode { NONE, TWO_WAY, FOUR_WAY }

@export var category: Category
@export var rotate_mode: RotateMode



func init(_part_info: VehicleMountedPartInfo, _vehicle: Vehicle):
	pass


func tick(_part_info: VehicleMountedPartInfo, _vehicle: Vehicle, _delta: float): 
	pass


func get_power_usage(_part_info: VehicleMountedPartInfo)-> float:
	return power_required


func can_rotate()-> bool:
	return rotate_mode != RotateMode.NONE
