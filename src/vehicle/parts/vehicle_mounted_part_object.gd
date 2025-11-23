class_name VehicleMountedPartObject
extends Node2D

var part_info: VehicleMountedPartInfo



func init(info: VehicleMountedPartInfo):
	part_info= info


func tick(_vehicle: Vehicle, _delta: float):
	pass


func physics_tick(_vehicle: Vehicle, _delta: float):
	pass
