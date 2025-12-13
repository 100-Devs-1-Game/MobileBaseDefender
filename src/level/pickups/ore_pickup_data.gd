class_name OrePickupData
extends BasePickupData

@export var type: Inventory.OreType



func on_pickup():
	Global.vehicle.inventory.add_ore(type, 1)


func get_type()-> PullTargetType:
	return PullTargetType.DRIVER
