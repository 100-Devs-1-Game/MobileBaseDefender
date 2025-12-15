class_name VehiclePowerStoragePartData
extends VehicleMountedPartData

@export var storage_capacity: int


func get_stats_str()-> String:
	return super() + " Power capacity: %d" % storage_capacity
