class_name VehicleWheelPart
extends VehicleMountedPartData

const INPUT_DATA= "input"

@export var acceleration_factor: float= 10.0
@export var rotation_factor: float= 10.0



func init(part_info: VehicleMountedPartInfo, _vehicle: Vehicle):
	part_info.live_data[INPUT_DATA]= 0.0


func tick(part_info: VehicleMountedPartInfo, vehicle: Vehicle, _tile_pos: Vector2i, _delta: float): 
	var input: VehicleAxisControlInput
	var accelerate: bool= is_acceleration_wheel(part_info)
	input= vehicle.controls.drive if accelerate else vehicle.controls.steer

	if accelerate:
		vehicle.acceleration_force+= input.strength * acceleration_factor * vehicle.power_supply_ratio
	else:
		vehicle.rotation_torque+= input.strength * rotation_factor * vehicle.power_supply_ratio

	part_info.live_data[INPUT_DATA]= input.strength


func get_power_usage(part_info: VehicleMountedPartInfo)-> float:
	return abs(part_info.live_data[INPUT_DATA]) * power_required


static func is_acceleration_wheel(part_info: VehicleMountedPartInfo)-> bool:
	return part_info.rotation.y != 0
