class_name VehicleDriverPart
extends VehicleMountedPartData

@export var acceleration_factor: float= 1.0
@export var rotation_factor: float= 1.0



func tick(_part_info: VehicleMountedPartInfo, vehicle: Vehicle, _tile_pos: Vector2i, _delta: float): 
	var drive:= vehicle.controls.drive
	var steer:= vehicle.controls.steer

	vehicle.acceleration_force+= drive.strength * acceleration_factor
	vehicle.rotation_torque+= steer.strength * rotation_factor
