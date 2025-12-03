class_name VehicleThrusterPartData
extends VehicleMountedPartData



const INPUT_DATA= "input"

@export var rotation_factor: float= 10.0



func init(part_info: VehicleMountedPartInfo, _vehicle: Vehicle):
	part_info.live_data[INPUT_DATA]= 0.0


func tick(part_info: VehicleMountedPartInfo, vehicle: Vehicle, _tile_pos: Vector2i, _delta: float): 
	var input_strength:= vehicle.controls.steer.strength
	vehicle.rotation_torque+= input_strength * rotation_factor * vehicle.power_supply_ratio
	part_info.live_data[INPUT_DATA]= input_strength


func get_power_usage(part_info: VehicleMountedPartInfo)-> float:
	return abs(part_info.live_data[INPUT_DATA]) * power_required
