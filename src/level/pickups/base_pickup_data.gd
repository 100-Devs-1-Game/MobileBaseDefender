@abstract
class_name BasePickupData
extends Resource

enum PullTargetType { DRIVER, DRILL }

@export var texture: Texture2D



@abstract
func on_pickup()


@abstract
func get_type()-> PullTargetType


func get_max_speed()-> float:
	return 500.0
