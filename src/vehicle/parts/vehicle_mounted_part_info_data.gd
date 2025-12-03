class_name VehicleMountedPartInfo
extends Resource

const rotations: Array[Vector2i]= [ Vector2i.UP, Vector2i.RIGHT, Vector2i.DOWN, Vector2i.LEFT ]

@export var part: VehicleMountedPartData
@export var rotation: Vector2i= Vector2i.UP
@export var enabled: bool= true
@export var group_id: int

var live_data: Dictionary


#func _init(p_part: VehicleMountedPartData= null, rot: Vector2i= Vector2i.UP):
	#part= p_part
	#rotation= rot
