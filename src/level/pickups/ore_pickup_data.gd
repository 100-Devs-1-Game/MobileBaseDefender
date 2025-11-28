class_name OrePickupData
extends BasePickupData



func on_pickup():
	pass


func get_type()-> PullTargetType:
	return PullTargetType.DRILL
