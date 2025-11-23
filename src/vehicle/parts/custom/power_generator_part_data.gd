class_name VehiclePowerGeneratorPartData
extends VehicleMountedPartData

@export var power_generated: int



func get_power_production(_part_info: VehicleMountedPartInfo)-> float:
	return power_generated
