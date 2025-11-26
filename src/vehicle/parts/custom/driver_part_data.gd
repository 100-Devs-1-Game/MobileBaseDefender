class_name VehicleDriverPartData
extends VehicleMountedPartData

const BRAKE_ENERGY_DATA= "brake"

@export var acceleration_factor: float= 1.0
@export var rotation_factor: float= 1.0
@export var brake_power_usage_factor: float= 0.1



func init(part_info: VehicleMountedPartInfo, _vehicle: Vehicle):
	part_info.live_data[BRAKE_ENERGY_DATA]= 0.0


func tick(part_info: VehicleMountedPartInfo, vehicle: Vehicle, _tile_pos: Vector2i, _delta: float): 
	var drive:= vehicle.controls.drive
	var steer:= vehicle.controls.steer
	var is_braking:= vehicle.controls.brake.toggled

	vehicle.acceleration_force+= drive.strength * acceleration_factor
	vehicle.rotation_torque+= steer.strength * rotation_factor

	var brake_energy: float= 0
	if is_braking:
		brake_energy= abs(vehicle.speed) * vehicle.mass / 100.0
	part_info.live_data[BRAKE_ENERGY_DATA]= brake_energy


func get_power_usage(part_info: VehicleMountedPartInfo)-> float:
	return part_info.live_data[BRAKE_ENERGY_DATA] * brake_power_usage_factor
