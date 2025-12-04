class_name OrePickupData
extends BasePickupData



func on_pickup():
	Global.vehicle.inventory.ore+= 1


func get_type()-> PullTargetType:
	return PullTargetType.DRIVER
